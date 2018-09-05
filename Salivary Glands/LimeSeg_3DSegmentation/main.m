
addpath(genpath('src'))
addpath(genpath('lib'))

addpath(genpath(fullfile('..', '..', 'InSilicoModels', 'TubularModel', 'src')));

dataDirs = dir('data/*/');


numDepth = 2;
resizeImg = 0.25;

for numDir = 3:size(dataDirs, 1)
    
    actualFile = dataDirs(numDir);
    
    [labelledImage, basalLayer] = processCells(fullfile(actualFile.folder, actualFile.name, 'Cells', filesep), resizeImg, numDepth);
    [labelledImage, apicalLayer] = processLumen(fullfile(actualFile.folder, actualFile.name, 'Lumen', filesep), labelledImage, resizeImg, numDepth);
    
    paint3D(basalLayer);
    paint3D(apicalLayer);
    paint3D(labelledImage);
    
    [apical3dInfo] = calculateNeighbours3D(apicalLayer);
    [basal3dInfo] = calculateNeighbours3D(basalLayer);
end