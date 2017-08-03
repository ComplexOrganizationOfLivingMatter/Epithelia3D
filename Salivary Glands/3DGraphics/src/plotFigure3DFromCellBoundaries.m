function [ ] = plotFigure3DFromCellBoundaries( pixelsPerCell, colours)
%PLOTFIGURE3DFROMCELLBOUNDARIES Summary of this function goes here
%   Detailed explanation goes here
    figure;
    
    maxMins = cellfun(@(x) horzcat(max(x(:, 1)), min(x(:, 1))), pixelsPerCell, 'UniformOutput', false);
    maxMins = horzcat(maxMins{:});
    %pxFirstLayer = pxCell(pxCell(:, 3) == max(pxCell(:, 3)), 1);
    
    for numCell = 1:length(pixelsPerCell)
        numCell
        pxCell = pixelsPerCell{numCell};
        
        %% Transform plane points to cylindrical points
        %Let say you have a rectangle image of lenght: lengthInImage and height: HImg
        %and a cylinder of radius : cylRadius and height HCylinder
        %Let A (x,y) be a point in the picture,
        % Taken from: 
        % https://stackoverflow.com/questions/7981815/projection-of-a-plane-onto-a-cylinder
        HCylinder = 100;
        HImg = 1024;
        lengthInImage = 2*pi* 346 / (28/70);

        
        
        z = pxCell(:, 3);
        y = pxCell(:, 2);
        x = pxCell(:, 1) - mean([max(maxMins), min(maxMins)]);

        cylRadius = z + 5 + 35;

        zReal = cylRadius .* cos(x *(2*pi / lengthInImage));
        xReal = cylRadius .* sin(x *(2*pi / lengthInImage));
        
        yReal = y * (HCylinder/HImg);
        
        k = boundary([xReal yReal zReal], 0);
        trisurf(k, xReal, yReal, zReal, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.5, 'FaceAlpha', 0.8);
        hold on;
    end
    camlight left;
    camlight right;
    lighting flat
end

