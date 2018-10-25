function [samiraTableVoronoi] = createSamiraFormatExcel_Simulations(pathFile, surfaceRatios)
%CREATESAMIRAFORMATEXCEL Summary of this function goes here
%   Detailed explanation goes here
%
%   Example: createSamiraFormatExcel('..\data\tubularVoronoiModel\expansion\2048x4096_200seeds\Image_2_Diagram_5\', 1.6667)
    addpath(genpath('lib'))
    
    maxDistance = 4;
    pathSplitted = strsplit(pathFile, '\');
    nameOfSimulation = pathSplitted{end-1};
    
    %% Simulations
    load(strcat(pathFile, nameOfSimulation,'.mat'), 'listLOriginalProjection');
    
    nameSplitted = strsplit(nameOfSimulation, '_');
    samiraTableVoronoi = {};
    dir2save = strcat(strjoin(pathSplitted(1:end-2), '\'),'\verticesSamira\');
    if ~exist(dir2save,'dir')
        mkdir(dir2save)
    end
    for nSurfR = [1 surfaceRatios]
        
        L_img = listLOriginalProjection{round([listLOriginalProjection{:,1}],3)==round(nSurfR,3),2};
        
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
        
        [verticesInfo] = removingVeryCloseVertices(verticesInfo, maxDistance);
        
        %Grouping cells
        cellWithVertices = groupingVerticesPerCellSurface(L_img, verticesInfo, verticesNoValidCellsInfo, [], 1, []);
        
        %% Looking for missing vertices
        missingVertices = [];
        missingVerticesCoord = [];
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
        
        cellsProp = regionprops(extendedImage, 'Centroid');
        
        [samiraTableVoronoiActualSR, cellsVoronoi] = tableWithSamiraFormat(cellWithVertices, cat(1,cellsProp.Centroid), missingVertices, nSurfR, pathSplitted, nameOfSimulation);
        
        samiraTableVoronoi = [samiraTableVoronoi; samiraTableVoronoiActualSR];
        
        %save vertices simulations
        
        %Create frusta table 
        if nSurfR == 1
            samiraTableFrusta = samiraTableVoronoi(:,1:4);
            verticesSR1=samiraTableVoronoi(:,5);
            samiraTableFrustaSR = samiraTableVoronoi;
            samiraTableFrusta_SRColumn = cellfun(@(x) x*nSurfR,samiraTableFrusta(:,1),'UniformOutput',false);

        else
            samiraTableFrusta_SRColumn = cellfun(@(x) x*nSurfR,samiraTableFrusta(:,1),'UniformOutput',false);
            verticesSR_frusta = cellfun(@(x) round([x(1:2:length(x)-1);x(2:2:length(x))*nSurfR]),verticesSR1,'UniformOutput',false);
            verticesSR_frusta = cellfun(@(x) x(:)',verticesSR_frusta,'UniformOutput',false);
            cellsFrusta = [samiraTableFrusta_SRColumn,samiraTableFrusta(:,2:4),verticesSR_frusta];
            samiraTableFrustaSR =  [samiraTableFrustaSR;cellsFrusta];
            
            %Plot frusta
            plotVerticesPerSurfaceRatio(cellsFrusta,[],dir2save,nameSplitted,'Frusta',nSurfR)

        end
    end
    samiraTableVoronoiT = cell2table(samiraTableVoronoi, 'VariableNames',{'Radius', 'CellIDs', 'TipCells', 'BorderCell','verticesValues_x_y'});
    samiraTableFrustaT = cell2table(samiraTableFrustaSR, 'VariableNames',{'Radius', 'CellIDs', 'TipCells', 'BorderCell','verticesValues_x_y'});

    newVoronoiCrossesTable = lookFor4cellsJunctionsAndExportTheExcel(samiraTableVoronoiT);
    newFrustaCrossesTable = lookFor4cellsJunctionsAndExportTheExcel(samiraTableFrustaT);

    writetable(samiraTableVoronoiT, strcat(dir2save, '\Voronoi_realization', nameSplitted{2} ,'_samirasFormat_', date, '.xls'));
    writetable(samiraTableFrustaT, strcat(dir2save, '\Frusta_realization', nameSplitted{2} ,'_samirasFormat_', date, '.xls'));
    writetable(newVoronoiCrossesTable, strcat(dir2save, '\Voronoi_realization', nameSplitted{2} ,'_VertCrosses_', date, '.xls'));
    writetable(newFrustaCrossesTable, strcat(dir2save, '\Frusta_realization', nameSplitted{2} ,'_VertCrosses_', date, '.xls'));

end
