
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
    end
    typeOfAnalysis = ChooseTypeOfAnalysis();
end