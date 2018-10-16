
addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..', '..', 'InSilicoModels', 'TubularModel', 'src')));

close all

typeOfAnalysis = ChooseTypeOfAnalysis();
while ~isequal(typeOfAnalysis, '')
    if isequal(typeOfAnalysis, 'New')
        [polygon_distribution_Apical, polygon_distribution_Basal, NeighboursData,selpath] = pipeline();
    elseif isequal(typeOfAnalysis, 'Continue')
        [polygon_distribution_Apical, polygon_distribution_Basal, NeighboursData,selpath] = pipeline();
    end
    
    save(fullfile(selpath,'polygon_distribution.mat'), 'polygon_distribution_Apical', 'polygon_distribution_Basal', 'NeighboursData')
    
    if sum([polygon_distribution_Apical{2,:}]) || sum([polygon_distribution_Basal{2,:}])
        incorrectApicalCells= find(~cellfun(@FindIncorrectCells,(NeighboursData{1,1})));
        incorrectBasalCells= find(~cellfun(@FindIncorrectCells,(NeighboursData{1,2})));
    end
     
    typeOfAnalysis = ChooseTypeOfAnalysis();
end