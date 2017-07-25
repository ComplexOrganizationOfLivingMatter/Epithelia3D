function [ exchangeNeighboursInfo ] = paintHeatmapOfTransitions( ellipsoidInfo, initialEllipsoid, outputDir )
%PAINTHEATMAPOFTRANSITIONS Summary of this function goes here
%   Detailed explanation goes here
    
    try
        exchangeNeighboursPerCell = cellfun(@(x, y) size(setxor(x, y), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood);

        figure('Visible', 'off');
        clmap = hot(10);
        clmap = clmap(size(clmap, 1):-1:1, :);
        ncl = size(clmap,1);
        
        ellipsoidInfo.cellArea = zeros(size(ellipsoidInfo.verticesPerCell, 1), 1);

        for cellIndex = 1:size(ellipsoidInfo.verticesPerCell, 1)
            cl = clmap(mod(exchangeNeighboursPerCell(cellIndex),ncl)+1,:);
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
        exchangeNeighboursInfo.xRadius = ellipsoidInfo.xRadius;
        exchangeNeighboursInfo.yRadius = ellipsoidInfo.yRadius;
        exchangeNeighboursInfo.zRadius = ellipsoidInfo.zRadius;
        exchangeNeighboursInfo.totalCells = size(exchangeNeighboursPerCell, 1);
        exchangeNeighboursInfo.cellHeight = ellipsoidInfo.cellHeight;
        
        exchangeNeighboursInfo.meanCellArea = mean(ellipsoidInfo.cellArea);
        exchangeNeighboursInfo.stdCellArea = std(ellipsoidInfo.cellArea);
        
        exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCell = sum(exchangeNeighboursPerCell) / size(exchangeNeighboursPerCell, 1);
        
        for numBorders = 1:size(ellipsoidInfo.bordersSituatedAt, 2)
            
            exchangeNeighboursInfo.bordersSituatedAt = ellipsoidInfo.bordersSituatedAt(numBorders);
            %We get select the cells at the borders from the initial ellipsoid.
            %Not from the reduced ellipsoid. Thus, we'll always get the same
            %centroids for all the different cell heights.
            cellsAtXBorderRight = initialEllipsoid.finalCentroids(:, 1) < -(exchangeNeighboursInfo.bordersSituatedAt * initialEllipsoid.xRadius);
            cellsAtYBorderRight = initialEllipsoid.finalCentroids(:, 2) < -(exchangeNeighboursInfo.bordersSituatedAt * initialEllipsoid.yRadius);
            cellsAtZBorderRight = initialEllipsoid.finalCentroids(:, 3) < -(exchangeNeighboursInfo.bordersSituatedAt * initialEllipsoid.zRadius);

            cellsAtXBorderLeft = initialEllipsoid.finalCentroids(:, 1) > (exchangeNeighboursInfo.bordersSituatedAt * initialEllipsoid.xRadius);
            cellsAtYBorderLeft = initialEllipsoid.finalCentroids(:, 2) > (exchangeNeighboursInfo.bordersSituatedAt * initialEllipsoid.yRadius);
            cellsAtZBorderLeft = initialEllipsoid.finalCentroids(:, 3) > (exchangeNeighboursInfo.bordersSituatedAt * initialEllipsoid.zRadius);

            exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtXBorderLeft = sum(exchangeNeighboursPerCell(cellsAtXBorderLeft)) / size(exchangeNeighboursPerCell(cellsAtXBorderLeft), 1);
            exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtXBorderRight = sum(exchangeNeighboursPerCell(cellsAtXBorderRight)) / size(exchangeNeighboursPerCell(cellsAtXBorderRight), 1);
            exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtXMiddle = sum(exchangeNeighboursPerCell(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0)) / size(exchangeNeighboursPerCell(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0), 1);

            exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtYBorderLeft = sum(exchangeNeighboursPerCell(cellsAtYBorderLeft)) / size(exchangeNeighboursPerCell(cellsAtYBorderLeft), 1);
            exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtYBorderRight = sum(exchangeNeighboursPerCell(cellsAtYBorderRight)) / size(exchangeNeighboursPerCell(cellsAtYBorderRight), 1);
            exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtYMiddle = sum(exchangeNeighboursPerCell(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0)) / size(exchangeNeighboursPerCell(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0), 1);

            exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtZBorderLeft = sum(exchangeNeighboursPerCell(cellsAtZBorderLeft)) / size(exchangeNeighboursPerCell(cellsAtZBorderLeft), 1);
            exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtZBorderRight = sum(exchangeNeighboursPerCell(cellsAtZBorderRight)) / size(exchangeNeighboursPerCell(cellsAtZBorderRight), 1);
            exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtZMiddle = sum(exchangeNeighboursPerCell(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0)) / size(exchangeNeighboursPerCell(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0), 1);

            exchangeNeighboursInfo.numCellsAtXBorderLeft = size(exchangeNeighboursPerCell(cellsAtXBorderLeft), 1);
            exchangeNeighboursInfo.numCellsAtXBorderRight = size(exchangeNeighboursPerCell(cellsAtXBorderRight), 1);
            exchangeNeighboursInfo.numCellsAtXMiddle = size(exchangeNeighboursPerCell(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0), 1);

            exchangeNeighboursInfo.numCellsAtYBorderLeft = size(exchangeNeighboursPerCell(cellsAtYBorderLeft), 1);
            exchangeNeighboursInfo.numCellsAtYBorderRight = size(exchangeNeighboursPerCell(cellsAtYBorderRight), 1);
            exchangeNeighboursInfo.numCellsAtYMiddle = size(exchangeNeighboursPerCell(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0), 1);

            exchangeNeighboursInfo.numCellsAtZBorderLeft = size(exchangeNeighboursPerCell(cellsAtZBorderLeft), 1);
            exchangeNeighboursInfo.numCellsAtZBorderRight = size(exchangeNeighboursPerCell(cellsAtZBorderRight), 1);
            exchangeNeighboursInfo.numCellsAtZMiddle = size(exchangeNeighboursPerCell(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0), 1);

            exchangeNeighboursInfo.areaOfXBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtXBorderLeft));
            exchangeNeighboursInfo.areaOfXBorderRight = sum(ellipsoidInfo.cellArea(cellsAtXBorderRight));
            exchangeNeighboursInfo.areaOfXMiddle = sum(ellipsoidInfo.cellArea(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0));

            exchangeNeighboursInfo.areaOfYBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtYBorderLeft));
            exchangeNeighboursInfo.areaOfYBorderRight = sum(ellipsoidInfo.cellArea(cellsAtYBorderRight));
            exchangeNeighboursInfo.areaOfYMiddle = sum(ellipsoidInfo.cellArea(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0));

            exchangeNeighboursInfo.areaOfZBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtZBorderLeft));
            exchangeNeighboursInfo.areaOfZBorderRight = sum(ellipsoidInfo.cellArea(cellsAtZBorderRight));
            exchangeNeighboursInfo.areaOfZMiddle = sum(ellipsoidInfo.cellArea(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0));
            
            exchangeNeighboursInfo = renameVariablesOfStructAddingSuffix(exchangeNeighboursInfo, num2str(round(exchangeNeighboursInfo.bordersSituatedAt*100)), {'Border', 'Middle'});
        end
        
        axis equal
        if isequal(outputDir, '') == 0
            savefig(strcat(outputDir, '\heatMap_ellipsoidReducted_x', num2str(ellipsoidInfo.xRadius), '_y', num2str(ellipsoidInfo.yRadius), '_z', num2str(ellipsoidInfo.zRadius), '_cellHeight', num2str(ellipsoidInfo.cellHeight), '.fig'));
        end
    catch exceptionHeatmap
        disp(strcat('Error in heatmap of ellipsoid xRadius=', num2str(ellipsoidInfo.xRadius), ', yRadius=', num2str(ellipsoidInfo.yRadius), ', zRadius=', num2str(ellipsoidInfo.zRadius), ' and cell height=', num2str(ellipsoidInfo.cellHeight)));
        disp(exceptionHeatmap.getReport);
        disp('--------------------------');
    end
        
end

