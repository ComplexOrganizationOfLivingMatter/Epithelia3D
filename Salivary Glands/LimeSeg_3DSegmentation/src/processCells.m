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
        % We added for the same x,y several zs, because we found that some
        % of the zs were not completed (i.e. some zs of some cells were
        % composed by only a few pixels).
        for numPixel = 1:size(pixelLocations, 1)
            %zPixels = pixelLocations(numPixel, 3)-numDepth:1:pixelLocations(numPixel, 3)+numDepth;
            %zPixels(zPixels < 1) = [];
            labelledImage(pixelLocations(numPixel, 1), pixelLocations(numPixel, 2), pixelLocations(numPixel, 3)) = numCell;
        end
        cellShape = alphaShape(pixelLocations, 20);
        [qx,qy,qz]=ind2sub(size(labelledImage),find(labelledImage == 0));
        tf = inShape(cellShape,qx,qy,qz);
        
        inCellIndices = sub2ind(size(labelledImage), qx(tf), qy(tf), qz(tf));
        labelledImage(inCellIndices) = numCell;
        
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
    se = strel('sphere',4);
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
    figure;
    pcshow([x,y,z]);
    basalLayer = labelledImage .* basalLayer;
end

