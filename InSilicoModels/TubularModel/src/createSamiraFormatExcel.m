function [samiraTable] = createSamiraFormatExcel(pathFile, surfaceRatios, typeOfSimulation)
%CREATESAMIRAFORMATEXCEL Summary of this function goes here
%   Detailed explanation goes here
%
%   Example: createSamiraFormatExcel('..\data\tubularVoronoiModel\expansion\2048x4096_200seeds\Image_2_Diagram_5\', 1.6667)
    addpath(genpath('lib'))

    pathSplitted = strsplit(pathFile, '\');
    nameOfSimulation = pathSplitted{end-1};
    load(strcat(pathFile, nameOfSimulation,'.mat'), 'listLOriginalProjection');
    
    nameSplitted = strsplit(nameOfSimulation, '_');
    samiraTable = {};
    for nSurfR = [1, surfaceRatios]
        L_img = listLOriginalProjection.L_originalProjection{round(listLOriginalProjection.surfaceRatio,3)==round(nSurfR,3)};
        
        %We use L_img a little bit extended for get lateral border
        %vertices.
        [neighbours, ~] = calculateNeighbours([L_img(:,end-1:end),L_img,L_img(:,1:2)]);
        [ verticesInfo ] = calculateVertices([L_img(:,end-1:end),L_img,L_img(:,1:2)], neighbours);
        [ verticesNoValidCellsInfo ] = getVerticesBorderNoValidCells( [L_img(:,end-1:end),L_img,L_img(:,1:2)] );
        
        %Later we filter for deleting the vertices in the extended zone
        vertInsideRange=cellfun(@(x) x(2)>2 | x(2)< end-1 ,verticesInfo.verticesPerCell);
        verticesInfo.verticesPerCell(~vertInsideRange,:)=[];
        vertNoValCellsInsideRange=cellfun(@(x) x(2)>2 | x(2)< end-1 ,verticesNoValidCellsInfo.verticesPerCell);
        verticesNoValidCellsInfo.verticesPerCell(~vertNoValCellsInsideRange,:)=[];
        verticesInfo.verticesPerCell=cellfun(@(x)  [x(1),x(2)-2] ,verticesInfo.verticesPerCell,'UniformOutput',false);
        verticesNoValidCellsInfo.verticesPerCell=cellfun(@(x)  [x(1),x(2)-2] ,verticesNoValidCellsInfo.verticesPerCell,'UniformOutput',false);

        
        cellWithVertices = groupingVerticesPerCellSurface(L_img, verticesInfo, verticesNoValidCellsInfo, [], 1);          
        
        maxCells = max(L_img(:));
        
%         noValidCells = unique([L_img(:, 1)', L_img(1, :), L_img(:, end)', L_img(end, :)]);
%         
%         validCells = setdiff(1:maxCells, noValidCells);
        figure('Visible', 'off', 'units','normalized','outerposition',[0 0 1 1]);
        faceColours = [1 1 1; 1 1 0; 1 0.5 0];
        edgeColours = [0 0 1; 0 1 0];
        
        
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
            
            faceColour = faceColours(cellWithVertices{numCell, 5}+1, :); 
            patch(newOrderX, newOrderY, faceColour);
            hold on;
            
            text(mean(newOrderX) - 20, mean(newOrderY), num2str(cellWithVertices{numCell, 3}));
            
            verticesRadius = [];
            previousVertex = [newOrderX(end), newOrderY(end)];
            
            edgeColour = edgeColours(cellWithVertices{numCell, 4}+1, :);
            for numVertex = 1:length(newOrderX)
                plot([previousVertex(1), newOrderX(numVertex)], [previousVertex(2), newOrderY(numVertex)], 'Color', edgeColour, 'LineWidth', 3);
                previousVertex = [newOrderX(numVertex), newOrderY(numVertex)];
                verticesRadius(end+1) = newOrderX(numVertex);
                verticesRadius(end+1) = newOrderY(numVertex);
            end
            
            samiraTable = [samiraTable; nSurfR, cellWithVertices{numCell, 3:5}, {verticesRadius}];
        end
        print(strcat(strjoin(pathSplitted(1:end-2), '\'), '\plot_', typeOfSimulation, '_realization', nameSplitted{2} , '_', date, '.png'), '-dpng', '-r300');
    end
    samiraTableT = cell2table(samiraTable, 'VariableNames',{'Radius', 'CellIDs', 'TipCells', 'BorderCell','verticesValues_x_y'});
    
    writetable(samiraTableT, strcat(strjoin(pathSplitted(1:end-2), '\'), '\', typeOfSimulation, '_realization', nameSplitted{2} ,'_samirasFormat_', date, '.xls'));
end

