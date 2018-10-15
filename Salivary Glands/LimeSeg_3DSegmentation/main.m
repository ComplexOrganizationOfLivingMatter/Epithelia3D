
addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..', '..', 'InSilicoModels', 'TubularModel', 'src')));

close all

typeOfAnalysis = ChooseTypeOfAnalysis();
while ~isequal(typeOfAnalysis, '')
    if isequal(typeOfAnalysis, 'New')
        [noValidCells,validCells,polygon_distribution_Apical, polygon_distribution_Basal, NeighboursData,selpath] = pipeline();
    elseif isequal(typeOfAnalysis, 'Continue')
        [noValidCells,validCells,polygon_distribution_Apical, polygon_distribution_Basal, NeighboursData,selpath] = pipeline();
    end
    
    save(fullfile(selpath,'polygon_distribution.mat'), 'polygon_distribution_Apical', 'polygon_distribution_Basal', 'NeighboursData')
    save(fullfile(selpath,'valid_cells.mat'), 'noValidCells', 'validCells')
    
    if sum([polygon_distribution_Apical{2,:}])|| sum([polygon_distribution_Basal{2,:}])
        IncorrectApicalCells= find(~cellfun(@FindIncorrectCells,(NeighboursData{1,1})));
        IncorrectBasalCells= find(~cellfun(@FindIncorrectCells,(NeighboursData{1,2})));
    end
    
    
    
    
    typeOfAnalysis = ChooseTypeOfAnalysis();
end