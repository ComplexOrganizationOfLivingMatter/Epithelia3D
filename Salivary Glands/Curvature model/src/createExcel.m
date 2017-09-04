function [ ] = createExcel(numSeeds)
%CREATEEXCEL Summary of this function goes here
%   We export:
%   - Number of neighbours in basal and apical
%   - Areas in basal and apical
%   For each cell we'll get a row. And this row is formed by:
%   - Number of sides and area in apical
%   - For each surface ratio another two columns:
%       - Number of sides and area in basal
%
%   Then, that is a sheet in the excell. We have 20 randomizations, so 20
%   sheets there are.

    randomizationPath = strcat('..\data\voronoiModel\expansion\512x1024_', num2str(numSeeds),'seeds\');
    pathSplitted = strsplit(randomizationPath, '\');
    lastDirSplitted = strsplit(pathSplitted{end-1}, '_');
    outputFile = strcat('..\data\voronoiModel\cellInfo_Sides_Areas_', lastDirSplitted{end} , '_', date ,'.xls');

    addpath(genpath('projectionApicalSufarceWithCurvatureUsingVoronoi_5-3D'));

    randomDirs = dir(randomizationPath);
    randomDirs = randomDirs(3:end);
    
    for numRandom = 1:size(randomDirs, 1)
        imgsPath = strcat(randomizationPath, randomDirs(numRandom).name);
        if isdir(imgsPath) && isempty(strfind(imgsPath, 'Image_')) == 0
            infoFile = strcat(imgsPath, '\', randomDirs(numRandom).name, '.mat');
            load(infoFile);
            for numSurfaceRatio = 1:size(listLOriginalProjection, 1);
                img = listLOriginalProjection.L_originalProjection{numSurfaceRatio};
                [~,sides_cells] = calculate_neighbours(img);
                rowInfo(:, (2*numSurfaceRatio)-1) = sides_cells';
                areaSf = regionprops(img, img, {'Area', 'MeanIntensity'});
                rowInfo(:, (2*numSurfaceRatio)) = vertcat(areaSf.Area);
                
                colNames{(2*numSurfaceRatio)-1} = strcat('numberOfNeighbours');
                colNames{(2*numSurfaceRatio)} = strcat('area');
                
                surfaceRatios{(2*numSurfaceRatio)-1} = listLOriginalProjection.surfaceRatio(numSurfaceRatio);
            end
            
            firstColumn = {'Surface ratio', 'NumCell'}';
            for numCell = 1:size(rowInfo, 1)
                firstColumn{end+1} = numCell;
            end
            
            randomNameSplitted = strsplit(randomDirs(numRandom).name, '_');
            numRandomName = strcat('random', randomNameSplitted{2});
            xlswrite(outputFile, firstColumn, numRandomName, 'B3');
            xlswrite(outputFile, surfaceRatios, numRandomName, 'C3');
            xlswrite(outputFile, colNames, numRandomName, 'C4');
            xlswrite(outputFile, rowInfo, numRandomName, 'C5');
        end
    end
end

