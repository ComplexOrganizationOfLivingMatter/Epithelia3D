function [labelledImage, basalLayer] = processCells(directoryOfCells, resizeImg, numDepth)
%PROCESSCELLS Summary of this function goes here
%   Detailed explanation goes here

    cellFiles = dir(fullfile(directoryOfCells, 'state', 'cell_*'));
    
    labelledImage = zeros(1, 1, 1);

%     figure;
    for numCell = 1:size(cellFiles, 1)
        plyFile = fullfile(cellFiles(numCell).folder, cellFiles(numCell).name, 'T_1.ply');
        ptCloud = pcread(plyFile);
        pixelLocations = round(double(ptCloud.Location)*resizeImg);
        [labelledImage] = addCellToImage(pixelLocations, labelledImage, numCell);
        
%         [x,y,z] = ind2sub(size(labelledImage),find(labelledImage>0));
%         pcshow([qx(tf),qy(tf),qz(tf)]);
%         hold on;
    end
    
%     % Fill cells
%     se = strel('sphere',8);
%     for numCell = 1:size(cellFiles, 1)
%         numCell
%         maskImg = labelledImage == numCell;
% %         sum(maskImg(:))
%         objectDilated = imdilate(maskImg>0, se);
%         objectDilated = imfill(objectDilated, 'holes');
%         maskImgFilled = imerode(objectDilated, se);
% %         sum(maskImgFilled(:))
%         labelledImage(maskImgFilled>0) = numCell;
%     end
    
    %% Get basal layer by dilating the empty space
    tipValue = 4;
    labelledImage = addTipsImg3D(tipValue+1,labelledImage);
    se = strel('sphere',tipValue);
    objectDilated = imdilate(labelledImage>0, se);
    objectDilated = imfill(objectDilated, 'holes');
    finalObject = imerode(objectDilated, se);
    finalObject = bwareaopen(finalObject, 5);
    [x,y,z] = ind2sub(size(finalObject),find(finalObject>0));
    figure;
    pcshow([x,y,z]);
    
    se = strel('sphere',2);
    finalObjectEroded = imerode(finalObject, se);
    basalLayer = finalObject - finalObjectEroded;
    basalLayer(:, :, end) = finalObject(:, :, end);
    basalLayer(:, :, 1) = finalObject(:, :, 1);
    [x,y,z] = ind2sub(size(basalLayer),find(basalLayer>0));
%     figure;
%     pcshow([x,y,z]);
    labelledImage = double(labelledImage);
    basalLayer = labelledImage .* basalLayer;
end

