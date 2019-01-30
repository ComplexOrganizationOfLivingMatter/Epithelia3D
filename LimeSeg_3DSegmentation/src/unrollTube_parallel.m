function [neighbours_UnrollTube, polygon_distribution_UnrollTube, polygon_distribution_UnrollTubeApical, polygon_distribution_UnrollTubeBasal] = unrollTube_parallel(selpath)
%UNROLLTUBE_PARALLEL Summary of this function goes here
%   Detailed explanation goes here
    
    load(fullfile(selpath, '3d_layers_info.mat'), 'labelledImage', 'apicalLayer', 'basalLayer', 'colours', 'glandOrientation', 'lumenImage');
    load(fullfile(selpath, 'valid_cells.mat'), 'validCells', 'noValidCells');

    apicalAreaValidCells = 100;
    disp('Apical');
    unrollTube(apicalLayer, fullfile(selpath, 'apical'), noValidCells, colours);
    
    disp('Basal');
    unrollTube(basalLayer, fullfile(selpath, 'basal'), noValidCells, colours, apicalAreaValidCells);
end

