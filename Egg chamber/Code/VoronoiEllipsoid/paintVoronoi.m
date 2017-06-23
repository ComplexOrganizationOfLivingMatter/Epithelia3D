function [ verticesPerCell,verticesPerCellBefore ] = paintVoronoi(x, y, z, xRadius, yRadius, zRadius)
%PAINTVORONOI Summary of this function goes here
%   Detailed explanation goes here
    %figure('Color','w') 
    %plot3(x,y,z,'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none')
    try
        XInitial=[x y z];
        Y = XInitial * 0.9;
        X = [XInitial*1.1; Y];

    %     [xEllipsoid, yEllipsoid, zEllipsoid] = ellipsoid(0, 0, 0, xRadius, yRadius, zRadius, 1000);
    %     pointsInEllipsoid = [xEllipsoid(:), yEllipsoid(:), zEllipsoid(:)];

        %figure('Visible', 'off');
        [V,C]=voronoin(X);
        %T = delaunayn([XInitial; [0 0 0]]);
        %tetramesh(T,X);
        clmap = colorcube();
        ncl = size(clmap,1);
        verticesPerCell = cell(length(Y), 1);
        verticesPerCellBefore = cell(length(Y), 1);

        for k=1:length(Y)
            cl = clmap(mod(k,ncl)+1,:);
            sides = C{k};
            VertCell = V(sides(sides~=1),:);
            verticesPerCellBefore(k, 1) = {VertCell};
            indicesOutsideEllipsoid = (VertCell(:, 1).^2 / xRadius^2) + (VertCell(:, 2).^ 2 / yRadius^2) + (VertCell(:, 3).^2 / zRadius^2);
            VertCellOutlayers=VertCell (indicesOutsideEllipsoid < 0.7 | indicesOutsideEllipsoid > 1.3, :);
            VertCell (indicesOutsideEllipsoid < 0.7 | indicesOutsideEllipsoid > 1.3, :) = [];

            indicesOutsideEllipsoid = (VertCell(:, 1).^2 / xRadius^2) + (VertCell(:, 2).^ 2 / yRadius^2) + (VertCell(:, 3).^2 / zRadius^2);

            upSide = xRadius^2 * yRadius^2 * zRadius^2;
            format long
            downSide = (yRadius^2 * zRadius^2 * VertCell(indicesOutsideEllipsoid > 1, 1).^2) + (xRadius^2 * zRadius^2 * VertCell(indicesOutsideEllipsoid > 1, 2).^2) + (yRadius^2 * xRadius^2 * VertCell(indicesOutsideEllipsoid > 1, 3).^2);
            downSideOutLayers=(yRadius^2 * zRadius^2 * VertCellOutlayers(:, 1).^2) + (xRadius^2 * zRadius^2 * VertCellOutlayers(:, 2).^2) + (yRadius^2 * xRadius^2 * VertCellOutlayers(:, 3).^2);
            conversorFactor = sqrt(upSide./downSide);
            conversorFactorOutLayers=sqrt(upSide./downSideOutLayers);
            VertCell(indicesOutsideEllipsoid > 1, :) = arrayfun(@(x, y) x * y, VertCell(indicesOutsideEllipsoid > 1, :), repmat(conversorFactor, 1, 3));
            VertCellOutlayers(:, :) = arrayfun(@(x, y) x * y, VertCellOutlayers, repmat(conversorFactorOutLayers, 1, 3));

            %         indicesOutsideEllipsoid = (VertCell(:, 1).^2 / xRadius^2) + (VertCell(:, 2).^ 2 / yRadius^2) + (VertCell(:, 3).^2 / zRadius^2);
    %         slightlyBadVertices = indicesOutsideEllipsoid < 0.99 | indicesOutsideEllipsoid > 1.01;
    %         if any(slightlyBadVertices) 
    %             numBadInd = find(slightlyBadVertices);
    %             %VertCell(indicesOutsideEllipsoid < 0.95 | indicesOutsideEllipsoid > 1.05, :) = replaceVerticesOutsideForEllipsoidPoints(VertCell(indicesOutsideEllipsoid < 0.9 | indicesOutsideEllipsoid > 1.1, :) , pointsInEllipsoid);
    %             for numBad = 1:length(numBadInd)
    %                 %distMat = mean(pdist2([0 0 0; VertCell(numBadInd(numBad), :)], pointsInEllipsoid), 1);
    %                 %[~, index] = min(distMat);
    %                 %VertCell(numBadInd(numBad), :) = pointsInEllipsoid(index, :);
    %                 %VertCell(numBadInd(numBad), :) = sqrt(VertCell(numBadInd(numBad), :).^2 / indicesOutsideEllipsoid(numBadInd(numBad))) .* sign(VertCell(numBadInd(numBad), :));
    %             end
    %         end

            VertCell = [VertCell; XInitial(k, :)];
            %VertCell = VertCell(ismember(VertCell, Y, 'rows') == 0, :);
            KVert = convhulln(VertCell, {'QJ'});
            %KVert = KVert(sum(KVert ~= (size(VertCell, 1)), 2) == 3, :);
            %patch('Vertices',VertCell,'Faces', KVert,'FaceColor', cl ,'FaceAlpha', 1, 'EdgeColor', 'none')
            verticesPerCell(k, 1) = {VertCell(1:end-1, :)};
            verticesPerCellBefore(k,1)={VertCellOutlayers(:, :)};
            %hold on;
        end
        %axis equal
    catch mexception
        rethrow(mexception)
    end
end

