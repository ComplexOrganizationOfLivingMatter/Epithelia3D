function [ ellipsoidInfo ] = refineVerticesOfVoronoi( ellipsoidInfo )
%REFINEVERTICESOFVORONOI Summary of this function goes here
%   Detailed explanation goes here

    xs = cellfun(@(x) x(:, 1), ellipsoidInfo.verticesPerCell, 'UniformOutput', false);
    ys = cellfun(@(x) x(:, 2), ellipsoidInfo.verticesPerCell, 'UniformOutput', false);
    zs = cellfun(@(x) x(:, 3), ellipsoidInfo.verticesPerCell, 'UniformOutput', false);
    xsOutLayers = cellfun(@(x) x(:, 1), ellipsoidInfo.verticesPerCellOutlayers, 'UniformOutput', false);
    ysOutLayers  = cellfun(@(x) x(:, 2), ellipsoidInfo.verticesPerCellOutlayers, 'UniformOutput', false);
    zsOutLayers  = cellfun(@(x) x(:, 3), ellipsoidInfo.verticesPerCellOutlayers, 'UniformOutput', false);
    
    allTheVertices = [vertcat(xs{:}), vertcat(ys{:}), vertcat(zs{:})];
    allTheVerticesWithOutLayers = [vertcat(xsOutLayers{:}), vertcat(ysOutLayers{:}), vertcat(zsOutLayers{:})];
    uniqueVertices = unique(allTheVertices, 'rows');
    uniqueVerticesWithOutLayers = unique(allTheVerticesWithOutLayers, 'rows');
    %goodVertices = zeros(size(uniqueVertices, 1), 1);
    cellsUnifiedPerVertex = cell(size(uniqueVertices, 1), 1);
    cellsUnifiedPerVertexOutlayers = cell(size(uniqueVerticesWithOutLayers, 1), 1);

    for vertexIndex = 1:size(uniqueVertices, 1)
        %goodVertices(vertexIndex) = sum(cellfun(@(x) ismember(uniqueVertices(vertexIndex, :), x, 'rows'), ellipsoidInfo.verticesPerCell)) > 2;
        cellsUnifiedPerVertex(vertexIndex) = {find(cellfun(@(x) ismember(uniqueVertices(vertexIndex, :), x, 'rows'), ellipsoidInfo.verticesPerCell))};
    end
    
    for vertexIndex = 1:size(uniqueVerticesWithOutLayers, 1)
        cellsUnifiedPerVertexOutlayers(vertexIndex) = {find(cellfun(@(x) ismember(uniqueVerticesWithOutLayers(vertexIndex, :), x, 'rows'), ellipsoidInfo.verticesPerCellOutlayers))};
    end

    %totalNumberOfUniqueVertices = size(uniqueVertices, 1);
    %refinedVertices = uniqueVertices;
    %numberOfVertex = 1;
    refinedVertices = uniqueVertices(cellfun(@(x) size(x, 1) > 2, cellsUnifiedPerVertex), :);
    removedVertices = uniqueVertices(cellfun(@(x) size(x, 1) <= 2, cellsUnifiedPerVertex), :);

    cellsUnifiedPerVertex=cellsUnifiedPerVertex(cellfun(@(x) size(x, 1) > 2, cellsUnifiedPerVertex));

    %%ES UNA GUARRADA LO SÉ. PERO HABIA VERTICES DE 3 VECINOS QUE SOLAPABAN
    %%CON VERTICES DE 4 Y NO SE BORRABAN, Y me lio usando los putos cellfun
    crossheadCellsUnifiedPerVertices=cellsUnifiedPerVertex(cellfun(@(x) size(x, 1) > 3, cellsUnifiedPerVertex), :);
    vertexToRefine=[];
    for cellIndexCrossHead=1:size(crossheadCellsUnifiedPerVertices,1)
        crossheadCellVertices=crossheadCellsUnifiedPerVertices{cellIndexCrossHead};
        for cellIndex=1:size(cellsUnifiedPerVertex)
            if (sum(ismember(crossheadCellVertices,cellsUnifiedPerVertex{cellIndex}))==length(cellsUnifiedPerVertex{cellIndex})) && (length(cellsUnifiedPerVertex{cellIndex})<length(crossheadCellVertices))
                vertexToRefine(end+1)=cellIndex; %#ok<AGROW>
            end
        end
    end
    removedVertices = [removedVertices;refinedVertices(vertexToRefine,:)];
    refinedVertices(vertexToRefine,:)=[];
    cellsUnifiedPerVertex(vertexToRefine,:)=[];
    
    refinedVerticesOutlayers = uniqueVerticesWithOutLayers(cellfun(@(x) size(x, 1) > 2, cellsUnifiedPerVertexOutlayers), :);
    removedVerticesOutlayers = uniqueVertices(cellfun(@(x) size(x, 1) <= 2, cellsUnifiedPerVertexOutlayers), :);

    %removedVertices = zeros(1, 3);
    
%     while numberOfVertex <= totalNumberOfUniqueVertices
%         sequenceToSearch = 1:totalNumberOfUniqueVertices;
%         sequenceToSearch(numberOfVertex == sequenceToSearch) = [];
%         actualRefinedVertices = refinedVertices(sequenceToSearch, :);
%         convergingCells = cellfun(@(x) all(ismember(cellsUnifiedPerVertex{numberOfVertex}, x)), cellsUnifiedPerVertex(sequenceToSearch));
%         if (any(convergingCells))
%             cellsUnifiedPerVertex(numberOfVertex) = [];
%             removedVertices(end+1, :) = actualRefinedVertices(numberOfVertex, :);
%             indicesOfConvergentCells = find(convergingCells);
%             
%             %Substitute vertex for the one that converget it
%             for i = 1:size(ellipsoidInfo.verticesPerCell, 1)
%                 actualVerticesPerCell = ellipsoidInfo.verticesPerCell{i};
%                 foundVerticesToSubstitute = ismember(actualVerticesPerCell, actualRefinedVertices(numberOfVertex, :), 'rows');
%                 if any(foundVerticesToSubstitute)
%                     actualVerticesPerCell(foundVerticesToSubstitute, :) = [];
%                     actualVerticesPerCell(end+1, :) = actualRefinedVertices(indicesOfConvergentCells(1), :);
%                     ellipsoidInfo.verticesPerCell{i} = actualVerticesPerCell;
%                 end
%             end
%             refinedVertices(numberOfVertex, :) = [];
%             numberOfVertex = numberOfVertex - 1;
%             totalNumberOfUniqueVertices = totalNumberOfUniqueVertices - 1;
%         end
%         numberOfVertex = numberOfVertex + 1;
%     end
    %Removing the first item 0 0 0
    %removedVertices (1, :) = [];
    
    ellipsoidInfo.removedVertices = removedVertices;
    ellipsoidInfo.vertices = refinedVertices;
    ellipsoidInfo.removedVerticesOutlayers = removedVerticesOutlayers;
    ellipsoidInfo.verticesOutlayers = refinedVerticesOutlayers;
    
    ellipsoidInfo.verticesConnectCells = cellsUnifiedPerVertex;
    ellipsoidInfo.verticesPerCell = cellfun(@(x) unique(x(ismember(x, refinedVertices, 'rows'), :), 'rows'), ellipsoidInfo.verticesPerCell, 'UniformOutput', false);
    figure('Visible', 'off');
%     clmap = colorcube();


    ncl = size(clmap,1);

    try 
        for cellIndexCrossHead = 1:size(ellipsoidInfo.verticesPerCell, 1)
            cl = clmap(mod(cellIndexCrossHead,ncl)+1,:);
            VertCell = ellipsoidInfo.verticesPerCell{cellIndexCrossHead};
            KVert = convhulln([VertCell; ellipsoidInfo.finalCentroids(cellIndexCrossHead, :)]);
            patch('Vertices',[VertCell; ellipsoidInfo.finalCentroids(cellIndexCrossHead, :)],'Faces', KVert,'FaceColor', cl ,'FaceAlpha', 1, 'EdgeColor', 'none')
            hold on;
        end
%         plot3(removedVertices(:, 1), removedVertices(:, 2), removedVertices(:, 3),'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none')
        axis equal
    catch mexception
        rethrow(mexception);
    end
end

