function [ ellipsoidInfo ] = refineVerticesOfVoronoi( ellipsoidInfo )
%REFINEVERTICESOFVORONOI Summary of this function goes here
%   Detailed explanation goes here

    xs = cellfun(@(x) x(:, 1), ellipsoidInfo.verticesPerCell, 'UniformOutput', false);
    ys = cellfun(@(x) x(:, 2), ellipsoidInfo.verticesPerCell, 'UniformOutput', false);
    zs = cellfun(@(x) x(:, 3), ellipsoidInfo.verticesPerCell, 'UniformOutput', false);
    allTheVertices = [vertcat(xs{:}), vertcat(ys{:}), vertcat(zs{:})];
    uniqueVertices = unique(allTheVertices, 'rows');
    %goodVertices = zeros(size(uniqueVertices, 1), 1);
    cellsUnifyedPerVertex = cell(size(uniqueVertices, 1), 1);
    for vertexIndex = 1:size(uniqueVertices, 1)
        %goodVertices(vertexIndex) = sum(cellfun(@(x) ismember(uniqueVertices(vertexIndex, :), x, 'rows'), ellipsoidInfo.verticesPerCell)) > 2;
        cellsUnifyedPerVertex(vertexIndex) = {find(cellfun(@(x) ismember(uniqueVertices(vertexIndex, :), x, 'rows'), ellipsoidInfo.verticesPerCell))};
    end

    totalNumberOfUniqueVertices = size(uniqueVertices, 1);
    refinedVertices = uniqueVertices;
    numberOfVertex = 1;
    while numberOfVertex <= totalNumberOfUniqueVertices
        sequenceToSearch = 1:totalNumberOfUniqueVertices;
        sequenceToSearch(numberOfVertex == sequenceToSearch) = [];
        if (any(cellfun(@(x) all(ismember(cellsUnifyedPerVertex{numberOfVertex}, x)) & size(cellsUnifyedPerVertex{numberOfVertex},1) < size(x, 1), cellsUnifyedPerVertex(sequenceToSearch))));
            cellsUnifyedPerVertex(numberOfVertex) = [];
            refinedVertices(numberOfVertex, :) = [];
            numberOfVertex = numberOfVertex - 1;
            totalNumberOfUniqueVertices = totalNumberOfUniqueVertices - 1;
        end
        numberOfVertex = numberOfVertex + 1;
    end
    
    ellipsoidInfo.vertices = refinedVertices;
    ellipsoidInfo.verticesConnectCells = cellsUnifyedPerVertex;
    ellipsoidInfo.verticesPerCell = cellfun(@(x) x(ismember(x, refinedVertices, 'rows'), :), ellipsoidInfo.verticesPerCell, 'UniformOutput', false);
    figure('Visible', 'off');
    clmap = colorcube();
    ncl = size(clmap,1);

    for cellIndex = 1:size(ellipsoidInfo.verticesPerCell, 1)
        cl = clmap(mod(cellIndex,ncl)+1,:);
        VertCell = ellipsoidInfo.verticesPerCell{cellIndex};
        KVert = convhulln([VertCell; ellipsoidInfo.finalCentroids(cellIndex, :)]);
        patch('Vertices',[VertCell; ellipsoidInfo.finalCentroids(cellIndex, :)],'Faces', KVert,'FaceColor', cl ,'FaceAlpha', 1, 'EdgeColor', 'none')
        hold on;
    end
    axis equal
end

