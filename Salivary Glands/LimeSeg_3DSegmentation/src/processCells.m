function [labelledImage] = processCells(directoryOfCells, resizeImg, imgSize, tipValue)
%PROCESSCELLS Summary of this function goes here
%   Detailed explanation goes here

    cellFiles = dir(fullfile(directoryOfCells, 'OutputLimeSeg', 'cell_*'));
    
    labelledImage = zeros(imgSize(1), imgSize(2), 1);

%     figure;
    for numCell = 1:size(cellFiles, 1)
        plyFile = fullfile(cellFiles(numCell).folder, cellFiles(numCell).name, 'T_1.ply');
        ptCloud = pcread(plyFile);
        pixelLocations = round(double(ptCloud.Location)*resizeImg);
        try
            [labelledImage] = addCellToImage(pixelLocations, labelledImage, numCell);
        catch ex
            if isequal(ex.message, 'The alpha shape is empty.')
                newException = MException(ex.identifier,strcat('There is a cell with no points. Please, check if that cell should have points or, instead, remove the directory: ', cellFiles(numCell).name));
                throwAsCaller(newException);
            else
                throw(ex)
            end
        end
        
%         [x,y,z] = ind2sub(size(labelledImage),find(labelledImage>0));
%         pcshow(ptCloud);
    end
    
    %Crop image 3D to minimal bounding box
    %props = regionprops3(labelledImage>0, 'BoundingBox');
    %bbox = props.BoundingBox;
    %labelledImage = labelledImage(floor(bbox(2)):size(labelledImage, 1), floor(bbox(1)):size(labelledImage, 2), :);
    
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
    labelledImage = addTipsImg3D(tipValue+1, labelledImage);
    labelledImage = double(labelledImage);

end

