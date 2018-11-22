%% Unroll tube

addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..', '..', 'InSilicoModels', 'TubularModel', 'src')));

%selpath = uigetdir('data');
load(fullfile(selpath, 'Results', '3d_layers_info.mat'));
load(fullfile(selpath, 'Results', 'valid_cells.mat'));
resizeImg = 0.25;
imgSize = round(size(apicalLayer)/resizeImg);
imgSize(:, 3) = size(apicalLayer, 3);
apicalLayerGoodOrientation = imrotate(imresize3(apicalLayer, imgSize, 'nearest'), glandOrientation);
basalLayerGoodOrientation = imrotate(imresize3(basalLayer, imgSize, 'nearest'), glandOrientation);
lumenImageGoodOrientation = imrotate(imresize3(double(lumenImage), imgSize, 'nearest'), glandOrientation)>0;
apicalAreaValidCells = 100;
[neighs_apical,side_cells_apical, apicalAreaValidCells] = unrollTube(apicalLayerGoodOrientation, fullfile(selpath,  'Results', 'apical'), noValidCells, colours, lumenImageGoodOrientation);
[neighs_basal,side_cells_basal] = unrollTube(basalLayerGoodOrientation, fullfile(selpath, 'Results', 'basal'), noValidCells, colours, [], apicalAreaValidCells);

missingCellsUnroll = find(side_cells_basal<3 | side_cells_apical<3);
if isempty(missingCellsUnroll) == 0
    msgbox(strcat('CARE!! Missing (or ill formed) cells at unrolltube: ', strjoin(arrayfun(@num2str, missingCellsUnroll, 'UniformOutput', false), ', ')))
end

[polygon_distribution_UnrollTubeApical] = calculate_polygon_distribution(side_cells_apical, validCells);
[polygon_distribution_UnrollTubeBasal] = calculate_polygon_distribution(side_cells_basal, validCells);
neighbours_UnrollTube = table(neighs_apical, neighs_basal);
polygon_distribution_UnrollTube = table(polygon_distribution_UnrollTubeApical,polygon_distribution_UnrollTubeBasal);
neighbours_UnrollTube.Properties.VariableNames = {'Apical','Basal'};
polygon_distribution_UnrollTube.Properties.VariableNames = {'Apical','Basal'};