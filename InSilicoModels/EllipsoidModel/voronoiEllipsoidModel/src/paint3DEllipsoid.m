function [ ] = paint3DEllipsoid(ellipsoidInfo, img3DLabelled )
%PAINT3DELLIPSOID Summary of this function goes here
%   Detailed explanation goes here
    centroids = ellipsoidInfo.centroids;
    colours = colorcube(size(centroids, 1));
    colours = colours(randperm(size(centroids, 1)), :);
    figure;
    img3DLabelledPerim = uint16(bwperim(img3DLabelled)) .* img3DLabelled;
    disp('Building figure');
    for numSeed = 1:size(centroids, 1)
        numSeed
        % Painting each cell
        [x, y, z] = findND(img3DLabelledPerim == numSeed);
        cellFigure = alphaShape(x, y, z, 500);
        plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
        hold on;
        [x, y, z] = findND(ellipsoidInfo.img3DLayer == numSeed);
        cellFigure = alphaShape(x, y, z, 500);
        plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
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

