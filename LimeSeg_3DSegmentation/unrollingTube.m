%% Unroll tube

addpath(genpath('src'))
addpath(genpath('lib'))
addpath(genpath('gui'))
addpath(genpath(fullfile('..', 'InSilicoModels', 'TubularModel', 'src')));

files = dir('**/Salivary gland/**/Results/3d_layers_info.mat');

parpool(3)
parfor numFile = 2:length(files)
    files(numFile).folder
    selpath = files(numFile).folder;
    [neighbours_UnrollTube, polygon_distribution_UnrollTube, polygon_distribution_UnrollTubeApical, polygon_distribution_UnrollTubeBasal] = unrollTube_parallel(selpath);
    infoUnroll{numFile} = {neighbours_UnrollTube, polygon_distribution_UnrollTube, polygon_distribution_UnrollTubeApical, polygon_distribution_UnrollTubeBasal};
    directorySplitted = strsplit(selpath, '\');
    %createSamiraFormatExcel_NaturalTissues(fullfile(selpath, 'apical_img.mat'), strjoin(directorySplitted(end-3:end-1), '_'));
    %createSamiraFormatExcel_NaturalTissues(fullfile(selpath, 'basal_img.mat'), strjoin(directorySplitted(end-3:end-1), '_'));
end