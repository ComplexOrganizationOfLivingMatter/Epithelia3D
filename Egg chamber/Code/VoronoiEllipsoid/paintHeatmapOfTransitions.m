function [ transitionsInfo, ellipsoidInfo, initialEllipsoid ] = paintHeatmapOfTransitions( ellipsoidInfo, initialEllipsoid, outputDir )
%PAINTHEATMAPOFTRANSITIONS Summary of this function goes here
%   Detailed explanation goes here
    
    try
        numberOfExchangeNeighboursPerCell = cellfun(@(x, y) size(setxor(x, y), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood);
        transitionsPerCell = cellfun(@(x, y) setxor(x, y), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood, 'UniformOutput', false);
        
        motifsInitial = [];
        motifsReducted = [];
        centroidsOfMotifs = [];
        for numExchange = 1:size(transitionsPerCell, 1)
            neighbourExchangeActual = transitionsPerCell{numExchange};
            for numTransitions = 1:size(neighbourExchangeActual, 1)
                motifsInitial(end+1, :) = vertcat(intersect(initialEllipsoid.neighbourhood{numExchange}, initialEllipsoid.neighbourhood{neighbourExchangeActual(numTransitions)}), neighbourExchangeActual(numTransitions), numExchange);
                motifsReducted(end+1, :) = vertcat(intersect(ellipsoidInfo.neighbourhood{numExchange}, ellipsoidInfo.neighbourhood{neighbourExchangeActual(numTransitions)}), neighbourExchangeActual(numTransitions), numExchange);
                centroidsOfMotifs(end+1, :) = mean(initialEllipsoid.finalCentroids(motifsInitial(end, :), :), 1);
            end
        end
        if isempty(motifsReducted) == 0
            [~, indices] = unique(motifsReducted(:, 1:2), 'rows');
            ellipsoidInfo.motifsFound = motifsReducted(indices, :);

            [~, indices] = unique(motifsInitial(:, 1:2), 'rows');
            initialEllipsoid.motifsFound = motifsInitial(indices, :);
            motifsFound = motifsInitial(indices, :);
            centroidsOfMotifs = centroidsOfMotifs(indices, :);
        end
        
        figure('Visible', 'off');
        clmap = hot(10);
        clmap = clmap(size(clmap, 1):-1:1, :);
        ncl = size(clmap,1);
        
        ellipsoidInfo.cellArea = zeros(size(ellipsoidInfo.verticesPerCell, 1), 1);

        for cellIndex = 1:size(ellipsoidInfo.verticesPerCell, 1)
            cl = clmap(mod(numberOfExchangeNeighboursPerCell(cellIndex),ncl)+1,:);
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
        transitionsInfo.totalCells = size(numberOfExchangeNeighboursPerCell, 1);
        transitionsInfo.cellHeight = ellipsoidInfo.cellHeight;
        %We get select the cells at the borders from the initial ellipsoid.
        %Not from the reduced ellipsoid. Thus, we'll always get the same
        %centroids for all the different cell heights.
        cellsAtXBorderRight = initialEllipsoid.finalCentroids(:, 1) < -(transitionsInfo.bordersSituatedAt * initialEllipsoid.xRadius);
        cellsAtYBorderRight = initialEllipsoid.finalCentroids(:, 2) < -(transitionsInfo.bordersSituatedAt * initialEllipsoid.yRadius);
        cellsAtZBorderRight = initialEllipsoid.finalCentroids(:, 3) < -(transitionsInfo.bordersSituatedAt * initialEllipsoid.zRadius);
        
        cellsAtXBorderLeft = initialEllipsoid.finalCentroids(:, 1) > (transitionsInfo.bordersSituatedAt * initialEllipsoid.xRadius);
        cellsAtYBorderLeft = initialEllipsoid.finalCentroids(:, 2) > (transitionsInfo.bordersSituatedAt * initialEllipsoid.yRadius);
        cellsAtZBorderLeft = initialEllipsoid.finalCentroids(:, 3) > (transitionsInfo.bordersSituatedAt * initialEllipsoid.zRadius);

        
        if isempty(centroidsOfMotifs) == 0
            transitionsAtXBorderRight = centroidsOfMotifs(:, 1) < -(transitionsInfo.bordersSituatedAt * initialEllipsoid.xRadius);
            transitionsAtYBorderRight = centroidsOfMotifs(:, 2) < -(transitionsInfo.bordersSituatedAt * initialEllipsoid.yRadius);
            transitionsAtZBorderRight = centroidsOfMotifs(:, 3) < -(transitionsInfo.bordersSituatedAt * initialEllipsoid.zRadius);
        
            transitionsAtXBorderLeft = centroidsOfMotifs(:, 1) > (transitionsInfo.bordersSituatedAt * initialEllipsoid.xRadius);
            transitionsAtYBorderLeft = centroidsOfMotifs(:, 2) > (transitionsInfo.bordersSituatedAt * initialEllipsoid.yRadius);
            transitionsAtZBorderLeft = centroidsOfMotifs(:, 3) > (transitionsInfo.bordersSituatedAt * initialEllipsoid.zRadius);
       
            transitionsInfo.percentageOftransitionsPerCell = size(motifsFound, 1) / size(transitionsPerCell, 1);
        
            transitionsInfo.percentageOftransitionsPerCellAtXBorderLeft = size(motifsFound(transitionsAtXBorderLeft), 1) / size(transitionsPerCell(cellsAtXBorderLeft), 1);
            transitionsInfo.percentageOftransitionsPerCellAtXBorderRight = size(motifsFound(transitionsAtXBorderRight), 1) / size(transitionsPerCell(cellsAtXBorderRight), 1);
            transitionsInfo.percentageOftransitionsPerCellAtXMiddle = size(motifsFound(transitionsAtXBorderRight == 0 & transitionsAtXBorderLeft == 0), 1) / size(transitionsPerCell(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0), 1);

            transitionsInfo.percentageOftransitionsPerCellAtYBorderLeft = size(motifsFound(transitionsAtYBorderLeft), 1) / size(transitionsPerCell(cellsAtYBorderLeft), 1);
            transitionsInfo.percentageOftransitionsPerCellAtYBorderRight = size(motifsFound(transitionsAtYBorderRight), 1) / size(transitionsPerCell(cellsAtYBorderRight), 1);
            transitionsInfo.percentageOftransitionsPerCellAtYMiddle = size(motifsFound(transitionsAtYBorderRight == 0 & transitionsAtYBorderLeft == 0), 1) / size(transitionsPerCell(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0), 1);

            transitionsInfo.percentageOftransitionsPerCellAtZBorderLeft = size(motifsFound(transitionsAtZBorderLeft), 1) / size(transitionsPerCell(cellsAtZBorderLeft), 1);
            transitionsInfo.percentageOftransitionsPerCellAtZBorderRight = size(motifsFound(transitionsAtZBorderRight), 1) / size(transitionsPerCell(cellsAtZBorderRight), 1);
            transitionsInfo.percentageOftransitionsPerCellAtZMiddle = size(motifsFound(transitionsAtZBorderRight == 0 & transitionsAtZBorderLeft == 0), 1) / size(transitionsPerCell(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0), 1);
        else
            transitionsInfo.percentageOftransitionsPerCell = 0;
        
            transitionsInfo.percentageOftransitionsPerCellAtXBorderLeft = 0;
            transitionsInfo.percentageOftransitionsPerCellAtXBorderRight = 0;
            transitionsInfo.percentageOftransitionsPerCellAtXMiddle = 0;

            transitionsInfo.percentageOftransitionsPerCellAtYBorderLeft = 0;
            transitionsInfo.percentageOftransitionsPerCellAtYBorderRight = 0;
            transitionsInfo.percentageOftransitionsPerCellAtYMiddle = 0;

            transitionsInfo.percentageOftransitionsPerCellAtZBorderLeft = 0;
            transitionsInfo.percentageOftransitionsPerCellAtZBorderRight = 0;
            transitionsInfo.percentageOftransitionsPerCellAtZMiddle = 0;
        end
        
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
        if isequal(outputDir, '') == 0
            savefig(strcat(outputDir, '\heatMap_ellipsoidReducted_x', num2str(ellipsoidInfo.xRadius), '_y', num2str(ellipsoidInfo.yRadius), '_z', num2str(ellipsoidInfo.zRadius), '_cellHeight', num2str(ellipsoidInfo.cellHeight), '.fig'));
        end
    catch exceptionHeatmap
        disp(strcat('Error in heatmap of ellipsoid xRadius=', num2str(ellipsoidInfo.xRadius), ', yRadius=', num2str(ellipsoidInfo.yRadius), ', zRadius=', num2str(ellipsoidInfo.zRadius), ' and cell height=', num2str(ellipsoidInfo.cellHeight)));
        disp(exceptionHeatmap.getReport);
        disp('--------------------------');
    end
        
end

