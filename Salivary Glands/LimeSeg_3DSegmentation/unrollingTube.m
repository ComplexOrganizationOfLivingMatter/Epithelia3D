%% Unroll tube
selpath = uigetdir('data');
load(fullfile(selpath, 'Results', '3d_layers_info.mat'));
load(fullfile(selpath, 'Results', 'valid_cells.mat'));
apicalLayerGoodOrientation = imrotate(apicalLayer, glandOrientation);
basalLayerGoodOrientation = imrotate(basalLayer, glandOrientation);
apicalAreaValidCells = 100;
[neighs_apical,side_cells_apical, apicalAreaValidCells] = unrollTube(apicalLayerGoodOrientation, fullfile(selpath,  'Results', 'apical'), noValidCells, colours);
[neighs_basal,side_cells_basal] = unrollTube(basalLayerGoodOrientation, fullfile(selpath, 'Results', 'basal'), noValidCells, colours, apicalAreaValidCells);

missingCellsUnroll = find(side_cells_basal<3 | side_cells_apical<3);
if isempty(missingCellsUnroll) == 0
    msgbox(strcat('CARE!! Missing (or ill formed) cells at unrolltube: ', strjoin(arrayfun(@num2str, missingCellsUnroll, 'UniformOutput', false), ', ')))
end

[polygon_distribution_UnrollTubeApical] = calculate_polygon_distribution(side_cells_apical, validCells);
[polygon_distribution_UnrollTubeBasal] = calculate_polygon_distribution(side_cells_basal, validCells);
neighbours_UnrollTube = table(neighs_apical,neighs_basal);
polygon_distribution_UnrollTube = table(polygon_distribution_UnrollTubeApical,polygon_distribution_UnrollTubeBasal);
neighbours_UnrollTube.Properties.VariableNames = {'Apical','Basal'};
polygon_distribution_UnrollTube.Properties.VariableNames = {'Apical','Basal'};