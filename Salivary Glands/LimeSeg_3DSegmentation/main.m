
addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..', '..', 'InSilicoModels', 'TubularModel', 'src')));

close all

TypeOfAnalysis = ChooseTypeOfAnalysis();
 if isequal(TypeOfAnalysis, 'Preliminary')
            LabelImageSequence
            TypeOfAnalysis = ChooseTypeOfAnalysis();
 elseif isequal(TypeOfAnalysis, 'Complete')
[polygon_distribution_Apical, polygon_distribution_Basal, polygonDistributions,selpath] = pipeline();
save(strcat(selpath,'polygon_distribution_Apical.mat'))
save(strcat(selpath,'polygon_distribution_Basal.mat'))
 else 
    
 end