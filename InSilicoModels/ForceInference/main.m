
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
    
    imgFile = tifFiles(cellfun(@(x) isequal(x(1:end-4), folderName), {tifFiles.name}));
    
    if contains(lower(actualFile.folder), 'frusta')
        imgFileNewFolder = strrep(imgFile.folder, 'frusta', 'initialframes');
        imgFileSplitted = strsplit(imgFile.name, '_');
        imgFileSplittedNumber = strsplit(imgFileSplitted{1}, 'frusta');
        imgFileNumber = imgFileSplittedNumber{2};
        imgFileNewName = strcat('voronoi', imgFileSplittedNumber{2}, '_1.tif');
        
        if endsWith(lower(actualFile.folder), '5')
            forceInferenceInfo = readDatFile(strcat(actualFile.folder, '\', actualFile.name), imread(strcat(imgFileNewFolder, '\', imgFileNewName)), [1 5]);
            frustaForceInference{1} = vertcat(frustaForceInference{1}, forceInferenceInfo);
        else
            forceInferenceInfo = readDatFile(strcat(actualFile.folder, '\', actualFile.name), imread(strcat(imgFileNewFolder, '\', imgFileNewName)), [1 1/0.6]);
            frustaForceInference{2} = vertcat(frustaForceInference{2}, forceInferenceInfo);
        end
    elseif contains(lower(actualFile.folder), 'initialframes')
        
        forceInferenceInfo = readDatFile(strcat(actualFile.folder, '\', actualFile.name), imread(strcat(imgFile.folder, '\', imgFile.name)), []);
        initialFramesForceInference = vertcat(initialFramesForceInference, forceInferenceInfo);
        
    elseif contains(lower(actualFile.folder), 'voronoi')
        
        forceInferenceInfo = readDatFile(strcat(actualFile.folder, '\', actualFile.name), imread(strcat(imgFile.folder, '\', imgFile.name)), []);
        if endsWith(lower(actualFile.folder), '5')
            voronoiForceInference{1} = vertcat(voronoiForceInference{1}, forceInferenceInfo);
        else
            voronoiForceInference{2} = vertcat(voronoiForceInference{2}, forceInferenceInfo);
        end
        
    end
end