function [] = processCells(directoryOfCells)
%PROCESSCELLS Summary of this function goes here
%   Detailed explanation goes here

    cellFiles = dir(fullfile(directoryOfCells, 'state', 'cell_*'));
    
    cellsPoints = {};
    
    labelledImage = zeros(1, 1, 1);
    
%     figure;
    figure
    for numCell = 1:size(cellFiles, 1)
        plyFile = fullfile(cellFiles(numCell).folder, cellFiles(numCell).name, 'T_1.ply');
        ptCloud = pcread(plyFile);
        cellsPoints{numCell} = ptCloud;
        pixelLocations = round(double(ptCloud.Location));
        tic
        for numPixel = 1:size(pixelLocations, 1)
            labelledImage(pixelLocations(numPixel, 1), pixelLocations(numPixel, 2), pixelLocations(numPixel, 3)) = numCell;
        end
        toc
        
        [x,y,z] = ind2sub(size(labelledImage),find(labelledImage>0));
        pcshow([x,y,z]);
        hold on;
        
%         pcshow(ptCloud)
%         hold on;
    end
    disp('done');
end

