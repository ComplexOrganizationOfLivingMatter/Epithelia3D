function [ ] = plotFigure3DFromCellBoundaries( pixelsPerCell, colours)
%PLOTFIGURE3DFROMCELLBOUNDARIES Summary of this function goes here
%   Detailed explanation goes here
    figure;
    for numCell = 1:length(pixelsPerCell)
        numCell
        pxCell = pixelsPerCell{numCell};
        
        %% Transform plane points to cylindrical points
        %Let say you have a rectangle image of lenght: lengthInImage and height: HImg
        %and a cylinder of radius : cylRadius and height HCylinder
        %Let A (x,y) be a point in the picture,
        % Taken from: 
        % https://stackoverflow.com/questions/7981815/projection-of-a-plane-onto-a-cylinder
        HCylinder = 1;
        HImg = 1;
        lengthInImage = 2*pi*(266/2);

        z = pxCell(:, 3);
        y = pxCell(:, 2);
        x = pxCell(:, 1) - max(pxCell(:, 1)) + min(pxCell(:, 1));

        cylRadius = z;

        zReal = cylRadius .* cos(x*(2*pi/lengthInImage));
        xReal = cylRadius .* sin(x*(2*pi/lengthInImage));
        yReal = y * (HCylinder/HImg);
        
        k = boundary([xReal yReal zReal], 0);
        trisurf(k, xReal, yReal, zReal, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.5, 'FaceAlpha', 0.8);
        hold on;
    end
    camlight left;
    camlight right;
    lighting flat
end

