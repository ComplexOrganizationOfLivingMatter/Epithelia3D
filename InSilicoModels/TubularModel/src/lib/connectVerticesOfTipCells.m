function [pairTotalVerticesModified] = connectVerticesOfTipCells(tipCells, pairTotalVertices, dataVertID, cellsVertices)
%CONNECTVERTICESOFTIPCELLS Summary of this function goes here
%   Detailed explanation goes here

    vertexRealIDs = cell2mat(dataVertID(:, 2));
    newPairVertices = [];
    
    for numCell = tipCells'
        actualCellVertices = cellsVertices{numCell, 2};
        pairOfVerticesOfCell = pairTotalVertices(all(ismember(pairTotalVertices, actualCellVertices), 2), :);
            
        missingVertices = actualCellVertices(arrayfun(@(x) sum(sum(pairOfVerticesOfCell == x)) < 3, actualCellVertices));
        
        for numVertex = actualCellVertices
            verticesConnectedToActualVertex = unique(pairOfVerticesOfCell(any(pairOfVerticesOfCell == numVertex, 2), :));
            verticesConnectedToActualVertex(verticesConnectedToActualVertex == numVertex) = [];
            
            verticesConnectedInfo = dataVertID(ismember(vertexRealIDs, verticesConnectedToActualVertex), :);
            actualVerticesInfo = dataVertID(ismember(vertexRealIDs, numVertex), :);
            
            verticesConnectedSameRadiusID = verticesConnectedToActualVertex(cellfun(@(x) actualVerticesInfo{1, 1} == x, verticesConnectedInfo(:, 1)));
            
            if length(verticesConnectedSameRadiusID) < 2
                missingVerticesWithoutActual = setdiff(missingVertices, numVertex);
                missingVerticesSameRadiusIDs = missingVerticesWithoutActual(cellfun(@(x) x == actualVerticesInfo{1, 1},  dataVertID(ismember(vertexRealIDs, missingVerticesWithoutActual), 1)));
                
                if isempty(missingVerticesSameRadiusIDs) == 0
                    missingVerticesSameRadiusCells = dataVertID(ismember(vertexRealIDs, missingVerticesSameRadiusIDs), end);
                    [~, idMax] = max(cellfun(@(x) sum(ismember(actualVerticesInfo{1, end}, x)), missingVerticesSameRadiusCells));
                    newPairVertices = [newPairVertices; numVertex, missingVerticesSameRadiusIDs(idMax)];
                end
            end
        end
    end

    pairTotalVerticesModified = [pairTotalVertices; unique(sort(newPairVertices, 2), 'rows')];
end

