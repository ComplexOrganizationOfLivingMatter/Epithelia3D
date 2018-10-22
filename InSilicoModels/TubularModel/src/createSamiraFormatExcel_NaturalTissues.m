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
    extendedImage = wholeImage;
    [neighbours, ~] = calculateNeighbours(extendedImage);
    [ verticesInfoOf3Fold ] = calculateVertices(extendedImage, neighbours);

    %We found the closest white pixels to the pixels we found in black
    [whitePixelsY, whitePixelsX] = find(midSectionImgToCalculateCorners);
    whitePixelsY = single(whitePixelsY);
    whitePixelsX = single(whitePixelsX);
    se = strel('disk', 3);
    imgToDilate = zeros(size(midSectionImgToCalculateCorners));
    
    cellVertices = cell(max(wholeImage(:)), 1);
    
    allVertices = single(vertcat(verticesInfoOf3Fold.verticesPerCell{:}));
    
    for numVertexCells = 1:corners.Count
        %hold on; plot(corners.Location(numVertexCells, 1), corners.Location(numVertexCells, 2), 'r+');
        if midSectionImgToCalculateCorners(round(corners.Location(numVertexCells, 2)), round(corners.Location(numVertexCells, 1))) == 0
            [~, minDistanceIndex] = pdist2([whitePixelsY, whitePixelsX], round([corners.Location(numVertexCells, 2), corners.Location(numVertexCells, 1)]),'euclidean', 'Smallest', 1);
            corners.Location(numVertexCells, :) = [whitePixelsX(minDistanceIndex), whitePixelsY(minDistanceIndex)];
        else
            corners.Location(numVertexCells, :) = round(corners.Location(numVertexCells, :));
        end
        
        [minDistance, minDistIndex] = pdist2(allVertices, corners.Location(numVertexCells, :), 'euclidean', 'Smallest', 1);
        
        if minDistance >= maxDistance
            imgToDilate(corners.Location(numVertexCells, 2), corners.Location(numVertexCells, 1)) = 1;

            dilatedImg = imdilate(imgToDilate, se);

            verticesInfo(numVertexCells).verticesPerCell = corners.Location(numVertexCells, :);

            cellsConnectedByVertex = unique(wholeImage(dilatedImg>0));
            cellsConnectedByVertex(cellsConnectedByVertex == 0) = [];

            for newCellVertices = cellsConnectedByVertex'
                cellVertices{newCellVertices} = vertcat(cellVertices{newCellVertices}, corners.Location(numVertexCells, :));
            end
            verticesInfo(numVertexCells).verticesConnectCells = cellsConnectedByVertex;

            imgToDilate(corners.Location(numVertexCells, 2), corners.Location(numVertexCells, 1)) = 0;
        end
    end

%     figure;imshow(midSectionImgToCalculateCorners); hold on;
%     plot(corners);

    for numCell = 1:max(extendedImage(:))
        newVertices = verticesInfoOf3Fold.verticesPerCell(any(ismember(verticesInfoOf3Fold.verticesConnectCells, numCell), 2), :);
        actualVertices = vertcat(cellVertices{newCellVertices}, newVertices{:});
        cellVertices{newCellVertices} = actualVertices;
    end
    
    
    %midCells = unique(extendedImage(finalImageWithValidCells>0));
    eulerNumberOfCells = regionprops(finalImageWithValidCells, 'all');
    borderCells = find([eulerNumberOfCells.EulerNumber] > 1);
    %borderCellsOfNewLabels = unique(extendedImage(ismember(finalImageWithValidCells, borderCells)));
    borderCellsOfNewLabels = borderCells;
    
    %noBorderCells = setdiff(midCells, borderCellsOfNewLabels);
    noBorderCells = validCellsFinal;
%     
%     verticesInfo.verticesConnectCells = verticesInfoOf3Fold.verticesConnectCells(noBorderCells);
%     verticesInfo.verticesPerCell = verticesInfoOf3Fold.verticesPerCell(noBorderCells);
%     
%     verticesNoValidCellsInfo.verticesConnectCells = verticesInfoOf3Fold.verticesConnectCells(borderCellsOfNewLabels);
%     verticesNoValidCellsInfo.verticesPerCell = verticesInfoOf3Fold.verticesPerCell(borderCellsOfNewLabels);
    
    [samiraTableVoronoi, cellsVoronoi] = tableWithSamiraFormat(cellVertices, [], -1, strsplit(pathFile, '\'), nameOfSimulation);
    
    samiraTableT = cell2table(samiraTableVoronoi, 'VariableNames',{'Radius', 'CellIDs', 'TipCells', 'BorderCell','verticesValues_x_y'});

    writetable(samiraTableT, strcat(dir2save, '\samirasFormat_', date, '.xls'));

end

