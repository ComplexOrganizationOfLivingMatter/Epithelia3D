function [ ] = paintVoronoi(x, y, z)
%PAINTVORONOI Summary of this function goes here
%   Detailed explanation goes here
    figure('Color','w') 
    plot3(x,y,z,'Marker','.','MarkerEdgeColor','r','MarkerSize',10, 'LineStyle', 'none')
    X=[x y z];
    [V,C]=voronoin(X);
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

