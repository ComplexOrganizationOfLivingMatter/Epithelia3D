
addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..', '..', 'InSilicoModels', 'TubularModel', 'src')));

close all

[polygon_distribution, neighbours_data,neighbours_UnrollTube,polygon_distribution_UnrollTube,selpath] = pipeline();

save(fullfile(selpath,'Results/polygon_distribution.mat'), 'polygon_distribution', 'neighbours_data', 'neighbours_UnrollTube','polygon_distribution_UnrollTube')

if sum(cellfun(@sum,(polygon_distribution.Apical(2,:)))) ~=1 || sum(cellfun(@sum,(polygon_distribution.Basal(2,:)))) ~= 1
    apical_neighbours={neighbours_data.Apical};
    basal_neighbours={neighbours_data.Basal};
    incorrectApicalCells= find(~cellfun(@FindIncorrectCells,(apical_neighbours{1,1})));
    incorrectBasalCells= find(~cellfun(@FindIncorrectCells,basal_neighbours{1,1}));
end

