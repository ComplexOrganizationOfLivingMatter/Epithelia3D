
addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..', '..', 'InSilicoModels', 'TubularModel', 'src')));

close all

typeOfAnalysis = ChooseTypeOfAnalysis();
while ~isequal(typeOfAnalysis, '')
    if isequal(typeOfAnalysis, 'Preliminary')
        LabelImageSequence();
    elseif isequal(typeOfAnalysis, 'Complete')
        [noValidCells,validCells,polygon_distribution_Apical, polygon_distribution_Basal, polygonDistributions,selpath] = pipeline();
        save(fullfile(selpath,'polygon_distribution.mat'), 'polygon_distribution_Apical', 'polygon_distribution_Basal', 'polygonDistributions')
        save(fullfile(selpath,'valid_cells.mat'), 'noValidCells', 'validCells')
       
        if sum([polygon_distribution_Apical{2,:}])|| sum([polygon_distribution_Basal{2,:}])
            IncorrectApicalCells= find(~cellfun(@FindIncorrectCells,(polygonDistributions{1,1})));
            IncorrectBasalCells= find(~cellfun(@FindIncorrectCells,(polygonDistributions{1,2})));
            IndexIncorrectApicalCells= validCells(IncorrectApicalCells);
            IndexIncorrectBasalCells= validCells(IncorrectBasalCells);
        end
        
    end
    typeOfAnalysis = ChooseTypeOfAnalysis();
end