function [samiraTableVoronoi, cellsVoronoi] = tableWithSamiraFormat(cellWithVertices,cellCentroids, missingVertices, nSurfR, pathSplitted, nameOfSimulation)
%TABLEWITHSAMIRAFORMAT Summary of this function goes here
%   Detailed explanation goes here
%
    samiraTableVoronoi = {};
    missingVerticesCoord = [];
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

        verticesOfCell = double(unique(verticesOfCell, 'rows'));

        %Here we consider 3 methods to connect the vertices, and we choose
        %the method with more area into the polyshape.
        imaginaryCentroidMeanVert = mean(verticesOfCell);
        vectorForAngMean = bsxfun(@minus, verticesOfCell, imaginaryCentroidMeanVert );
        thMean = atan2(vectorForAngMean(:,2),vectorForAngMean(:,1));
        [~, angleOrderMean] = sort(thMean); 
        newVertOrderMean = verticesOfCell(angleOrderMean,:); 
        newVertOrderMean = [newVertOrderMean; newVertOrderMean(1,:)];
        
        centroidCell = cellCentroids(cellWithVertices{numCell,3},:);
        vectorForAngCent = bsxfun(@minus, verticesOfCell, centroidCell );
        thCent = atan2(vectorForAngCent(:,2),vectorForAngCent(:,1));
        [~, angleOrderCent] = sort(thCent); 
        newVertOrderCent = verticesOfCell(angleOrderCent,:); 
        newVertOrderCent = [newVertOrderCent; newVertOrderCent(1,:)];
        
        areaMeanCentroid = polyarea(newVertOrderMean(:,1),newVertOrderMean(:,2));
        areaCellCentroid = polyarea(newVertOrderCent(:,1),newVertOrderCent(:,2));
        
        userConfig = struct('xy',verticesOfCell, 'showProg',false,'showResult',false); 
        resultStruct = tspo_ga(userConfig);
        orderBoundary = [resultStruct.optRoute resultStruct.optRoute(1)];

        newVertSalesman = verticesOfCell(orderBoundary(1:end-1), :);
        newVertSalesman = [newVertSalesman; newVertSalesman(1,:)];
        areaVertSalesman = polyarea(newVertSalesman(:,1),newVertSalesman(:,2));

        if (areaVertSalesman >= areaMeanCentroid) && (areaVertSalesman >= areaCellCentroid)
            newVertOrder = newVertSalesman;
        else
            if areaMeanCentroid >= areaCellCentroid
                newVertOrder = newVertOrderMean;
            else
                newVertOrder = newVertOrderCent;
            end
        end

        % Should be connected clockwise
        % I.e. from bigger numbers to smaller ones
        % Or the second vertex should in the left hand of the first
        [newOrderX, newOrderY] = poly2cw(newVertOrder((1:end-1), 1), newVertOrder((1:end-1), 2));
        verticesRadius = [];
        
% %         figure;       
%         hold on
%         plot(newVertOrder(:, 1), newVertOrder(:, 2))
%         hold on
%         plot(verticesOfCell(:, 1), verticesOfCell(:, 2), 'r+');

        for numVertex = 1:length(newOrderX)
            verticesRadius(end+1) = newOrderX(numVertex);
            verticesRadius(end+1) = newOrderY(numVertex);
        end

        cellsVoronoi = [nSurfR, cellWithVertices{numCell, 3:5}, {verticesRadius}];
        samiraTableVoronoi = [samiraTableVoronoi; cellsVoronoi];
    end
    
    %Plot
    nameSplitted = strsplit(nameOfSimulation, '_');
    dir2save = strcat(strjoin(pathSplitted(1:end-2), '\'),'\verticesSamira\');
    mkdir(dir2save)
    plotVerticesPerSurfaceRatio(samiraTableVoronoi((end-numCell+1):end,:),missingVerticesCoord,dir2save,nameSplitted,'Natural',nSurfR)
end

