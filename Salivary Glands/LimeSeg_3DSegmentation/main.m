
addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..', '..', 'InSilicoModels', 'TubularModel', 'src')));

close all

[polygon_distribution, neighbours_data,neighbours_UnrollTube,polygon_distribution_UnrollTube,selpath] = pipeline();

if round(sum(cellfun(@sum,(polygon_distribution.Apical{1,1}(2,:))))) ~=1 || round(sum(cellfun(@sum,(polygon_distribution.Basal{1,1}(2,:))))) ~= 1
    incorrectApicalCells= find(~cellfun(@FindIncorrectCells,(neighbours_data.Apical{1,1})));
    incorrectBasalCells= find(~cellfun(@FindIncorrectCells,(neighbours_data.Basal{1,1})));
end

save(fullfile(selpath,'Results/polygon_distribution.mat'), 'polygon_distribution', 'neighbours_data', 'neighbours_UnrollTube','polygon_distribution_UnrollTube')
