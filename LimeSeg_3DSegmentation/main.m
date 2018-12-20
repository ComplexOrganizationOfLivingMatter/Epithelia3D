
addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..','InSilicoModels', 'TubularModel', 'src')));

close all

selpath = uigetdir('data');
if isempty(selpath) == 0
    [polygon_distribution, neighbours_data] = pipeline(selpath);

    save(fullfile(selpath,'Results/polygon_distribution.mat'), 'polygon_distribution', 'neighbours_data')

    if sum(cellfun(@sum,(polygon_distribution.Apical(2,:)))) ~=1 || sum(cellfun(@sum,(polygon_distribution.Basal(2,:)))) ~= 1
        apical_neighbours={neighbours_data.Apical};
        basal_neighbours={neighbours_data.Basal};
        incorrectApicalCells= find(~cellfun(@FindIncorrectCells,(apical_neighbours{1,1})));
        incorrectBasalCells= find(~cellfun(@FindIncorrectCells,basal_neighbours{1,1}));
    end
end

load(fullfile(selpath, 'Results', '3d_layers_info.mat'));
load(fullfile(selpath, 'Results', 'valid_cells.mat'));
% allCellsInit = union(validCells, noValidCells);
% allCells = allCellsInit;
% allCells([58, 39, 30]) = [];
% validCells = intersect(validCells, allCells);
% noValidCells = setdiff(allCellsInit, validCells);
[infoPerSurfaceRatio, neighbours] = divideObjectInSurfaceRatios(labelledImage, basalLayer, apicalLayer, validCells, noValidCells, colours, selpath);

save(fullfile(selpath, 'Results', 'glandDividedInSurfaceRatios.mat'), 'infoPerSurfaceRatio', 'neighbours');
