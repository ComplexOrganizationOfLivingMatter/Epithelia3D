
addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..', '..', 'InSilicoModels', 'TubularModel', 'src')));

close all
[polygon_distribution_Apical, polygon_distribution_Basal, polygonDistributions] = pipeline();

ruta= uigetdir();
save(strcat(ruta,'polygon_distribution_Apical.mat'))
save(strcat(ruta,'polygon_distribution_Basal.mat'))
