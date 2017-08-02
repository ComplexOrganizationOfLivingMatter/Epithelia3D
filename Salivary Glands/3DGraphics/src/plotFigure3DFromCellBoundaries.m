function [ ] = plotFigure3DFromCellBoundaries( pixelsPerCell, colours)
%PLOTFIGURE3DFROMCELLBOUNDARIES Summary of this function goes here
%   Detailed explanation goes here
    figure;
    for numCell = 1:length(pixelsPerCell)
        numCell
        pxCell = pixelsPerCell{numCell};
        k = boundary(pxCell, 0);
        trisurf(k,pxCell(:, 1), pxCell(:, 2), pxCell(:, 3), 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.5, 'FaceAlpha', 0.8);
        hold on;
    end
    camlight left;
    camlight right;
    lighting flat
end

