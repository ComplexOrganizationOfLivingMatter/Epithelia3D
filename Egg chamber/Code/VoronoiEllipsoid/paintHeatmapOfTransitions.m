function [ transitionsInfo ] = paintHeatmapOfTransitions( ellipsoidInfo, initialEllipsoid )
%PAINTHEATMAPOFTRANSITIONS Summary of this function goes here
%   Detailed explanation goes here
    
    try
        transitionsPerCell = cellfun(@(x, y) size(setxor(x, y), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood);
        
        transitionsInfo.xRadius = ellipsoidInfo.xRadius;
        transitionsInfo.yRadius = ellipsoidInfo.yRadius;
        transitionsInfo.zRadius = ellipsoidInfo.zRadius;
        transitionsInfo.bordersSituatedAt = 2/3;
        
        cellsAtXBorderDer = initialEllipsoid.finalCentroids(:, 1) < -(transitionsInfo.bordersSituatedAt * initialEllipsoid.xRadius);
        cellsAtYBorderDer = initialEllipsoid.finalCentroids(:, 2) < -(transitionsInfo.bordersSituatedAt * initialEllipsoid.yRadius);
        cellsAtZBorderDer = initialEllipsoid.finalCentroids(:, 3) < -(transitionsInfo.bordersSituatedAt * initialEllipsoid.zRadius);
        
        cellsAtXBorderIzq = initialEllipsoid.finalCentroids(:, 1) > (transitionsInfo.bordersSituatedAt * initialEllipsoid.xRadius);
        cellsAtYBorderIzq = initialEllipsoid.finalCentroids(:, 2) > (transitionsInfo.bordersSituatedAt * initialEllipsoid.yRadius);
        cellsAtZBorderIzq = initialEllipsoid.finalCentroids(:, 3) > (transitionsInfo.bordersSituatedAt * initialEllipsoid.zRadius);
        
        transitionsInfo.percentageOfTransitionsPerCell = sum(transitionsPerCell) / size(transitionsPerCell, 1);
        transitionsInfo.totalCells = size(transitionsPerCell, 1);
        
        transitionsInfo.percentageOfTransitionsPerCellAtXBorderIzq = sum(transitionsPerCell(cellsAtXBorderIzq)) / size(transitionsPerCell(cellsAtXBorderIzq), 1);
        transitionsInfo.percentageOfTransitionsPerCellAtXBorderDer = sum(transitionsPerCell(cellsAtXBorderDer)) / size(transitionsPerCell(cellsAtXBorderDer), 1);
        transitionsInfo.percentageOfTransitionsPerCellAtXMiddle = sum(transitionsPerCell(cellsAtXBorderDer == 0 & cellsAtXBorderIzq == 0)) / size(transitionsPerCell(cellsAtXBorderDer == 0 & cellsAtXBorderIzq == 0), 1);
        
        transitionsInfo.percentageOfTransitionsPerCellAtYBorderIzq = sum(transitionsPerCell(cellsAtYBorderIzq)) / size(transitionsPerCell(cellsAtYBorderIzq), 1);
        transitionsInfo.percentageOfTransitionsPerCellAtYBorderDer = sum(transitionsPerCell(cellsAtYBorderDer)) / size(transitionsPerCell(cellsAtYBorderDer), 1);
        transitionsInfo.percentageOfTransitionsPerCellAtYMiddle = sum(transitionsPerCell(cellsAtYBorderDer == 0 & cellsAtYBorderIzq == 0)) / size(transitionsPerCell(cellsAtYBorderDer == 0 & cellsAtYBorderIzq == 0), 1);
        
        transitionsInfo.percentageOfTransitionsPerCellAtZBorderIzq = sum(transitionsPerCell(cellsAtZBorderIzq)) / size(transitionsPerCell(cellsAtZBorderIzq), 1);
        transitionsInfo.percentageOfTransitionsPerCellAtZBorderDer = sum(transitionsPerCell(cellsAtZBorderDer)) / size(transitionsPerCell(cellsAtZBorderDer), 1);
        transitionsInfo.percentageOfTransitionsPerCellAtZMiddle = sum(transitionsPerCell(cellsAtZBorderDer == 0 & cellsAtZBorderIzq == 0)) / size(transitionsPerCell(cellsAtZBorderDer == 0 & cellsAtZBorderIzq == 0), 1);
        
        transitionsInfo.numCellsAtXBorderIzq = size(transitionsPerCell(cellsAtXBorderIzq), 1);
        transitionsInfo.numCellsAtXBorders = size(transitionsPerCell(cellsAtXBorderDer), 1);
        transitionsInfo.numCellsAtXMiddle = size(transitionsPerCell(cellsAtXBorderDer == 0 & cellsAtXBorderIzq == 0), 1);
        
        transitionsInfo.numCellsAtYBorderIzq = size(transitionsPerCell(cellsAtYBorderIzq), 1);
        transitionsInfo.numCellsAtYBorders = size(transitionsPerCell(cellsAtYBorderDer), 1);
        transitionsInfo.numCellsAtYMiddle = size(transitionsPerCell(cellsAtYBorderDer == 0 & cellsAtYBorderIzq == 0), 1);
        
        transitionsInfo.numCellsAtZBorderIzq = size(transitionsPerCell(cellsAtZBorderIzq), 1);
        transitionsInfo.numCellsAtZBorders = size(transitionsPerCell(cellsAtZBorderDer), 1);
        transitionsInfo.numCellsAtZMiddle = size(transitionsPerCell(cellsAtZBorderDer == 0 & cellsAtZBorderIzq == 0), 1);
        
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
            actualVerticesConnectCells = ellipsoidInfo.verticesConnectCells(indicesOfVertices);
            perimeterEdges = ellipsoidInfo.vertices(indicesOfVertices(1), :);
            previousVerticesConnectCells = actualVerticesConnectCells{1, 1}';
            indicesOfVertices(1) = [];
            actualVerticesConnectCells(1) = [];

            while ~isempty(actualVerticesConnectCells)
                nextEdge = find(cellfun(@(x) sum(ismember(previousVerticesConnectCells, x)) == 2, actualVerticesConnectCells));

                perimeterEdges(end+1, :) = ellipsoidInfo.vertices(indicesOfVertices(nextEdge(1)), :);
                previousVerticesConnectCells = actualVerticesConnectCells{nextEdge(1), 1}';
                actualVerticesConnectCells(nextEdge(1)) = [];
                indicesOfVertices(nextEdge(1)) = [];
            end

            plot3([perimeterEdges(end, 1); perimeterEdges(1, 1)], [perimeterEdges(end, 2); perimeterEdges(1, 2)], [perimeterEdges(end, 3); perimeterEdges(1, 3)], 'k')
            for i = 1:size(perimeterEdges, 1) - 1
                plot3([perimeterEdges(i, 1); perimeterEdges(i+1, 1)], [perimeterEdges(i, 2); perimeterEdges(i+1, 2)], [perimeterEdges(i, 3); perimeterEdges(i+1, 3)], 'k')
            end
        end
        axis equal
        savefig(strcat('..\resultsVoronoiEllipsoid/heatMap_ellipsoidReducted_x', num2str(ellipsoidInfo.xRadius), '_y', num2str(ellipsoidInfo.yRadius), '_z', num2str(ellipsoidInfo.zRadius), '_cellHeight', num2str(ellipsoidInfo.cellHeight), '.fig'));
    catch exceptionHeatmap
        disp(strcat('Error in heatmap of ellipsoid xRadius=', num2str(ellipsoidInfo.xRadius), ', yRadius=', num2str(ellipsoidInfo.yRadius), ', zRadius=', num2str(ellipsoidInfo.zRadius), ' and cell height=', num2str(ellipsoidInfo.cellHeight)));
        disp(exceptionHeatmap.getReport);
        disp('--------------------------');
    end
        
end

