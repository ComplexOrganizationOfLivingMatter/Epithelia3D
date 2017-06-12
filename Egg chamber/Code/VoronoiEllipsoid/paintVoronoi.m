function [ verticesPerCell ] = paintVoronoi(x, y, z, xRadius, yRadius, zRadius)
%PAINTVORONOI Summary of this function goes here
%   Detailed explanation goes here
    %figure('Color','w') 
    %plot3(x,y,z,'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none')
    XInitial=[x y z];
    Y = XInitial * 0.9;
    X = [XInitial*1.1; Y];
    
    [xEllipsoid, yEllipsoid, zEllipsoid] = ellipsoid(0, 0, 0, xRadius, yRadius, zRadius, 300);
    pointsInEllipsoid = [xEllipsoid(:), yEllipsoid(:), zEllipsoid(:)];
    
    figure;
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
        VertCell (indicesOutsideEllipsoid < 0.85 | indicesOutsideEllipsoid > 1.15, :) = [];
        indicesOutsideEllipsoid = (VertCell(:, 1).^2 / xRadius^2) + (VertCell(:, 2).^ 2 / yRadius^2) + (VertCell(:, 3).^2 / zRadius^2);
        slightlyBadVertices = indicesOutsideEllipsoid < 0.95 | indicesOutsideEllipsoid > 1.05;
        if any(slightlyBadVertices) 
            numBadInd = find(slightlyBadVertices);
            %VertCell(indicesOutsideEllipsoid < 0.95 | indicesOutsideEllipsoid > 1.05, :) = replaceVerticesOutsideForEllipsoidPoints(VertCell(indicesOutsideEllipsoid < 0.9 | indicesOutsideEllipsoid > 1.1, :) , pointsInEllipsoid);
            for numBad = 1:length(numBadInd)
                VertCell(numBadInd(numBad), :) = sqrt(VertCell(numBadInd(numBad), :).^2 / indicesOutsideEllipsoid(numBadInd(numBad))) .* sign(VertCell(numBadInd(numBad), :));
            end
        end
        VertCell = [VertCell; 0, 0, 0];
        %VertCell = VertCell(ismember(VertCell, Y, 'rows') == 0, :);
        KVert = convhulln(VertCell);
        %KVert = KVert(sum(KVert ~= (size(VertCell, 1)), 2) == 3, :);
        patch('Vertices',VertCell,'Faces', KVert,'FaceColor', cl ,'FaceAlpha', 1, 'EdgeColor', 'none')
        verticesPerCell(k, 1) = {VertCell(1:end-1, :)};
        hold on;
    end    
end

