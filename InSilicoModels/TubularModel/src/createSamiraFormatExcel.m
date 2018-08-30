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
        
        maxCells = max(verticesInfo.verticesConnectCells(:));
        
        %Create pairs of vertices
        pairTotalVertices = [];
        for numVertex = 1:size(verticesInfo.verticesConnectCells, 1)
            actualCellsOfVertex = verticesInfo.verticesConnectCells(numVertex, :);
            newConnections = find(sum(ismember(verticesInfo.verticesConnectCells, actualCellsOfVertex), 2) > 1);
            
            newConnections(newConnections==numVertex) = [];
            newPairs = [repmat(numVertex, length(newConnections), 1), newConnections];
            newPairs = sort(newPairs, 2);
            pairTotalVertices = [pairTotalVertices; newPairs];
        end
        
        %Perform unique
        pairTotalVertices = unique(pairTotalVertices, 'rows');
        
        %Maybe only valid cells?
        for numCell = 1:maxCells
            numCell = 54;
            verticesOfCellIDs = find(any(ismember(verticesInfo.verticesConnectCells, numCell), 2));
            
            actualPairTotalVertices = pairTotalVertices(all(ismember(pairTotalVertices, verticesOfCellIDs), 2), :);
            
            verticesOfCell = verticesInfo.verticesPerCell(verticesOfCellIDs);
            verticesOfCell = cell2mat(verticesOfCell);
            
            % Should be connected clockwise
            % I.e. from bigger numbers to smaller ones
            % Or the second vertex should in the left hand of the first
            
            [newOrderX, newOrderY] = poly2cw(verticesOfCell(:, 1), verticesOfCell(:, 2));
  
            samiraTable(end+1, :) = {nSurfR, numCell, [verticesRadius{:}]};
        end
    end
end

