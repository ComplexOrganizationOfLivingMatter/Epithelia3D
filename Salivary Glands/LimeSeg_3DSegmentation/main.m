
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
        [polygon_distribution_Apical, polygon_distribution_Basal, polygonDistributions,selpath] = pipeline();
        save(fullfile(selpath,'polygon_distribution_Apical.mat'))
        save(fullfile(selpath,'polygon_distribution_Basal.mat'))
        
        if sum([polygon_distribution_Apical{2,:}])|| sum([polygon_distribution_Basal{2,:}])
            IncorrectApicalCells= cellfun(@FindIncorrectCells,(polygonDistributions{1,1}),'UniformOutput',false);
            IncorrectBasalCells= cellfun(@FindIncorrectCells,(polygonDistributions{1,2}),'UniformOutput',false);
        end
        
    end
    typeOfAnalysis = ChooseTypeOfAnalysis();
end