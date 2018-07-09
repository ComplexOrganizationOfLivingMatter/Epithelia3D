
addpath(genpath('src'))
addpath('..\TubularModel\src\lib');

datFiles = dir('Sugimura_Results\ThirdRound\**\*.dat');
tifFiles = dir('data\2048x4096_200seeds\**\*.tif');

frustaForceInference = cell(1, 2);
voronoiForceInference = cell(1, 2);
initialFramesForceInference = [];

for numFile = 1:length(datFiles)
    actualFile = datFiles(numFile);
    actualFile.folder
    actualFolders = strsplit(actualFile.folder, '\');
    folderName = actualFolders{end};
    
    imgFile = tifFiles(cellfun(@(x) contains(x, folderName), {tifFiles.name}));
    
    forceInferenceInfo = readDatFile(strcat(actualFile.folder, '\', actualFile.name), imread(strcat(imgFile.folder, '\', imgFile.name)));
    
    if contains(lower(actualFile.folder), 'frusta')
        if endsWith(lower(actualFile.folder), '5')
            frustaForceInference{1} = vertcat(frustaForceInference{1}, forceInferenceInfo);
        else
            frustaForceInference{2} = vertcat(frustaForceInference{2}, forceInferenceInfo);
        end
    elseif contains(lower(actualFile.folder), 'voronoi')
        if endsWith(lower(actualFile.folder), '5')
            voronoiForceInference{1} = vertcat(voronoiForceInference{1}, forceInferenceInfo);
        else
            voronoiForceInference{2} = vertcat(voronoiForceInference{2}, forceInferenceInfo);
        end
    elseif contains(lower(actualFile.folder), 'initialframes')
        initialFramesForceInference = vertcat(initialFramesForceInference, forceInferenceInfo);
    end
end