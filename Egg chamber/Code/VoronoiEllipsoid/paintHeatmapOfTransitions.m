function [ transitionsInfo ] = paintHeatmapOfTransitions( ellipsoidInfo, initialEllipsoid, outputDir )
%PAINTHEATMAPOFTRANSITIONS Summary of this function goes here
%   Detailed explanation goes here
    
    try
        transitionsPerCell = cellfun(@(x, y) size(setxor(x, y), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood);
        
        figure('Visible', 'off');
        clmap = hot(10);
        clmap = clmap(size(clmap, 1):-1:1, :);
        ncl = size(clmap,1);
        
        ellipsoidInfo.cellArea = zeros(size(ellipsoidInfo.verticesPerCell, 1), 1);

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
            
            [~, ellipsoidInfo.cellArea(cellIndex)] = boundary(perimeterEdges(:, 1), perimeterEdges(:, 2), perimeterEdges(:, 3));
            %trisurf(k,perimeterEdges(:, 1), perimeterEdges(:, 2), perimeterEdges(:, 3),'Facecolor','red','FaceAlpha',0.1)
            
            plot3([perimeterEdges(end, 1); perimeterEdges(1, 1)], [perimeterEdges(end, 2); perimeterEdges(1, 2)], [perimeterEdges(end, 3); perimeterEdges(1, 3)], 'k')
            for i = 1:size(perimeterEdges, 1) - 1
                plot3([perimeterEdges(i, 1); perimeterEdges(i+1, 1)], [perimeterEdges(i, 2); perimeterEdges(i+1, 2)], [perimeterEdges(i, 3); perimeterEdges(i+1, 3)], 'k')
            end
        end
        
        %%Creating row of excel
        transitionsInfo.xRadius = ellipsoidInfo.xRadius;
        transitionsInfo.yRadius = ellipsoidInfo.yRadius;
        transitionsInfo.zRadius = ellipsoidInfo.zRadius;
        transitionsInfo.bordersSituatedAt = 2/3;
        transitionsInfo.totalCells = size(transitionsPerCell, 1);
        transitionsInfo.cellHeight = ellipsoidInfo.cellHeight;
        
        cellsAtXBorderRight = initialEllipsoid.finalCentroids(:, 1) < -(transitionsInfo.bordersSituatedAt * initialEllipsoid.xRadius);
        cellsAtYBorderRight = initialEllipsoid.finalCentroids(:, 2) < -(transitionsInfo.bordersSituatedAt * initialEllipsoid.yRadius);
        cellsAtZBorderRight = initialEllipsoid.finalCentroids(:, 3) < -(transitionsInfo.bordersSituatedAt * initialEllipsoid.zRadius);
        
        cellsAtXBorderLeft = initialEllipsoid.finalCentroids(:, 1) > (transitionsInfo.bordersSituatedAt * initialEllipsoid.xRadius);
        cellsAtYBorderLeft = initialEllipsoid.finalCentroids(:, 2) > (transitionsInfo.bordersSituatedAt * initialEllipsoid.yRadius);
        cellsAtZBorderLeft = initialEllipsoid.finalCentroids(:, 3) > (transitionsInfo.bordersSituatedAt * initialEllipsoid.zRadius);
        
        transitionsInfo.percentageOfTransitionsPerCell = sum(transitionsPerCell) / size(transitionsPerCell, 1);
        
        
        transitionsInfo.percentageOfTransitionsPerCellAtXBorderLeft = sum(transitionsPerCell(cellsAtXBorderLeft)) / size(transitionsPerCell(cellsAtXBorderLeft), 1);
        transitionsInfo.percentageOfTransitionsPerCellAtXBorderRight = sum(transitionsPerCell(cellsAtXBorderRight)) / size(transitionsPerCell(cellsAtXBorderRight), 1);
        transitionsInfo.percentageOfTransitionsPerCellAtXMiddle = sum(transitionsPerCell(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0)) / size(transitionsPerCell(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0), 1);
        
        transitionsInfo.percentageOfTransitionsPerCellAtYBorderLeft = sum(transitionsPerCell(cellsAtYBorderLeft)) / size(transitionsPerCell(cellsAtYBorderLeft), 1);
        transitionsInfo.percentageOfTransitionsPerCellAtYBorderRight = sum(transitionsPerCell(cellsAtYBorderRight)) / size(transitionsPerCell(cellsAtYBorderRight), 1);
        transitionsInfo.percentageOfTransitionsPerCellAtYMiddle = sum(transitionsPerCell(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0)) / size(transitionsPerCell(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0), 1);
        
        transitionsInfo.percentageOfTransitionsPerCellAtZBorderLeft = sum(transitionsPerCell(cellsAtZBorderLeft)) / size(transitionsPerCell(cellsAtZBorderLeft), 1);
        transitionsInfo.percentageOfTransitionsPerCellAtZBorderRight = sum(transitionsPerCell(cellsAtZBorderRight)) / size(transitionsPerCell(cellsAtZBorderRight), 1);
        transitionsInfo.percentageOfTransitionsPerCellAtZMiddle = sum(transitionsPerCell(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0)) / size(transitionsPerCell(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0), 1);
        
        transitionsInfo.numCellsAtXBorderLeft = size(transitionsPerCell(cellsAtXBorderLeft), 1);
        transitionsInfo.numCellsAtXBorderRight = size(transitionsPerCell(cellsAtXBorderRight), 1);
        transitionsInfo.numCellsAtXMiddle = size(transitionsPerCell(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0), 1);
        
        transitionsInfo.numCellsAtYBorderLeft = size(transitionsPerCell(cellsAtYBorderLeft), 1);
        transitionsInfo.numCellsAtYBorderRight = size(transitionsPerCell(cellsAtYBorderRight), 1);
        transitionsInfo.numCellsAtYMiddle = size(transitionsPerCell(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0), 1);
        
        transitionsInfo.numCellsAtZBorderLeft = size(transitionsPerCell(cellsAtZBorderLeft), 1);
        transitionsInfo.numCellsAtZBorderRight = size(transitionsPerCell(cellsAtZBorderRight), 1);
        transitionsInfo.numCellsAtZMiddle = size(transitionsPerCell(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0), 1);
        
        transitionsInfo.meanCellArea = mean(ellipsoidInfo.cellArea);
        transitionsInfo.stdCellArea = std(ellipsoidInfo.cellArea);
        
        transitionsInfo.areaOfXBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtXBorderLeft));
        transitionsInfo.areaOfXBorderRight = sum(ellipsoidInfo.cellArea(cellsAtXBorderRight));
        transitionsInfo.areaOfXMiddle = sum(ellipsoidInfo.cellArea(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0));
        
        transitionsInfo.areaOfYBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtYBorderLeft));
        transitionsInfo.areaOfYBorderRight = sum(ellipsoidInfo.cellArea(cellsAtYBorderRight));
        transitionsInfo.areaOfYMiddle = sum(ellipsoidInfo.cellArea(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0));
        
        transitionsInfo.areaOfZBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtZBorderLeft));
        transitionsInfo.areaOfZBorderRight = sum(ellipsoidInfo.cellArea(cellsAtZBorderRight));
        transitionsInfo.areaOfZMiddle = sum(ellipsoidInfo.cellArea(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0));
        
        axis equal
        savefig(strcat(outputDir, '\heatMap_ellipsoidReducted_x', num2str(ellipsoidInfo.xRadius), '_y', num2str(ellipsoidInfo.yRadius), '_z', num2str(ellipsoidInfo.zRadius), '_cellHeight', num2str(ellipsoidInfo.cellHeight), '.fig'));
    catch exceptionHeatmap
        disp(strcat('Error in heatmap of ellipsoid xRadius=', num2str(ellipsoidInfo.xRadius), ', yRadius=', num2str(ellipsoidInfo.yRadius), ', zRadius=', num2str(ellipsoidInfo.zRadius), ' and cell height=', num2str(ellipsoidInfo.cellHeight)));
        disp(exceptionHeatmap.getReport);
        disp('--------------------------');
    end
        
end

