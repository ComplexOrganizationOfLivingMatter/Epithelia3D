function [pairOfVerticesTotal] = unifyingDuplicatedVertices(dataVertID, pairOfVerticesTotal)
%UNIFYINGDUPLICATEDVERTICES Summary of this function goes here
%   Detailed explanation goes here
allVertices = cell2mat(dataVertID(:, 4:6));
    [~, uniqueVerticesIDs] = unique(allVertices, 'rows');
    duplicatedVerticesIDs = setdiff(1:size(dataVertID, 1), uniqueVerticesIDs);
    
    oldpairOfVerticesTotal = cell2mat(pairOfVerticesTotal(:, 1:2));
    newPairOfVerticesTotal = cell2mat(pairOfVerticesTotal(:, 1:2));
    for numDupliVertex = duplicatedVerticesIDs
        duplicatedIndices = ismember(allVertices, allVertices(numDupliVertex, :), 'rows');
        allVerticesDuplicated = find(duplicatedIndices);
        vertexToKeep = allVerticesDuplicated(allVerticesDuplicated ~= numDupliVertex);
        dataVertID(vertexToKeep, end) = {union(dataVertID{duplicatedIndices, end})};
        newPairOfVerticesTotal(ismember(oldpairOfVerticesTotal, numDupliVertex)) = vertexToKeep;
    end
    
    pairOfVerticesTotal(:, 1:2) = num2cell(newPairOfVerticesTotal);
    
    dataVertID(duplicatedVerticesIDs, :) = [];
    
    oldIDs = dataVertID(:, 3);
    dataVertID(:, 3) = mat2cell(1:size(dataVertID, 1), 1,  ones(size(dataVertID, 1), 1));
    
    oldpairOfVerticesTotal = cell2mat(pairOfVerticesTotal(:, 1:2));
    newPairOfVerticesTotal = cell2mat(pairOfVerticesTotal(:, 1:2));
    for numOldID = 1:size(dataVertID, 1)
        newPairOfVerticesTotal(ismember(oldpairOfVerticesTotal, oldIDs{numOldID})) = numOldID;
    end
    pairOfVerticesTotal(:, 1:2) = num2cell(newPairOfVerticesTotal);
end

