
function [neighs_real,sides_cells] = main(photo_Path,name, initialFrame, maxFrame, currentFrame,  pathArchMat, folderNumber )

% Input/output specs
% ------------------
% photo_Path:   'E:\Tina\Epithelia3D\Zebrafish\50epib_5';
% name: '50epib_5_z';
% initialFrame:	16;
% maxFrame: 98;
% currentFrame: 50;
% pathArchMat:  'E:\Tina\Epithelia3D\Zebrafish\Code\LayersCentroids5.mat';
% folderNumber: 5;

[LayerCentroid, LayerPixel]=separatesAndCorrectsCentroidsByLayers(photo_Path,name, initialFrame, maxFrame, currentFrame,  pathArchMat, folderNumber);
[LayerCentroid, trackingCentroid, finalCentroid] = trackingCells(LayerCentroid, initialFrame, maxFrame, folderNumber);
addpath(genpath('findND'));
[img3DLabelled] =layerVoronoi(finalCentroid, 'all', maxFrame);
close all
[basicInfoByLayer, infoSharedLayers, boxPercentage]=LayerNeighbours(img3DLabelled, finalCentroid);


end
