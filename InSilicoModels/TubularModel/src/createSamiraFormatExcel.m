function [] = createSamiraFormatExcel(pathFile, surfaceRatios)
%CREATESAMIRAFORMATEXCEL Summary of this function goes here
%   Detailed explanation goes here
    addpath(genpath('lib'))

    load(strcat(pathFile, 'Image_1_Diagram_5.mat'), 'listLOriginalProjection');

    samiraTable = {};
    for nSurfR = [1, surfaceRatios]
        
        L_img = listLOriginalProjection.L_originalProjection{round(listLOriginalProjection.surfaceRatio,3)==round(nSurfR,3)};
        
        [neighbours, ~] = calculateNeighbours(L_img);
        [ verticesInfo ] = calculateVertices( L_img, neighbours);
        
        
        
        
        
        
        verticesWithActualRadius = dataVertID([dataVertID{:, 1}] == nSurfR, :);
        actualVerticesIds = [verticesWithActualRadius{:, 2}];
        
        for numCell = 1:size(cellsVerts, 1)
            verticesOfCell = cellsVerts{numCell, 2};
            verticesOfCellWithActualRadius = verticesOfCell(ismember(verticesOfCell, actualVerticesIds));
            
            actualPairTotalVertices = pairTotalVertices(all(ismember(pairTotalVertices, verticesOfCellWithActualRadius), 2), :);
            
            % Should be connected clockwise
            % I.e. from bigger numbers to smaller ones
            % Or the second vertex should in the left hand of the first
            
            newOrderOfVertices = actualPairTotalVertices(1);
            possibleNextVerticesIDs = actualPairTotalVertices(any(ismember(actualPairTotalVertices, newOrderOfVertices), 2), :);
            possibleNextVerticesIDs = unique(possibleNextVerticesIDs);
            possibleNextVerticesIDs(newOrderOfVertices == possibleNextVerticesIDs) = [];
            
            possibleNextVertices = dataVertID(ismember([dataVertID{:, 2}], possibleNextVerticesIDs), 3:4);
            
            [~, nextVertex] = pdist2(cell2mat(possibleNextVertices), [1, 1], 'euclidean', 'Largest', 1);
            
            newOrderOfVertices(end+1) = possibleNextVerticesIDs(nextVertex);
            
            actualPairTotalVertices(all(ismember(actualPairTotalVertices, newOrderOfVertices), 2), :) = [];
            
            while ~isempty(actualPairTotalVertices)
                nextPairId = any(ismember(actualPairTotalVertices, newOrderOfVertices(end)), 2);
                nextPair = actualPairTotalVertices(nextPairId, :);
                nextVertex = nextPair(ismember(nextPair, newOrderOfVertices) == 0);
                nextVertex
                if isempty(nextVertex) == 0
                    newOrderOfVertices(end+1) = unique(nextVertex);
                end
                actualPairTotalVertices(nextPairId, :) = [];
            end
            
            verticesRadius = dataVertID(ismember([dataVertID{:, 2}], newOrderOfVertices), 3:5)';
            samiraTable(end+1, :) = {nSurfR, numCell, [verticesRadius{:}]};
        end
    end
end

