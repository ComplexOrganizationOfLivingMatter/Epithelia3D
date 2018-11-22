function [allVertices, verticesInfo] = detectVerticesOfEdges(inputImage, verticesInfoOf3Fold, validCellsFinal, maxDistance)
%DETECTVERTICESOFEDGES Summary of this function goes here
%   Detailed explanation goes here
    
    imgToCalculateCorners = inputImage == 0;
    
    %% We found the closest white pixels to the pixels we found in black
    [whitePixelsY, whitePixelsX] = find(imgToCalculateCorners);
    whitePixelsY = single(whitePixelsY);
    whitePixelsX = single(whitePixelsX);
    se = strel('disk', 3);
    imgToDilate = zeros(size(imgToCalculateCorners));
    
    cellVertices = cell(max(inputImage(:)), 1);
    
    allVertices = single(unique(vertcat(verticesInfoOf3Fold.verticesPerCell{:}), 'rows'));
    
    %% Detect the corners
    corners = detectHarrisFeatures(imgToCalculateCorners, 'FilterSize', 3, 'MinQuality', 0.01);
    corners = corners.selectUniform(9*length(validCellsFinal), size(imgToCalculateCorners));
    
%     figure;imshow(inputImage); hold on;
%     plot(corners.selectUniform(9*length(validCellsFinal), size(inputImage)));
    
    for numVertexCells = 1:corners.Count
        %hold on; plot(corners.Location(numVertexCells, 1), corners.Location(numVertexCells, 2), 'r+');
        if imgToCalculateCorners(round(corners.Location(numVertexCells, 2)), round(corners.Location(numVertexCells, 1))) == 0
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

            cellsConnectedByVertex = unique(inputImage(dilatedImg>0));
            cellsConnectedByVertex(cellsConnectedByVertex == 0) = [];

            for newCellVertices = cellsConnectedByVertex'
                cellVertices{newCellVertices} = vertcat(cellVertices{newCellVertices}, corners.Location(numVertexCells, 2:-1:1));
            end
            verticesInfo(numVertexCells).verticesConnectCells = cellsConnectedByVertex;

            imgToDilate(corners.Location(numVertexCells, 2), corners.Location(numVertexCells, 1)) = 0;
            
            allVertices(end+1, :) = corners.Location(numVertexCells, 2:-1:1);
        end
    end
end

