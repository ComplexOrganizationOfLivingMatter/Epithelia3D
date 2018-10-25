function [] = createSamiraFormatExcel_NaturalTissues(pathFile, nameOfSimulation)
%CREATESAMIRAFORMATEXCEL_NATURALTISSUES Summary of this function goes here
%   Detailed explanation goes here
    addpath(genpath('lib'))

    maxDistance = 4;
    
    %% Salivary gland
    load(pathFile);
    
    midSectionImgToCalculateCorners = midSectionImage == 0;
    corners = detectHarrisFeatures(midSectionImgToCalculateCorners, 'FilterSize', 3, 'MinQuality', 0.01);
    corners = corners.selectUniform(9*length(validCellsFinal), size(midSectionImgToCalculateCorners));
%     figure;imshow(midSectionImgToCalculateCorners); hold on;
%     plot(corners.selectUniform(9*length(validCellsFinal), size(midSectionImgToCalculateCorners)));

    % Calculate vertices connecting 3 cells and add them to the list
    %extendedImage = wholeImage;
    extendedImage = midSectionImage;
    [neighbours, ~] = calculateNeighbours(extendedImage);
    [ verticesInfoOf3Fold ] = calculateVertices(extendedImage, neighbours);
    
    [verticesInfoOf3Fold] = removingVeryCloseVertices(verticesInfoOf3Fold, maxDistance);

%     [correctPixelsX, correctPixelsY] = find(imdilate(midSectionImage, strel('disk', 3)) > 0);
%     
%     verticesInsideRange = cellfun(@(x) ismember(x, [correctPixelsX, correctPixelsY], 'rows'), verticesInfoOf3Fold.verticesPerCell);
%     verticesInfoOf3Fold.verticesConnectCells(verticesInsideRange == 0, :) = [];
%     verticesInfoOf3Fold.verticesPerCell(verticesInsideRange == 0) = [];
    
    %We found the closest white pixels to the pixels we found in black
    [whitePixelsY, whitePixelsX] = find(midSectionImgToCalculateCorners);
    whitePixelsY = single(whitePixelsY);
    whitePixelsX = single(whitePixelsX);
    se = strel('disk', 3);
    imgToDilate = zeros(size(midSectionImgToCalculateCorners));
    
    cellVertices = cell(max(wholeImage(:)), 1);
    
    allVertices = single(unique(vertcat(verticesInfoOf3Fold.verticesPerCell{:}), 'rows'));
    
    for numVertexCells = 1:corners.Count
        %hold on; plot(corners.Location(numVertexCells, 1), corners.Location(numVertexCells, 2), 'r+');
        if midSectionImgToCalculateCorners(round(corners.Location(numVertexCells, 2)), round(corners.Location(numVertexCells, 1))) == 0
            [~, minDistanceIndex] = pdist2([whitePixelsY, whitePixelsX], round([corners.Location(numVertexCells, 2), corners.Location(numVertexCells, 1)]),'euclidean', 'Smallest', 1);
            corners.Location(numVertexCells, :) = [whitePixelsX(minDistanceIndex), whitePixelsY(minDistanceIndex)];
        else
            corners.Location(numVertexCells, :) = round(corners.Location(numVertexCells, :));
        end
        
        [minDistance, ~] = pdist2(allVertices, corners.Location(numVertexCells, 2:-1:1), 'euclidean', 'Smallest', 1);
        
        if minDistance >= maxDistance
            imgToDilate(corners.Location(numVertexCells, 2), corners.Location(numVertexCells, 1)) = 1;

            dilatedImg = imdilate(imgToDilate, se);

            verticesInfo(numVertexCells).verticesPerCell = corners.Location(numVertexCells, 2:-1:1);

            cellsConnectedByVertex = unique(midSectionImage(dilatedImg>0));
            cellsConnectedByVertex(cellsConnectedByVertex == 0) = [];

            for newCellVertices = cellsConnectedByVertex'
                cellVertices{newCellVertices} = vertcat(cellVertices{newCellVertices}, corners.Location(numVertexCells, 2:-1:1));
            end
            verticesInfo(numVertexCells).verticesConnectCells = cellsConnectedByVertex;

            imgToDilate(corners.Location(numVertexCells, 2), corners.Location(numVertexCells, 1)) = 0;
            
            allVertices(end+1, :) = corners.Location(numVertexCells, 2:-1:1);
        end
    end

%     figure;imshow(midSectionImgToCalculateCorners); hold on;
%     plot(corners);

    %midCells = unique(extendedImage(finalImageWithValidCells>0));
    validCellsProp = regionprops(midSectionImage, 'EulerNumber','Centroid');
    borderCells = find([validCellsProp.EulerNumber] > 1);
    %borderCellsOfNewLabels = unique(extendedImage(ismember(finalImageWithValidCells, borderCells)));
    borderCellsOfNewLabels = borderCells;

    %noBorderCells = setdiff(midCells, borderCellsOfNewLabels);
    validCells = validCellsFinal;
    noValidCells = setdiff(1:max(wholeImage(:)), validCells);

    for numCell = validCellsFinal
        newVertices = verticesInfoOf3Fold.verticesPerCell(any(ismember(verticesInfoOf3Fold.verticesConnectCells, numCell), 2), :);
        actualVertices = vertcat(cellVertices{numCell}, newVertices{:});
        cellVertices{numCell} = unique(actualVertices, 'rows');
        
        
%         figure;
%         for numVertex = 1:size(actualVertices, 1)
%             plot(actualVertices(numVertex, 1), actualVertices(numVertex, 2), 'r+');
%             hold on;
%         end
    end
%     
%     verticesInfo.verticesConnectCells = verticesInfoOf3Fold.verticesConnectCells(noBorderCells);
%     verticesInfo.verticesPerCell = verticesInfoOf3Fold.verticesPerCell(noBorderCells);
%     
%     verticesNoValidCellsInfo.verticesConnectCells = verticesInfoOf3Fold.verticesConnectCells(borderCellsOfNewLabels);
%     verticesNoValidCellsInfo.verticesPerCell = verticesInfoOf3Fold.verticesPerCell(borderCellsOfNewLabels);

    cellVerticesNoValid = cellVertices;
    cellVerticesNoValid(validCells) = {[]};
    
    cellVerticesValid = cellVertices;
    cellVerticesValid(noValidCells) = {[]};

    ySize = size(wholeImage, 2);
    cellInfoWithVertices = groupingVerticesPerCellSurface(wholeImage(:, (ySize/3):(2*ySize/3)), cellVerticesValid, cellVerticesNoValid, [], 1, borderCells);

    cellInfoWithVertices(cellfun(@isempty, cellInfoWithVertices(:, 6)), :) = [];
    cellInfoWithVertices(cellfun(@(x) ismember(x, noValidCells), cellInfoWithVertices(:, 3)), :) = [];
    
%     figure;imshow(finalImageWithValidCells');
    [samiraTable, cellsVoronoi] = tableWithSamiraFormat(cellInfoWithVertices, cat(1,validCellsProp.Centroid), [], surfaceRatio, strsplit(pathFile, '\'), nameOfSimulation);
    
    samiraTableT = cell2table(samiraTable, 'VariableNames',{'Radius', 'CellIDs', 'TipCells', 'BorderCell','verticesValues_x_y'});

%     figure;imshow(finalImageWithValidCells');
    newCrossesTable = lookFor4cellsJunctionsAndExportTheExcel(samiraTableT);
    
    splitPath = strsplit(pathFile,{'\','/'});
   	typeOfSurface = strsplit(splitPath{end},'_');
    typeOfSurface = typeOfSurface{1};
    dir2save = fullfile(splitPath{1:end-1});
    writetable(samiraTableT, strcat(dir2save, '\',typeOfSurface,'_',nameOfSimulation,'_vertSamirasFormat_', date, '.xls'));
    writetable(newCrossesTable, strcat(dir2save, '\',typeOfSurface,'_',nameOfSimulation,'_vertCrossesSamirasFormat_', date, '.xls'));
end

