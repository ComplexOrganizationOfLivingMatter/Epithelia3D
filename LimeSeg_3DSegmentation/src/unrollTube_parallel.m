function [neighbours_UnrollTube, polygon_distribution_UnrollTube, polygon_distribution_UnrollTubeApical, polygon_distribution_UnrollTubeBasal] = unrollTube_parallel(selpath)
%UNROLLTUBE_PARALLEL Summary of this function goes here
%   Detailed explanation goes here
    
    load(fullfile(selpath, '3d_layers_info.mat'), 'labelledImage', 'apicalLayer', 'basalLayer', 'colours', 'glandOrientation', 'lumenImage');
    load(fullfile(selpath, 'valid_cells.mat'), 'validCells', 'noValidCells');
    resizeImg = 0.25;
    imgSize = round(size(apicalLayer)/resizeImg);
    [~, originalRotation] = rotateImg3(double(lumenImage), 1);
    %apicalLayerGoodOrientation = rotateImg3(imresize3(apicalLayer, imgSize, 'nearest'), 1, originalRotation);
    apicalLayerGoodOrientation = imresize3(apicalLayer, imgSize, 'nearest');
    clearvars apicalLayer
    %basalLayerGoodOrientation = rotateImg3(imresize3(basalLayer, imgSize, 'nearest'), 1, originalRotation);
    basalLayerGoodOrientation = imresize3(basalLayer, imgSize, 'nearest');
    clearvars basalLayer
    %lumenImageGoodOrientation = rotateImg3(imresize3(double(lumenImage), imgSize, 'nearest'), 1, originalRotation);
    lumenImageGoodOrientation = imresize3(double(lumenImage), imgSize, 'nearest');
    clearvars lumenImage
    
    apicalAreaValidCells = 100;
    disp('Apical');
    unrollTube(apicalLayerGoodOrientation, fullfile(selpath, 'apical'), noValidCells, colours, lumenImageGoodOrientation, originalRotation(1));
    
    disp('Basal');
    unrollTube(basalLayerGoodOrientation, fullfile(selpath, 'basal'), noValidCells, colours, [], originalRotation(1), apicalAreaValidCells);
end

