function [ ] = paint3DEllipsoid(centroids, img3DLabelled )
%PAINT3DELLIPSOID Summary of this function goes here
%   Detailed explanation goes here
    colours = colorcube(size(centroids, 1));
    figure;
    %img3DLabelledPerim = uint16(bwperim(img3DLabelled)) .* img3DLabelled;
    disp('Building figure');
    for numSeed = 1:size(centroids, 1)
        % Painting each cell
        [x, y, z] = findND(img3DLabelled == numSeed);
        cellFigure = alphaShape(x, y, z, 10);
        plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
        hold on;
    end

end

