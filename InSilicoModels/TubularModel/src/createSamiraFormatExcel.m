function [samiraTable] = createSamiraFormatExcel(pathFile, surfaceRatios, typeOfSimulation)
%CREATESAMIRAFORMATEXCEL Summary of this function goes here
%   Detailed explanation goes here
%
%   Example: createSamiraFormatExcel('..\data\tubularVoronoiModel\expansion\2048x4096_200seeds\Image_2_Diagram_5\', 1.6667)
    addpath(genpath('lib'))
    
    maxDistance = 4;

    pathSplitted = strsplit(pathFile, '\');
    nameOfSimulation = pathSplitted{end-1};
    load(strcat(pathFile, nameOfSimulation,'.mat'), 'listLOriginalProjection');
    
    nameSplitted = strsplit(nameOfSimulation, '_');
    samiraTable = {};
    for nSurfR = [1 surfaceRatios]
        L_img = listLOriginalProjection.L_originalProjection{round(listLOriginalProjection.surfaceRatio,3)==round(nSurfR,3)};
        
        %We use L_img a little bit extended for get lateral border
        %vertices.
        extendedImage = [L_img(:,end-1:end),L_img,L_img(:,1:2)];
        [neighbours, ~] = calculateNeighbours(extendedImage);
        [ verticesInfo ] = calculateVertices(extendedImage, neighbours);
        [ verticesNoValidCellsInfo ] = getVerticesBorderNoValidCells( extendedImage);
        
        %Later we filter for deleting the vertices in the extended zone
        vertInsideRange=cellfun(@(x) x(2)>2 | x(2) < size(extendedImage, 2)-1 ,verticesInfo.verticesPerCell);
        verticesInfo.verticesPerCell(~vertInsideRange,:)=[];
        vertNoValCellsInsideRange=cellfun(@(x) x(2)>2 | x(2)< size(extendedImage, 2)-1 ,verticesNoValidCellsInfo.verticesPerCell);
        verticesNoValidCellsInfo.verticesPerCell(~vertNoValCellsInsideRange,:)=[];
        verticesInfo.verticesPerCell=cellfun(@(x)  [x(1),x(2)-2] ,verticesInfo.verticesPerCell,'UniformOutput',false);
        verticesNoValidCellsInfo.verticesPerCell=cellfun(@(x)  [x(1),x(2)-2] ,verticesNoValidCellsInfo.verticesPerCell,'UniformOutput',false);

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
        
        %Grouping cells
        cellWithVertices = groupingVerticesPerCellSurface(L_img, verticesInfo, verticesNoValidCellsInfo, [], 1);          
        
        maxCells = max(L_img(:));
        
%         noValidCells = unique([L_img(:, 1)', L_img(1, :), L_img(:, end)', L_img(end, :)]);
%         
%         validCells = setdiff(1:maxCells, noValidCells);
        figure('Visible', 'off', 'units','normalized','outerposition',[0 0 1 1]);
        faceColours = [1 1 1; 1 1 0; 1 0.5 0];
        edgeColours = [0 0 1; 0 1 0];
        
        %% Looking for missing vertices
        missingVertices = [];
        for numCell = 1:size(cellWithVertices, 1)
            verticesOfCellInit = cellWithVertices{numCell, end};
            numberOfVertices = (size(verticesOfCellInit, 2)/2);
            verticesOfCell = [];
            verticesOfCell(1:numberOfVertices, 1) = verticesOfCellInit(1:2:end);
            verticesOfCell(1:numberOfVertices, 2) = verticesOfCellInit(2:2:end);
            
            orderBoundary = boundary(verticesOfCell(:, 1), verticesOfCell(:, 2), 0.1);
            if length(orderBoundary)-1 ~= size(verticesOfCell, 1)
                missingVerticesCell = setdiff(1:size(verticesOfCell, 1), orderBoundary);
                for missingVerticesActual = missingVerticesCell
                    %Finding closest neighbour
                    matDistance = pdist(verticesOfCell);
                    matDistance = squareform(matDistance);
                    [~, closestVertex] = sort(matDistance(missingVerticesActual, :));
                    closestVertex(closestVertex == missingVerticesActual) = [];
                    closestVertex = closestVertex(1);
                    matDistance(missingVerticesActual, closestVertex);
                    if isequal(verticesOfCell(missingVerticesActual, :), verticesOfCell(closestVertex, :)) == 0
                        if isempty(missingVertices)
                            missingVertices = [verticesOfCell(missingVerticesActual, :), verticesOfCell(closestVertex, :)];
                        elseif ismember(verticesOfCell(missingVerticesActual, :), missingVertices(:, 3:4), 'rows') == 0
                            missingVertices = [missingVertices; verticesOfCell(missingVerticesActual, :), verticesOfCell(closestVertex, :)];
                        end
                    end
                end
            end
        end
        
        for numCell = 1:size(cellWithVertices, 1)
            
            verticesOfCellInit = cellWithVertices{numCell, end};
 
            numberOfVertices = (size(verticesOfCellInit, 2)/2);
            verticesOfCell = [];
            verticesOfCell(1:numberOfVertices, 1) = verticesOfCellInit(1:2:end);
            verticesOfCell(1:numberOfVertices, 2) = verticesOfCellInit(2:2:end);
            
            %Replace the missing cells
            for numPair = 1:size(missingVertices, 1)
                verticesToReplace = ismember(verticesOfCell, missingVertices(numPair, 1:2), 'rows');
                replaceWith = missingVertices(numPair, 3:4);
                
                if any(verticesToReplace) > 0
                    verticesOfCell(verticesToReplace, :) = replaceWith;
                end
            end
            
            verticesOfCell = unique(verticesOfCell, 'rows');
            
            orderBoundary = boundary(verticesOfCell(:, 1), verticesOfCell(:, 2), 0.1);
            missingVerticesActual = [];
            if length(orderBoundary)-1 ~= size(verticesOfCell, 1)
               disp(strcat('Warning: cell number', num2str(cellWithVertices{numCell, 3}), ' may be wrongly done'));
               disp('Correcting...')
               missingVerticesActual = setdiff(1:size(verticesOfCell, 1), orderBoundary);
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
                hold on;
                plot(newOrderX(numVertex), newOrderY(numVertex), '*r')
                previousVertex = [newOrderX(numVertex), newOrderY(numVertex)];
                verticesRadius(end+1) = newOrderX(numVertex);
                verticesRadius(end+1) = newOrderY(numVertex);
            end
            for numMissingVertex = missingVerticesActual
                plot(verticesOfCell(numMissingVertex, 1), verticesOfCell(numMissingVertex, 2), 'Oc')
            end
            
            samiraTable = [samiraTable; nSurfR, cellWithVertices{numCell, 3:5}, {verticesRadius}];
        end
        
        if nSurfR == 1
            
            samiraTableFrusta = samiraTable(:,1:4);
            verticesSR1=samiraTable(:,5);
            samiraTableFrustaSR = samiraTable;
            
        else
            verticesSR_frusta = cellfun(@(x) x(2:2:length(x))*nSurfR,verticesSR1);
            samiraTableFrustaSR =  [samiraTableFrustaSR;samiraTableFrusta,verticesSR_frusta];
        end
        
        print(strcat(strjoin(pathSplitted(1:end-2), '\'), '\plot_Voronoi_realization', nameSplitted{2} , '_SurfaceRatio_', num2str(nSurfR), '_', date, '.png'), '-dpng', '-r300');
    end
    samiraTableT = cell2table(samiraTable, 'VariableNames',{'Radius', 'CellIDs', 'TipCells', 'BorderCell','verticesValues_x_y'});
    
    writetable(samiraTableT, strcat(strjoin(pathSplitted(1:end-2), '\'), '\Voronoi_realization', nameSplitted{2} ,'_samirasFormat_', date, '.xls'));
end
