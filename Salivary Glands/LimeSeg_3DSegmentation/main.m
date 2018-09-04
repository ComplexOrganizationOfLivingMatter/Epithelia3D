
addpath(genpath('src'))
addpath(genpath('lib'))

addpath(genpath(fullfile('..', '..', 'TubularModel', 'src')));

dataDirs = dir('data/*/');

for numDir = 3:size(dataDirs, 1)
    
    actualFile = dataDirs(numDir);
    
    labelledImage = processCells(fullfile(actualFile.folder, actualFile.name, 'Cells', filesep));
    
    labelledImage = processLumen(fullfile(actualFile.folder, actualFile.name, 'Lumen', filesep), labelledImage);
    
    [image3dInfo] = calculateNeighbours3D(labelledImage);
    
end