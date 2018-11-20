function [neighs_real,sides_cells, areaOfValidCells] = unrollTube(img3d, outputDir, noValidCells, colours, perimImage3D, apicalArea)
%UNROLLTUBE Summary of this function goes here
%   Detailed explanation goes here
    

    %% Rotate the gland
    imgProperties = regionprops3(img3d>0, {'Orientation', 'PrincipalAxisLength'});
    angleRotation = deg2rad(-cat(2,imgProperties.Orientation));

    [img3DRotated] = rotateGland(img3d, angleRotation(1));
    if exist('perimImage3D', 'var')
        if isempty(perimImage3D)
            clearvars perimImage3D
        else
            [perimImage3DRotated] = rotateGland(perimImage3D, angleRotation(1), size(img3DRotated));
            perimImage3D = permute(perimImage3DRotated, [1 3 2]);
        end
    end
    
    %% Unroll
    pixelSizeThreshold = 1;
    
    img3d = permute(img3DRotated, [1 3 2]);
    imgFinalCoordinates=cell(size(img3d,3),1);
    imgFinalCoordinates3x=cell(size(img3d,3),1);
    %exportAsImageSequence(img3d, outputDir, colours, -1);
    %exportAsImageSequence(perimImage3D, outputDir, colours, -1);
    borderCells=cell(size(img3d,3),1);

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

            if exist('perimImage3D', 'var')
                imgToPerim = perimImage3D(:, :, coordZ);
            else
                imgToPerim = img3d(:, :, coordZ);
            end
            
            if sum(imgToPerim(:)) == 0
                continue
            end
            
            imgToPerim = imdilate(imgToPerim>0, strel( 'disk', 5));
            imgToPerim = imerode(imgToPerim, strel('disk', 5));
            zPerimMask = bwperim(imgToPerim);
            finalPerim3D(:, :, coordZ) = zPerimMask;
            
            [xPerim, yPerim]=find(finalPerim3D(:, :, coordZ));
            
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
                orderedLabels(nCoord)=maskLabel(x(ind(1)),y(ind(1)));
            end

            imgFinalCoordinates3x{coordZ} = repmat(orderedLabels,1,3);
            imgFinalCoordinates{coordZ} = orderedLabels;
            borderCells{coordZ} = orderedLabels(1);
        end
    end
    
    %exportAsImageSequence(perimImage3D, outputDir, colours, -1);
    
    borderCells = unique([borderCells{:}]);
    borderCells(borderCells == 0) = [];

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
     [wholeImage] = fillEmptySpacesByWatershed2D(deployedImg3x, deployedImg3x==0, colours);
    %[wholeImage,~,~] = getFinalImageAndNoValidCells(deployedImg3x,colours, borderCells);
    %[~, ~,noValidCells] = getFinalImageAndNoValidCells(deployedImg3x(:, round(ySize/3):round(ySize*2/3)),colours);
%     TotalCells = {ValidCells; BordersNoValidCells};
   
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
    
    if length(sides_cells) ~= max(img3d(:))
        sides_cells(end+1:end+(max(img3d(:)) - length(sides_cells))) = 0;
        neighs_real(end+1:end+(max(img3d(:)) - length(sides_cells))) = [];
    end
    
    
    h = figure ('units','normalized','outerposition',[0 0 1 1], 'visible', 'off');
    imshow(midSectionImage+1, colours);
    midSectionNewLabels = bwlabel(midSectionImage, 4);
    centroids = regionprops(midSectionNewLabels, 'Centroid');
    centroids = round(vertcat(centroids.Centroid));
    ax = get(h, 'Children');
    set(ax,'Units','normalized')
    set(ax,'Position',[0 0 1 1])
    for numCentroid = 1:size(centroids, 1)
        labelSeed = midSectionImage(midSectionNewLabels == numCentroid);
        labelSeed = labelSeed(1);
        if mean(colours(labelSeed+1, :)) < 0.4
            text(ax, centroids(numCentroid, 1), centroids(numCentroid, 2), num2str(labelSeed), 'HorizontalAlignment', 'center', 'Color', 'white', 'FontSize', 6);
        else
            text(ax, centroids(numCentroid, 1), centroids(numCentroid, 2), num2str(labelSeed), 'HorizontalAlignment', 'center', 'FontSize', 6);
        end
    end
    h.InvertHardcopy = 'off';
    saveas(h, strcat(outputDir, '_', 'img_MidSection.tif'));
    imwrite(finalImageWithValidCells+1, colours, strcat(outputDir, '_', 'img_MidSection_ValidCells.tif'));
    imwrite(wholeImage+1, colours, strcat(outputDir, '_', 'img_WholeImage.tif'));
    
    %% Calculating surface ratio
    validCellsProp = regionprops(midSectionImage, 'EulerNumber');
    borderCells = find([validCellsProp.EulerNumber] > 1);
    midRange = 1:round(size(finalImageWithValidCells, 2)/2);
    imageNewLabels = bwlabel(finalImageWithValidCells, 4);
    imageNewLabelsMid = imageNewLabels(:, midRange);
    borderCellsDuplicated = unique(imageNewLabelsMid(ismember(finalImageWithValidCells(:, midRange), borderCells)));
    finalImageWithValidCells(ismember(imageNewLabels, borderCellsDuplicated)) = 0;
    %figure; imshow(finalImageWithValidCells+1, colours);
    areaOfValidCells = sum(finalImageWithValidCells(:)>0);
    
    if exist('apicalArea', 'var') == 0
        surfaceRatio = 1;
    else
        surfaceRatio = areaOfValidCells / apicalArea;
    end
    save(strcat(outputDir, '_', 'img.mat'), 'finalImageWithValidCells', 'midSectionImage', 'wholeImage', 'validCellsFinal', 'surfaceRatio');
end

