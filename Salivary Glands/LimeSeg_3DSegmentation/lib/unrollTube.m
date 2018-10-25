function [neighs_real,sides_cells] = unrollTube(img3d, outputDir, noValidCells, colours)
%UNROLLTUBE Summary of this function goes here
%   Detailed explanation goes here

    %% Rotate the gland
    [Y, X, Z] = ndgrid(1:size(img3d,1), 1:size(img3d,2), 1:size(img3d,3));
    XYZ0 = [X(:), Y(:), Z(:), zeros(numel(X),1)];
    
    imgProperties = regionprops3(img3d>0, {'Orientation', 'PrincipalAxisLength'});
    angleRotation = deg2rad(-cat(2,imgProperties.Orientation));

    M = makehgtform('zrotate', angleRotation(1)); %X axis
    
    newXYZ0 = XYZ0 * M;
    nX = round(reshape(newXYZ0(:,1), size(X)));
    nY = round(reshape(newXYZ0(:,2), size(Y)));
    nZ = round(reshape(newXYZ0(:,3), size(Z)));

%     figure; pcshow([X(img3d(:)>0), Y(img3d(:)>0), Z(img3d(:)>0)])
%     figure; pcshow([nX(img3d(:)>0), nY(img3d(:)>0), nZ(img3d(:)>0)])
    if ~isempty ( nY < 0) 
       nY = abs(min(nY(:))) + 1 + nY; 
    end
    
    if ~isempty ( nX < 0) 
       nX = abs(min(nX(:))) + 1 + nX; 
    end
    
    img3DRotated = zeros(max(nX(:)), max(nY(:)), max(nZ(:)));
    
    labelIndices = sub2ind(size(img3DRotated), nX(img3d(:)>0), nY(img3d(:)>0), nZ(img3d(:)>0));
    
    img3DRotated(labelIndices) = img3d(img3d(:)>0);
    

    %% Unroll
    pixelSizeThreshold = 1;
    
    img3d = permute(img3DRotated, [1 3 2]);
    imgFinalCoordinates=cell(size(img3d,3),1);
    imgFinalCoordinates3x=cell(size(img3d,3),1);

    for coordZ = 1 : size(img3d,3)
        [x, y] = find(img3d(:, :, coordZ) > 0);
        
        if length(x) > pixelSizeThreshold
            centroidCoordZ = mean([x, y]); % Centroid of each real Y of the cylinder
            centroidX = centroidCoordZ(1);
            centroidY = centroidCoordZ(2);

            %% Create perimeter mask
            mask=false(size(img3d(:,:,1)));
            mask(img3d(:,:,coordZ)>0)=1;
            [x,y]=find(mask);

            %zPerimMask=bwperim(imgToPerim);
            imgToPerim = img3d(:, :, coordZ);
            imgToPerim = imdilate(imgToPerim, strel( 'disk', 5));
            imgToPerim = imerode(imgToPerim, strel('disk', 5));
            zPerimMask=bwperim(imgToPerim);
            [xPerim, yPerim]=find(zPerimMask);
            
            %angles coord perim regarding centroid
            anglePerimCoord = atan2(yPerim - centroidY, xPerim - centroidX);
            %find the sorted order
            [anglePerimCoordSort,~] = sort(anglePerimCoord);
            
%             anglePerimCoordSort = repmat(anglePerimCoordSort, 3, 1);
%             x = repmat(x, 3, 1);
%             y = repmat(y, 3, 1);

            %% labelled mask
            maskLabel=img3d(:,:,coordZ);
            %angles label coord regarding centroid
            angleLabelCoord = atan2(y - centroidY, x - centroidX);

            %% Assing label to pixels of perimeters
            %If a perimeter coordinate have no label pixels in a range of pi/45 radians, it label is 0
            orderedLabels = zeros(1,length(anglePerimCoordSort));
            for nCoord = 1:length(anglePerimCoordSort)
                [M,ind]=min(abs(angleLabelCoord - anglePerimCoordSort(nCoord)));
                if M < pi/135
                    orderedLabels(nCoord)=maskLabel(x(ind(1)),y(ind(1)));
                else
                    orderedLabels(nCoord)=0;
                end
            end

            imgFinalCoordinates3x{coordZ} = repmat(orderedLabels,1,3);
            imgFinalCoordinates{coordZ} = orderedLabels;

        end
    end

    %% Reconstruct deployed img
    ySize=max(cellfun(@length, imgFinalCoordinates3x));
    deployedImg3x = zeros(size(img3d,3),ySize);
    deployedImg = zeros(size(img3d,3),ySize);
    for coordZ = 1 : size(img3d,3)
        rowOfCoord3x = imgFinalCoordinates3x{coordZ};
        rowOfCoord = imgFinalCoordinates{coordZ};

        nEmptyPixels3x = 0;
        if length(rowOfCoord3x) < ySize
            nEmptyPixels3x = floor((ySize - length(rowOfCoord3x)) / 2);
            nEmptyPixels = floor((ySize - length(rowOfCoord)) / 2);

        end
        deployedImg3x(coordZ, 1 + nEmptyPixels3x : length(rowOfCoord3x) + nEmptyPixels3x) = rowOfCoord3x;
        deployedImg(coordZ, 1 + nEmptyPixels : length(rowOfCoord) + nEmptyPixels) = rowOfCoord;

    end
%     figure;imshow(deployedImg,colours)
%     figure;imshow(deployedImgMask,colours)

    %% Getting correct border cells, valid cells and no valid cells
    [wholeImage,~,~] = getFinalImageAndNoValidCells(deployedImg3x,colours);
    %[~, ~,noValidCells] = getFinalImageAndNoValidCells(deployedImg3x(:, round(ySize/3):round(ySize*2/3)),colours);
    
%     figure;imshow(finalImage,colours)
    %% We only keep the cells in the middle
    relabelFinalImage = bwlabel(wholeImage,4);
    labelsFinal = unique(relabelFinalImage(deployedImg>0));
    midSectionImage = wholeImage;
    midSectionImage(~ismember(relabelFinalImage,labelsFinal))=0;
%     figure;imshow(finalImage(:, round(ySize/3):round(ySize*2/3)),colours)

    %[~,~,noValidCellsMask] = getFinalImageAndNoValidCells(midSectionImage(:, round(ySize/3):round(ySize*2/3)),colours);

%     figure;imshow(ismember(finalImage, validCellsMask).*finalImage,colours)
    
    %% We keep the valid cells from that middle image
    validCellsFinal  = setdiff(1:max(midSectionImage(:)), noValidCells);
    finalImageWithValidCells = ismember(midSectionImage, validCellsFinal).*midSectionImage;
%     figure;imshow(finalImageWithValidCells,colours)
    [neighs_real,sides_cells]=calculateNeighbours(midSectionImage);
    
%     figure,imshow(midSectionImage, colours);
%     set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
%     centroids = regionprops(midSectionImage, 'Centroid');
%     centroids = vertcat(centroids.Centroid);
%     for numCentroid = 1:size(centroids, 1)
%         if mean(colours(numCentroid+1, :)) < 0.4
%             text(centroids(numCentroid, 1), centroids(numCentroid, 2), num2str(numCentroid), 'HorizontalAlignment', 'center', 'Color', 'white');
%         else
%             text(centroids(numCentroid, 1), centroids(numCentroid, 2), num2str(numCentroid), 'HorizontalAlignment', 'center');
%         end
%     end
    
    imwrite(midSectionImage+1, colours, strcat(outputDir, '_', 'img_MidSection_', date, '.tif'));
    imwrite(finalImageWithValidCells+1, colours, strcat(outputDir, '_', 'img_MidSection_ValidCells_', date, '.tif'));
    imwrite(wholeImage+1, colours, strcat(outputDir, '_', 'img_WholeImage_', date, '.tif'));
    

    
    save(strcat(outputDir, '_', 'img.mat'), 'finalImageWithValidCells', 'midSectionImage', 'wholeImage', 'validCellsFinal');
end

