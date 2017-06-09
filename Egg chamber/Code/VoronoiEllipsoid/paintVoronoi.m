function [ ] = paintVoronoi(x, y, z)
%PAINTVORONOI Summary of this function goes here
%   Detailed explanation goes here
    figure('Color','w') 
    plot3(x,y,z,'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none')
    X=[x y z];
    X(end+1, :) = [0 0 0];
    X(end+1, :) = [-0.3 0 0];
    X(end+1, :) = [-0.5 0 0];
    X(end+1, :) = [0.3 0 0];
    X(end+1, :) = [0.5 0 0];
    X(end+1, :) = [-0.0 0.5 0];
    X(end+1, :) = [-0.0 0.3 0];
    X(end+1, :) = [0.0 -0.3 0];
    X(end+1, :) = [0.0 -0.5 0];
    X(end+1, :) = [-0.0 0.0 -0.5];
    X(end+1, :) = [-0.0 0.0 -0.3];
    X(end+1, :) = [0.0 -0.0 0.3];
    X(end+1, :) = [0.0 -0.0 0.5];
    [V, C] = voronoin(X);
    T = delaunayn(X);
    tetramesh(T,X, 'FaceAlpha', 1);
%     paintRegion(x, y, z, z < 0 )
%     paintRegion(x, y, z,  x < 0 & z >= 0)
%     paintRegion(x, y, z,  x >= 0 & z < 0 )
%     paintRegion(x, y, z,  x >= 0 & z >= 0)
    zlabel('z');
    ylabel('y');
    xlabel('x');
    [V,C]=voronoin(X, {'Q1'});
    V;
    for k=1:length(C)
        disp(C{k})
    end
    for k=1:length(C)
        if all(C{k}~=1)
            VertCell = V(C{k},:);
            KVert = convhulln(VertCell);
            patch('Vertices',VertCell,'Faces',KVert,'FaceColor','g','FaceAlpha',0.5)
        end
    end
end

