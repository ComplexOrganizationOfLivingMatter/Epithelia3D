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
        HCylinder = 320;
        HImg = 1024;
        %744 is the diameter of the gland
        % 
        diameterOfGland = 844;
        lengthInImage = pi * diameterOfGland;

        
        
        z = pxCell(:, 3) + (70 - 4 - 28);
        y = pxCell(:, 2);
        x = pxCell(:, 1) - mean([max(maxMins), min(maxMins)]);

        z = diameterOfGland .* z ./ 70;
        uniqueZs = unique(z);
        hError = uniqueZs(2) - uniqueZs(1);
        
        xMax = max(maxMins - mean([max(maxMins), min(maxMins)]));
        
        [XY, radiusOfCircle] = points2Circle([0 hError], [-xMax 0], [xMax 0]);
        
        %perimeterOfCircle = 2*pi * radiusOfCircle;
        anglesHError = atan(x ./ radiusOfCircle);
        zReal = z .* cos(anglesHError);
        
        %zReal = cylRadius .* cos(x *(2*pi / lengthInImage));
        %xReal = cylRadius .* sin(x *(2*pi / lengthInImage));
        xReal = x * (HCylinder/HImg);
        yReal = y * (HCylinder/HImg);
        
        k = boundary([xReal yReal zReal], 0);
        trisurf(k, xReal, yReal, zReal, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
        hold on;
    end
    camlight left;
    camlight right;
    lighting flat
end

