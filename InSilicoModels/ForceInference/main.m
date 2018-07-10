
addpath(genpath('src'))
addpath(genpath('lib'))
addpath('..\TubularModel\src\lib');

datFiles = dir('Sugimura_Results\ThirdRound\**\*.dat');
tifFiles = dir('data\2048x4096_200seeds\**\*.tif');

frustaForceInference = cell(1, 4);
voronoiForceInference = cell(1, 4);
initialFramesForceInference = cell(1, 2);

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
            [forceInferenceInfo, edgeInfo] = readDatFile(strcat(actualFile.folder, '\', actualFile.name), imread(strcat(imgFileNewFolder, '\', imgFileNewName)), [1 5]);
            frustaForceInference{1} = vertcat(frustaForceInference{1}, forceInferenceInfo);
            frustaForceInference{3} = vertcat(frustaForceInference{3}, edgeInfo);
        else
            [forceInferenceInfo, edgeInfo] = readDatFile(strcat(actualFile.folder, '\', actualFile.name), imread(strcat(imgFileNewFolder, '\', imgFileNewName)), [1 1/0.6]);
            frustaForceInference{2} = vertcat(frustaForceInference{2}, forceInferenceInfo);
            frustaForceInference{4} = vertcat(frustaForceInference{4}, edgeInfo);
        end
    elseif contains(lower(actualFile.folder), 'initialframes')
        
        [forceInferenceInfo, edgeInfo] = readDatFile(strcat(actualFile.folder, '\', actualFile.name), imread(strcat(imgFile.folder, '\', imgFile.name)), []);
        initialFramesForceInference{1} = vertcat(initialFramesForceInference{1}, forceInferenceInfo);
        initialFramesForceInference{2} = vertcat(initialFramesForceInference{2}, edgeInfo);
    elseif contains(lower(actualFile.folder), 'voronoi')
        
        [forceInferenceInfo, edgeInfo] = readDatFile(strcat(actualFile.folder, '\', actualFile.name), imread(strcat(imgFile.folder, '\', imgFile.name)), []);
        if endsWith(lower(actualFile.folder), '5')
            voronoiForceInference{1} = vertcat(voronoiForceInference{1}, forceInferenceInfo);
            voronoiForceInference{3} = vertcat(voronoiForceInference{3}, edgeInfo);
        else
            voronoiForceInference{2} = vertcat(voronoiForceInference{2}, forceInferenceInfo);
            voronoiForceInference{4} = vertcat(voronoiForceInference{4}, edgeInfo);
        end
        
    end
end

%Removing invalid cells
[frustaForceInference{1}] = removeInvalidCells(frustaForceInference{1});
[frustaForceInference{2}] = removeInvalidCells(frustaForceInference{2});

[voronoiForceInference{1}] = removeInvalidCells(voronoiForceInference{1});
[voronoiForceInference{2}] = removeInvalidCells(voronoiForceInference{2});

initialFramesForceInference = removeInvalidCells(initialFramesForceInference);
