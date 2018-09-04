
addpath(genpath('src'))
addpath(genpath('lib'))

dataDirs = dir('data/*/');

for numDir = 3:size(dataDirs, 1)
    
    actualFile = dataDirs(numDir);
    
    processCells(fullfile(actualFile.folder, actualFile.name, 'Cells', filesep))
    
end