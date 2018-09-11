
addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..', '..', 'InSilicoModels', 'TubularModel', 'src')));

[polygon_distribution_Apical, polygon_distribution_Basal, polygonDistributions] = pipeline();
close all