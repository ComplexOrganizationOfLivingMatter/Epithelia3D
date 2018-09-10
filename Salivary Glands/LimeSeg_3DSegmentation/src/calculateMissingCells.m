function [answer, apical3dInfo, notFoundCellsApical, basal3dInfo, notFoundCellsBasal] = calculateMissingCells(labelledImage, lumenImage, apicalLayer, basalLayer, colours, noValidCells)
%CALCULATEMISSINGCELLS Summary of this function goes here
%   Detailed explanation goes here

    [apical3dInfo] = calculateNeighbours3D(apicalLayer);
    notFoundCellsApical = find(cellfun(@(x) isempty(x), apical3dInfo.neighbourhood))';

    %Display missing cells in basal
    [basal3dInfo] = calculateNeighbours3D(basalLayer);
    notFoundCellsBasal = find(cellfun(@(x) isempty(x), basal3dInfo.neighbourhood))';


    %% Plot with missing cells
    figure;
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    %Basal plot
    subplot(2, 2, 1);
    paint3D(basalLayer, [], colours);
    title('Basal layer');

    %Apical plot
    subplot(2, 2, 2);
    paint3D(apicalLayer, [], colours);
    title('Apical layer');

    %Basal missing cells
    missingCellsStr = [];
    notFoundCellsBasal = setdiff(notFoundCellsBasal, noValidCells);
    subplot(2, 2, 3);
    if isempty(notFoundCellsBasal) == 0
        paint3D(labelledImage, notFoundCellsBasal, colours);
        missingCellsStr = strjoin(arrayfun(@num2str, notFoundCellsBasal, 'UniformOutput', false), ', ');
    else
        paint3D(labelledImage, -1, colours);
    end
    
    paint3D(lumenImage, 1);
    title(strcat('Missing basal cells: ', missingCellsStr));

    %Apical missing cells
    subplot(2, 2, 4);
    notFoundCellsApical = setdiff(notFoundCellsApical, noValidCells);
    if isempty(notFoundCellsApical) == 0
        paint3D(labelledImage, notFoundCellsApical, colours);
        missingCellsStr = strjoin(arrayfun(@num2str, notFoundCellsApical, 'UniformOutput', false), ', ');    
    else
        paint3D(labelledImage, -1, colours);
    end
    paint3D(lumenImage, 1);
    
    title(strcat('Missing apical cells: ', missingCellsStr));

    [answer] = isEverythingCorrect();
end

