
function [neighs_layer, transitionLayerFrame, trans_Layer_Final, motiveFrame, basicInfoByLayer, infoSharedLayers] = main(photo_Path,name, initialFrame, maxFrame, currentFrame,  pathArchMat, folderNumber )

% Input/output specs
% ------------------
% photo_Path:   'E:\Tina\Epithelia3D\Zebrafish\50epib_5';
% name: '50epib_5_z';
% initialFrame:	16;
% maxFrame: 98;
% currentFrame: 50;
% pathArchMat:  'E:\Tina\Epithelia3D\Zebrafish\Code\LayersCentroids5.mat';
% folderNumber: 5;

%All the possible names of the files that may have ended in a block are loaded.
nameB1=['LayersCentroids' sprintf('%d',folderNumber) '.mat'];
nameB2=['trackingCentroid' sprintf('%d',folderNumber) '.mat'];
nameB3_1= ['results\LayerAnalysis\Layer_all', sprintf('%d',folderNumber), '\layerAnalysisVoronoi_', sprintf('%d',folderNumber), '.mat'];
nameB3_2=['results\LayerAnalysis\Layer_all', sprintf('%d',folderNumber), '\imgVoronoi2D_', sprintf('%d',folderNumber), '.mat'];
nameB4_1=['neighbours_layer_filter' sprintf('%d',folderNumber) '.mat'];
nameB4_2=['results\basicInfoByLayer' sprintf('%d',folderNumber) '.mat'];
nameB4_3=['results\SharedInfoByLayer' sprintf('%d',folderNumber) '.mat'];
nameB5=['transition_layers_frame' sprintf('%d',folderNumber) '.mat'];

%Depending on where the program was left running, it continues in one block or another.
if exist(nameB5) == 0
    load (nameB1, nameB2, nameB3_1, nameB3_2, nameB4_1, nameB4_2, nameB4_3);
    [neighs_layer, transitionLayerFrame, trans_Layer_Final, motiveFrame] = transitions_Layers(neigh_real, basicInfo, Img, folderNumber);

elseif exist(nameB4_3) == 0
    load (nameB1, nameB2, nameB3_1, nameB3_2);
    [neigh_real, basicInfo, basicInfoByLayer, infoSharedLayers, boxPercentage] = LayerNeighbours(img3DLabelled, finalCentroid, folderNumber);
    [neighs_layer, transitionLayerFrame, trans_Layer_Final, motiveFrame] = transitions_Layers(neigh_real, basicInfo, Img, folderNumber);

elseif exist(nameB3_2) == 0
    load (nameB1, nameB2);
    [img3DLabelled, Img]=layerVoronoi(finalCentroid, 'all', maxFrame, folderNumber);
    close all
    [neigh_real, basicInfo, basicInfoByLayer, infoSharedLayers, boxPercentage] = LayerNeighbours(img3DLabelled, finalCentroid, folderNumber);
    [neighs_layer, transitionLayerFrame, trans_Layer_Final, motiveFrame] = transitions_Layers(neigh_real, basicInfo, Img, folderNumber);

elseif exist (nameB2) == 0
    load (nameB1);
    [trackingCentroid, finalCentroid] = trackingCells(initialFrame, maxFrame, folderNumber);
    addpath(genpath('findND'));
    [img3DLabelled, Img]=layerVoronoi(finalCentroid, 'all', maxFrame, folderNumber);
    close all
    [neigh_real, basicInfo, basicInfoByLayer, infoSharedLayers, boxPercentage] = LayerNeighbours(img3DLabelled, finalCentroid, folderNumber);
    [neighs_layer, transitionLayerFrame, trans_Layer_Final, motiveFrame] = transitions_Layers(neigh_real, basicInfo, Img, folderNumber);
elseif exist (nameB1) == 0

    [LayerCentroid, LayerPixel]=separatesAndCorrectsCentroidsByLayers(photo_Path,name, initialFrame, maxFrame, currentFrame,  pathArchMat, folderNumber);
    [trackingCentroid, finalCentroid] = trackingCells(initialFrame, maxFrame, folderNumber);
    addpath(genpath('findND'));
    [img3DLabelled, Img]=layerVoronoi(finalCentroid, 'all', maxFrame, folderNumber);
    close all
    [neigh_real, basicInfo, basicInfoByLayer, infoSharedLayers, boxPercentage] = LayerNeighbours(img3DLabelled, finalCentroid, folderNumber);
    [neighs_layer, transitionLayerFrame, trans_Layer_Final, motiveFrame] = transitions_Layers(neigh_real, basicInfo, Img, folderNumber);
    
end

