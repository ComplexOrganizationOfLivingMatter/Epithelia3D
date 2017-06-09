function [ ] = paintVoronoi(x, y, z, xRadius, yRadius, zRadius)
%PAINTVORONOI Summary of this function goes here
%   Detailed explanation goes here
    %figure('Color','w') 
    %plot3(x,y,z,'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none')
    X=[x y z];
    Y = X * 0.8;
    X = [X; Y];
%     X(end+1, :) = [0 0 0];
%     X(end+1, :) = [-0.3 0 0];
%     X(end+1, :) = [-0.5 0 0];
%     X(end+1, :) = [0.3 0 0];
%     X(end+1, :) = [0.5 0 0];
%     X(end+1, :) = [-0.0 0.5 0];
%     X(end+1, :) = [-0.0 0.3 0];
%     X(end+1, :) = [0.0 -0.3 0];
%     X(end+1, :) = [0.0 -0.5 0];
%     X(end+1, :) = [-0.0 0.0 -0.5];
%     X(end+1, :) = [-0.0 0.0 -0.3];
%     X(end+1, :) = [0.0 -0.0 0.3];
%     X(end+1, :) = [0.0 -0.0 0.5];
    %[V, C] = voronoin(X);
    %T = delaunayn(X);
    %tetramesh(T,X, 'FaceAlpha', 1);
%     paintRegion(x, y, z, z < 0 )
%     paintRegion(x, y, z,  x < 0 & z >= 0)
%     paintRegion(x, y, z,  x >= 0 & z < 0 )
%     paintRegion(x, y, z,  x >= 0 & z >= 0)
    %zlabel('z');
    %ylabel('y');
    %xlabel('x');
    figure;
    [V,C]=voronoin(X);
    clmap = colorcube();
    ncl = size(clmap,1);
    verticesPerCell = cell(length(Y), 1);
    for k=1:length(Y)
        cl = clmap(mod(k,ncl)+1,:);
        sides = C{k};
        VertCell = V(sides(sides~=1),:);
        indicesOutsideEllipsoid = ((VertCell(:, 1).^2 / xRadius^2) + (VertCell(:, 2).^ 2 / yRadius^2) + (VertCell(:, 3).^2 / zRadius^2)) > 1;
        VertCell (indicesOutsideEllipsoid, :) = [];
        VertCell = [VertCell; 0, 0, 0];
        %VertCell = VertCell(ismember(VertCell, Y, 'rows') == 0, :);
        KVert = convhulln(VertCell);
        %KVert = KVert(sum(KVert ~= (size(VertCell, 1)), 2) == 3, :);
        patch('Vertices',VertCell,'Faces', KVert,'FaceColor', cl ,'FaceAlpha',1, 'EdgeColor', 'none')
        verticesPerCell(k, 1) = {VertCell};
        hold on;
    end
    verticesPerCell
end

