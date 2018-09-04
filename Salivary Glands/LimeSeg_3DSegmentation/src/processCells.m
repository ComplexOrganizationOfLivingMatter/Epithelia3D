function [] = processCells(directoryOfCells)
%PROCESSCELLS Summary of this function goes here
%   Detailed explanation goes here

    cellFiles = dir(fullfile(directoryOfCells, 'state', 'cell_*'));
    
    figure;
    for numCell = 1:size(cellFiles, 1)
        plyFile = fullfile(cellFiles(numCell).folder, cellFiles(numCell).name, 'T_1.ply');
        ptCloud = pcread(plyFile);
        pcshow(ptCloud)
        hold on;
    end
    disp('done');
end

