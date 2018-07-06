
addpath(genpath('src'))

datFiles = dir('Sugimura_Results\ThirdRound\**\*.dat');
tifFiles = dir('data\2048x4096_200seeds\**\*.tif');

for numFile = 1:length(datFiles)
    actualFile = datFiles(numFile);
    
    actualFolders = strsplit(actualFile.folder, '\');
    folderName = actualFolders{end};
    
    imgFile = tifFiles(cellfun(@(x) contains(x, folderName), {tifFiles.name}));
    forceInferenceInfo = readDatFile(strcat(actualFile.folder, '\', actualFile.name), imread(strcat(imgFile.folder, '\', imgFile.name)));
    
    
    if contains(lower(actualFile.folder), 'frustra')
        
    elseif contains(lower(actualFile.folder), 'voronoi')
        
    elseif contains(lower(actualFile.folder), 'initialframes')
        
    end
end