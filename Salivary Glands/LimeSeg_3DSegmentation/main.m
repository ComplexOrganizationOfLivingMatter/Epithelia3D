
addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..', '..', 'InSilicoModels', 'TubularModel', 'src')));

close all

[polygon_distribution_Apical, polygon_distribution_Basal, NeighboursData,neighboursUnrollTube,polygon_distribution_UnrollTube,selpath] = pipeline();

if sum([polygon_distribution_Apical{2,:}]) || sum([polygon_distribution_Basal{2,:}])
    incorrectApicalCells= find(~cellfun(@FindIncorrectCells,(NeighboursData{1,1})));
    incorrectBasalCells= find(~cellfun(@FindIncorrectCells,(NeighboursData{1,2})));
end

rowHeadings = {'Apical', 'Basal'};
polygon_distribution_UnrollTube=cell2struct(polygon_distribution_UnrollTube,rowHeadings,2);
NeighboursData=cell2struct(NeighboursData,rowHeadings,2);
neighboursUnrollTube=cell2struct(neighboursUnrollTube,rowHeadings,2);
save(fullfile(selpath,'Results/polygon_distribution.mat'), 'polygon_distribution_Apical', 'polygon_distribution_Basal', 'NeighboursData')
