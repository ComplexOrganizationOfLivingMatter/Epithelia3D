function [samiraTableVoronoi, cellsVoronoi] = tableWithSamiraFormat(cellWithVertices, missingVertices, nSurfR, pathSplitted, nameOfSimulation)
%TABLEWITHSAMIRAFORMAT Summary of this function goes here
%   Detailed explanation goes here
%
    samiraTableVoronoi = {};

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
        counter = 0.05;
        while length(orderBoundary)-1 < size(verticesOfCell, 1) && counter < 0.9
            orderBoundary = boundary(verticesOfCell(:, 1), verticesOfCell(:, 2), 0.1+counter);
            counter = counter + 0.5;
        end

        missingVerticesActual = [];
        if length(orderBoundary)-1 ~= size(verticesOfCell, 1)
            disp(strcat('Warning: cell number', num2str(cellWithVertices{numCell, 3}), ' may be wrongly done'));
            disp('Correcting...')
            missingVerticesActual = setdiff(1:size(verticesOfCell, 1), orderBoundary);
            missingVerticesCoord = [missingVerticesCoord;verticesOfCell(missingVerticesActual,:)];
        end

        % Should be connected clockwise
        % I.e. from bigger numbers to smaller ones
        % Or the second vertex should in the left hand of the first
        [newOrderX, newOrderY] = poly2cw(verticesOfCell(orderBoundary(1:end-1), 1), verticesOfCell(orderBoundary(1:end-1), 2));
        verticesRadius = [];

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
    plotVerticesPerSurfaceRatio(samiraTableVoronoi((end-numCell+1):end,:),missingVerticesCoord,dir2save,nameSplitted,'Voronoi',nSurfR)
end

