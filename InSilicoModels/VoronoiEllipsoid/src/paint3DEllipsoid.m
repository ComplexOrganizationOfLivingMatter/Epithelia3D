function [ ] = paint3DEllipsoid(centroids, img3DLabelled )
%PAINT3DELLIPSOID Summary of this function goes here
%   Detailed explanation goes here
    colours = colorcube(size(centroids, 1));
    colours = colours(randperm(size(centroids, 1)), :);
    figure;
    img3DLabelledPerim = uint16(bwperim(img3DLabelled)) .* img3DLabelled;
    disp('Building figure');
    for numSeed = 1:size(centroids, 1)
        numSeed
        % Painting each cell
        [x, y, z] = findND(img3DLabelledPerim == numSeed);
        cellFigure = alphaShape(x, y, z, 1000);
        plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
        hold on;
    end

    axis equal
    camlight left;
    camlight right;
    lighting flat
    material dull
    
    newFig = gca;
    newFig.XGrid = 'off';
    newFig.YGrid = 'off';
    newFig.ZGrid = 'off';
    set(get(0,'children'),'Color','w')
end

