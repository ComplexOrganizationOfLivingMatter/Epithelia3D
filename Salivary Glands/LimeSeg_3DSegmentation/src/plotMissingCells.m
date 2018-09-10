function [answer, apical3dInfo, notFoundCellsApical, basal3dInfo, notFoundCellsBasal] = plotMissingCells(labelledImage, lumenImage, apicalLayer, basalLayer)
%CHECKIFEVERYTHINGISOK Summary of this function goes here
%   Detailed explanation goes here

    [apical3dInfo] = calculateNeighbours3D(apicalLayer);
    notFoundCellsApical = find(cellfun(@(x) isempty(x), apical3dInfo.neighbourhood))';

    %Display missing cells in basal
    [basal3dInfo] = calculateNeighbours3D(basalLayer);
    notFoundCellsBasal = find(cellfun(@(x) isempty(x), basal3dInfo.neighbourhood))';


    %% Plot with missing cells
    figure;
    %Basal plot
    subplot(2, 2, 1);
    paint3D(basalLayer);
    title('Basal layer');

    %Apical plot
    subplot(2, 2, 2);
    paint3D(apicalLayer);
    title('Apical layer');

    %Basal missing cells
    subplot(2, 2, 3);
    paint3D(labelledImage, notFoundCellsBasal);
    paint3D(lumenImage, 1);
    title('Not found cells in basal layer');

    %Apical missing cells
    subplot(2, 2, 4);
    paint3D(labelledImage, notFoundCellsApical);
    paint3D(lumenImage, 1);
    title('Not found cells in apical layer');

    [answer] = isEverythingCorrect();
end

