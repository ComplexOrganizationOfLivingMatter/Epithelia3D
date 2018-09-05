function [labelledImage, basalLayer] = processCells(directoryOfCells)
%PROCESSCELLS Summary of this function goes here
%   Detailed explanation goes here

    cellFiles = dir(fullfile(directoryOfCells, 'state', 'cell_*'));
    
    labelledImage = zeros(1, 1, 1);
    figure;
    numDepth = 3;
    resizeImg = 0.25;
    for numCell = 1:size(cellFiles, 1)
        plyFile = fullfile(cellFiles(numCell).folder, cellFiles(numCell).name, 'T_1.ply');
        ptCloud = pcread(plyFile);
        pixelLocations = round(double(ptCloud.Location)*resizeImg);
        for numPixel = 1:size(pixelLocations, 1)
            zPixels = pixelLocations(numPixel, 3)-numDepth:1:pixelLocations(numPixel, 3)+numDepth;
            zPixels(zPixels < 1) = [];
            labelledImage(pixelLocations(numPixel, 1), pixelLocations(numPixel, 2), zPixels) = numCell;
        end
        
%         [x,y,z] = ind2sub(size(labelledImage),find(labelledImage>0));
%         pcshow([x,y,z]);
%         hold on;
    end
    
    % Fill cells
    se = strel('sphere',8);
    for numCell = 1:size(cellFiles, 1)
        numCell
        maskImg = labelledImage == numCell;
%         sum(maskImg(:))
        objectDilated = imdilate(maskImg>0, se);
        objectDilated = imfill(objectDilated, 'holes');
        maskImgFilled = imerode(objectDilated, se);
%         sum(maskImgFilled(:))
        labelledImage(maskImgFilled>0) = numCell;
    end
    
    %% Get basal layer by dilating the empty space
    se = strel('sphere',4);
    objectDilated = imdilate(labelledImage>0, se);
    objectDilated = imfill(objectDilated, 'holes');
    finalObject = imerode(objectDilated, se);
    emptySpace = finalObject == 0;
    [x,y,z] = ind2sub(size(finalObject),find(finalObject>0));
    figure;
    pcshow([x,y,z]);
    
    se = strel('sphere',2);
    finalObjectEroded = imerode(finalObject, se);
    basalLayer = finalObject - finalObjectEroded;
        [x,y,z] = ind2sub(size(basalLayer),find(basalLayer>0));
    figure;
    pcshow([x,y,z]);
    basalLayer = labelledImage .* basalLayer;
end

