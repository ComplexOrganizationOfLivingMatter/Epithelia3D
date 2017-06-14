function [ ] = paintHeatmapOfTransitions( ellipsoidInfo, initialNeighbourhood )
%PAINTHEATMAPOFTRANSITIONS Summary of this function goes here
%   Detailed explanation goes here

    transitionsPerCell = cellfun(@(x, y) size(setxor(x, y), 1), ellipsoidInfo.neighbourhood, initialNeighbourhood);
    
    figure('Visible', 'off');
    clmap = hot(10);
    clmap = clmap(size(clmap, 1):-1:1, :);
    ncl = size(clmap,1);

    for cellIndex = 1:size(ellipsoidInfo.verticesPerCell, 1)
        cl = clmap(mod(transitionsPerCell(cellIndex),ncl)+1,:);
        VertCell = ellipsoidInfo.verticesPerCell{cellIndex};
        KVert = convhulln([VertCell; ellipsoidInfo.finalCentroids(cellIndex, :)]);
        patch('Vertices',[VertCell; ellipsoidInfo.finalCentroids(cellIndex, :)],'Faces', KVert,'FaceColor', cl ,'FaceAlpha', 1, 'EdgeColor', 'none')
        hold on;
        %painting perimeter of cell
        indicesOfVertices = find(cellfun(@(x) ismember(cellIndex, x), ellipsoidInfo.verticesConnectCells));
        actualVerticesConnectCells = [ellipsoidInfo.verticesConnectCells{indicesOfVertices}]';
        perimeterEdges = ellipsoidInfo.vertices(indicesOfVertices(1), :);
        previousVerticesConnectCells = actualVerticesConnectCells(1, :);
        indicesOfVertices(1) = [];
        actualVerticesConnectCells(1, :) = [];
        
        while size(actualVerticesConnectCells, 1) > 0
            nextEdge = find(cellfun(@(x) sum(ismember(previousVerticesConnectCells, x)) == 2, mat2cell(actualVerticesConnectCells, ones(size(actualVerticesConnectCells, 1), 1), 3)));
            %TODO: peta porque las aristas no cierran la celula, pero el
            %error no esta aqui, esta en el refineVertices
            perimeterEdges(end+1, :) = ellipsoidInfo.vertices(indicesOfVertices(nextEdge(1)), :);
            previousVerticesConnectCells = actualVerticesConnectCells(nextEdge(1), :);
            actualVerticesConnectCells(nextEdge(1), :) = [];
            indicesOfVertices(nextEdge(1)) = [];
        end
        plot3([perimeterEdges(end, 1); perimeterEdges(1, 1)], [perimeterEdges(end, 2); perimeterEdges(1, 2)], [perimeterEdges(end, 3); perimeterEdges(1, 3)], 'k')
        for i = 1:size(perimeterEdges, 1) - 1
            plot3([perimeterEdges(i, 1); perimeterEdges(i+1, 1)], [perimeterEdges(i, 2); perimeterEdges(i+1, 2)], [perimeterEdges(i, 3); perimeterEdges(i+1, 3)], 'k')
        end
    end
    axis equal
end

