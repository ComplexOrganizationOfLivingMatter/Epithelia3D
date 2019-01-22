function [areaOfValidCells] = unrollTube(img3d, outputDir, noValidCells, colours, perimImage3D, glandOrientation, apicalArea)
%UNROLLTUBE Summary of this function goes here
%   Detailed explanation goes here
    colours = vertcat([1 1 1], colours);

    %% Rotate the gland
    %angleRotation = deg2rad(-glandOrientation);

    %[img3DRotated] = rotateGland(img3d, angleRotation(1));
    if exist('perimImage3D', 'var')
        if isempty(perimImage3D)
            clearvars perimImage3D
        else
            %[perimImage3DRotated] = rotateGland(perimImage3D, angleRotation(1), size(img3DRotated));
            perimImage3D = permute(perimImage3D, [1 3 2]);
        end
    end
    
    %% Unroll
    pixelSizeThreshold = 2;
    
    img3d = permute(img3d, [1 3 2]);
%     axesLength = regionprops3(img3d>0,'PrincipalAxisLength');
%     [~,maxLeng] = max(cat(1,axesLength.PrincipalAxisLength));
%     [~,orderLengAxis] = sort(cat(1,axesLength.PrincipalAxisLength(maxLeng(1),:)));
%     img3d=permute(img3d,orderLengAxis);


    imgFinalCoordinates=cell(size(img3d,3),1);
    imgFinalCoordinates3x=cell(size(img3d,3),1);
    %exportAsImageSequence(img3d, outputDir, colours, -1);
    %exportAsImageSequence(perimImage3D, outputDir, colours, -1);
    borderCells=cell(size(img3d,3),1);
    previousRowsSize = 0;
    for coordZ = 1 : size(img3d,3)
        %% Create perimeter mask
        if exist('perimImage3D', 'var')
            imgToPerim = perimImage3D(:, :, coordZ);
        else
            imgToPerim = img3d(:, :, coordZ);
        end
        
        imgToPerim = imdilate(imgToPerim>0, strel( 'disk', 5));
        imgToPerim = imerode(imgToPerim, strel('disk', 5));
        zPerimMask = bwperim(imgToPerim);
        finalPerim3D(:, :, coordZ) = zPerimMask;
               
        if sum(zPerimMask(:)) < pixelSizeThreshold || sum(sum(img3d(:, :, coordZ))) < pixelSizeThreshold
            continue
        end
        
        %% Obtaining the center of the cylinder
        [x, y] = find(zPerimMask > 0);
        centroidCoordZ = mean([x, y]); % Centroid of each real Y of the cylinder
        centroidX = centroidCoordZ(1);
        centroidY = centroidCoordZ(2);
        
        [x, y] = find(img3d(:, :, coordZ) > 0);
        
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
            distances = abs(angleLabelCoord - anglePerimCoordSort(nCoord));
            
            minDistance3D = 0.1;
            %[distancesOrdered, orderedIndices] = sort(distances, 'Ascend');
            [ind] = find(distances < minDistance3D);
            [closerDistances] = distances(distances < minDistance3D);
            [closerDistancesOrdered, indicesOrdered] = sort(closerDistances, 'Ascend');
            ind = ind(indicesOrdered);
            indicesClosest = sub2ind(size(maskLabel), x(ind), y(ind));
            closestLabels = maskLabel(indicesClosest);
            
            closestLabelsUnique = unique(closestLabels);
%             if length(closestLabelsUnique) > 1
%                 counting = arrayfun( @(x)sum(closestLabels==x), unique(closestLabels) );% / length(closestLabels);
%                 [~, modeInd] = max(counting);
%                 remainingIndices = setdiff(1:length(closestLabelsUnique), modeInd);
%                 differenceInPercentage = pdist2(counting(modeInd), counting(remainingIndices));
%                 if any(differenceInPercentage < 4)
%                     %pixelLabel = {closestLabelsUnique(modeInd), closestLabelsUnique(remainingIndices(differenceInPercentage < 3))};
%                     pixelLabel = 0;
%                     % SELECT MEAN OF MIN DISTANCES OF THE SIMILAR
%                 else
%                     pixelLabel = closestLabelsUnique(modeInd);
%                 end
            if ~isempty(closestLabels)
                pixelLabel = closestLabels(1);
            else
                pixelLabel = 0;
            end
            orderedLabels(nCoord) = pixelLabel;
        end
        
        %% Equalize border of the gland
        if previousRowsSize ~= 0
            orderedLabels = imresize(orderedLabels, [1 round(previousRowsSize*0.7 + length(orderedLabels)*0.3)], 'nearest');
        end
        previousRowsSize = length(orderedLabels);
        imgFinalCoordinates3x{coordZ} = repmat(orderedLabels,1,3);
        imgFinalCoordinates{coordZ} = orderedLabels;
        borderCells{coordZ} = orderedLabels(1);
    end
    
    %exportAsImageSequence(perimImage3D, outputDir, colours, -1);
    
    borderCells = unique([borderCells{:}]);
    borderCells(borderCells == 0) = [];

    %% Reconstruct deployed img
    
    ySize=max(cellfun(@length, imgFinalCoordinates3x));
    deployedImg3x = zeros(size(img3d,3),ySize);
    deployedImg = zeros(size(img3d,3),ySize);
    
    nEmptyPixelsPrevious = 0;
    nEmptyPixels3xPrevious = 0;
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

        nEmptyPixelsPrevious = nEmptyPixels;
        nEmptyPixels3xPrevious = nEmptyPixels3x;
    end
%     figure;imshow(deployedImg,colours)
%     figure;imshow(deployedImgMask,colours)


    %% Getting correct border cells, valid cells and no valid cells
     cylindre2DImage = fillEmptySpacesByWatershed2D(deployedImg, imclose(deployedImg>0, strel('disk', 20)) == 0 , colours);
     [wholeImage] = fillEmptySpacesByWatershed2D(deployedImg3x, imclose(deployedImg3x>0, strel('disk', 20)) == 0 , colours);
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
        if mean(colours(labelSeed, :)) < 0.4
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
    save(strcat(outputDir, '_', 'img.mat'), 'finalImageWithValidCells', 'midSectionImage', 'wholeImage', 'validCellsFinal', 'surfaceRatio', 'cylindre2DImage', 'deployedImg', 'deployedImg3x');
end

