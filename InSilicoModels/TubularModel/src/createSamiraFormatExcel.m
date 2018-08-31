function [samiraTable] = createSamiraFormatExcel(pathFile, surfaceRatios)
%CREATESAMIRAFORMATEXCEL Summary of this function goes here
%   Detailed explanation goes here
%
%   Example: createSamiraFormatExcel('..\data\tubularVoronoiModel\expansion\2048x4096_200seeds\Image_2_Diagram_5\', 1.6667)
    addpath(genpath('lib'))

    pathSplitted = strsplit(pathFile, '\');
    nameOfSimulation = pathSplitted{end-1};
    load(strcat(pathFile, nameOfSimulation,'.mat'), 'listLOriginalProjection');

    samiraTable = {};
    for nSurfR = [1, surfaceRatios]
        L_img = listLOriginalProjection.L_originalProjection{round(listLOriginalProjection.surfaceRatio,3)==round(nSurfR,3)};
        
        [neighbours, ~] = calculateNeighbours(L_img);
        [ verticesInfo ] = calculateVertices( L_img, neighbours);
        [ verticesNoValidCellsInfo ] = getVerticesBorderNoValidCells( L_img );
        
        cellWithVertices = groupingVerticesPerCellSurface(L_img, verticesInfo, verticesNoValidCellsInfo, [], 1);          
        
        maxCells = max(L_img(:));
        
%         noValidCells = unique([L_img(:, 1)', L_img(1, :), L_img(:, end)', L_img(end, :)]);
%         
%         validCells = setdiff(1:maxCells, noValidCells);
        
        for numCell = 1:size(cellWithVertices, 1)
%             if ismember(numCell, validCells)
%                 verticesOfCellIDs = any(ismember(verticesInfo.verticesConnectCells, numCell), 2);
%                 verticesOfCell = verticesInfo.verticesPerCell(verticesOfCellIDs);
%             else
%                 verticesOfCellIDs = any(ismember(verticesNoValidCellsInfo.verticesConnectCells, numCell), 2);
%                 verticesOfCell = verticesNoValidCellsInfo.verticesPerCell(verticesOfCellIDs);
%             end
%             verticesOfCell = cell2mat(verticesOfCell);
            
            verticesOfCellInit = cellWithVertices{numCell, end};
            numberOfVertices = (size(verticesOfCellInit, 2)/2);
            verticesOfCell = [];
            verticesOfCell(1:numberOfVertices, 1) = verticesOfCellInit(1:2:end);
            verticesOfCell(1:numberOfVertices, 2) = verticesOfCellInit(2:2:end);
            
            orderBoundary = boundary(verticesOfCell(:, 1), verticesOfCell(:, 2), 0.1);
            
            if length(orderBoundary)-1 ~= size(verticesOfCell, 1)
               disp(strcat('Warning: cell number', num2str(numCell), ' may be wrongly done'));
               disp('Correcting...')
               missingVertices = setdiff(1:size(verticesOfCell, 1), orderBoundary);
               if length(missingVertices) == 1
                   matDistance = pdist(verticesOfCell);
                   matDistance = squareform(matDistance);
                   [~, closestVertex] = sort(matDistance(missingVertices, :));
                   closestVertex(closestVertex == missingVertices) = [];
                   closestVertex = closestVertex(1);
                   closestVertexPosition = find(orderBoundary == closestVertex);
                   possiblePartner = [orderBoundary(closestVertexPosition(end) - 1), orderBoundary(closestVertexPosition(1) + 1)];
                   distanceToPossiblePartner1 = matDistance(missingVertices, possiblePartner(1)) - matDistance(closestVertex, possiblePartner(1));
                   distanceToPossiblePartner2 = matDistance(missingVertices, possiblePartner(2)) - matDistance(closestVertex, possiblePartner(2));
                   
                   if distanceToPossiblePartner1 < distanceToPossiblePartner2
                       newLocation = closestVertexPosition(end) - 1;
                   else
                       newLocation = closestVertexPosition(1) + 1;
                   end
                   
                   if distanceToPossiblePartner1 ~= distanceToPossiblePartner2
                       orderBoundary = [orderBoundary(1:newLocation); missingVertices; orderBoundary(newLocation+1:end)];
                   end
               end
            end
            
            % Should be connected clockwise
            % I.e. from bigger numbers to smaller ones
            % Or the second vertex should in the left hand of the first
            [newOrderX, newOrderY] = poly2cw(verticesOfCell(orderBoundary(1:end-1), 1), verticesOfCell(orderBoundary(1:end-1), 2));
            
            verticesRadius = [];
%             figure;
%             previousVertex = [newOrderX(end), newOrderY(end)];
            for numVertex = 1:length(newOrderX)
%                 plot([previousVertex(1), newOrderX(numVertex)], [previousVertex(2), newOrderY(numVertex)]);
%                 hold on;
%                 previousVertex = [newOrderX(numVertex), newOrderY(numVertex)];
                verticesRadius(end+1) = newOrderX(numVertex);
                verticesRadius(end+1) = newOrderY(numVertex);
            end
            samiraTable = [samiraTable; nSurfR, cellWithVertices{numCell, 3}, {verticesRadius}];
        end
    end
    samiraTableT = cell2table(samiraTable, 'VariableNames',{'Radius', 'CellIDs', 'verticesValues_x_y'});
    typeOfSimulation = 'voronoi';
    nameSplitted = strsplit(nameOfSimulation, '_');
    writetable(samiraTableT, strcat(strjoin(pathSplitted(1:end-2), '\'), '\', typeOfSimulation, '_realization', nameSplitted{2} ,'_samirasFormat_', date, '.xls'));
end

