
addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..', '..', 'InSilicoModels', 'TubularModel', 'src')));

close all

[polygon_distribution_Apical, polygon_distribution_Basal, NeighboursData,selpath] = pipeline();
save(fullfile(selpath,'polygon_distribution.mat'), 'polygon_distribution_Apical', 'polygon_distribution_Basal', 'NeighboursData')
    
if sum([polygon_distribution_Apical{2,:}]) || sum([polygon_distribution_Basal{2,:}])
    incorrectApicalCells= find(~cellfun(@FindIncorrectCells,(NeighboursData{1,1})));
    incorrectBasalCells= find(~cellfun(@FindIncorrectCells,(NeighboursData{1,2})));
end