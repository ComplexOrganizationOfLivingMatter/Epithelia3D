function [verticesInfo] = removingVeryCloseVertices(verticesInfo, maxDistance)
%REMOVINGVERYCLOSEVERTICES Summary of this function goes here
%   Detailed explanation goes here

    %Unifying vertices very close to each other
    allVertices = vertcat(verticesInfo.verticesPerCell{:});
    verticesDistances = squareform(pdist(allVertices));
    thresholdDistance = verticesDistances < maxDistance;
    newVertices = [];
    newVertices.verticesPerCell = {};
    newVertices.verticesConnectCells = [];
    removingVertices = [];
    for numVertex = 1:size(verticesDistances, 1)
        verticesOverlapping = find(thresholdDistance(numVertex, :));

        if length(verticesOverlapping) > 1
            for numVertOverlapping = 1:(length(verticesOverlapping))
                newVertices(end+1).verticesPerCell = round(mean(vertcat(verticesInfo.verticesPerCell{verticesOverlapping})));
                newVertices(end).verticesConnectCells = verticesInfo.verticesConnectCells(verticesOverlapping(numVertOverlapping), :);
            end
            removingVertices = [removingVertices, verticesOverlapping];
        end
    end

    newVertices(1) = [];
    [~, ids] = unique(vertcat(newVertices.verticesConnectCells), 'rows');
    newVertices = newVertices(ids);
    removingVertices = unique(removingVertices);
    verticesInfo.verticesConnectCells(removingVertices, :) = [];
    verticesInfo.verticesPerCell(removingVertices) = [];
    verticesInfo.verticesConnectCells = vertcat(verticesInfo.verticesConnectCells, newVertices.verticesConnectCells);
    verticesInfo.verticesPerCell = vertcat(verticesInfo.verticesPerCell, newVertices.verticesPerCell);
end

