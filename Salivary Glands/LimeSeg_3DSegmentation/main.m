
addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..', '..', 'InSilicoModels', 'TubularModel', 'src')));

close all

[polygon_distribution_Apical, polygon_distribution_Basal, NeighboursData,NeighboursUnrollTube,polygon_distribution_UnrollTube,selpath] = pipeline();

if sum([polygon_distribution_Apical{2,:}]) || sum([polygon_distribution_Basal{2,:}])
    incorrectApicalCells= find(~cellfun(@FindIncorrectCells,(NeighboursData{1,1})));
    incorrectBasalCells= find(~cellfun(@FindIncorrectCells,(NeighboursData{1,2})));
end

polygon_distribution_UnrollTube=cell2table(polygon_distribution_UnrollTube,'VariableNames',{'Apical' 'Basal'});
NeighboursData=cell2table(NeighboursData,'VariableNames',{'Apical' 'Basal'});
NeighboursUnrollTube=cell2table(NeighboursUnrollTube,'VariableNames',{'Apical' 'Basal'});
save(fullfile(selpath,'Results/polygon_distribution.mat'), 'polygon_distribution_Apical', 'polygon_distribution_Basal', 'NeighboursData', 'NeighboursUnrollTube','polygon_distribution_UnrollTube')
