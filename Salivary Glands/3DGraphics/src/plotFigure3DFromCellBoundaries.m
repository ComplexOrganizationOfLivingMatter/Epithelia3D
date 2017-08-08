function [ ] = plotFigure3DFromCellBoundaries( pixelsPerCell, colours)
%PLOTFIGURE3DFROMCELLBOUNDARIES Summary of this function goes here
%   Detailed explanation goes here

    uiopen('D:\Pablo\Epithelia3D\Salivary Glands\3DGraphics\motifTransition_Curved_03_08_2017.fig',1);
    refFig = gca;
    figure;
    
    diameterOfGland = 844;
    HCylinder = 320;
    HImg = 1024;
    stackSize = 70;
    
    pxFirstCell = pixelsPerCell{1};
    
    z = pxFirstCell(:, 3) + (stackSize - 4 - 28);
    z = diameterOfGland .* z ./ stackSize;
    uniqueZs = unique(z);
    hError = uniqueZs(2) - uniqueZs(1);
    
    maxLayer = max(pxFirstCell(:, 3));
    minLayer = min(pxFirstCell(:, 3));
    radiusOfCirclePerLayer = zeros(maxLayer - minLayer, 1);
    for numLayer = minLayer:maxLayer
        maxMins = cellfun(@(x) horzcat(max(x( x(:, 3) == numLayer, 1)), min(x(x(:, 3) == numLayer, 1))), pixelsPerCell, 'UniformOutput', false);
        maxMins = horzcat(maxMins{:});
        xMax = max(maxMins - mean([max(maxMins), min(maxMins)]));
        
        [~, radiusOfCircle] = points2Circle([0 hError], [-xMax 0], [xMax 0]);
        radiusOfCirclePerLayer(numLayer + 1) = radiusOfCircle;
    end
    
    
    maxMins = cellfun(@(x) horzcat(max(x(:, 1)), min(x(:, 1))), pixelsPerCell, 'UniformOutput', false);
    maxMins = horzcat(maxMins{:});
    for numCell = 1:length(pixelsPerCell)
        numCell
        pxCell = pixelsPerCell{numCell};
        
        %% Transform plane points to cylindrical points
        %Let say you have a rectangle image of lenght: lengthInImage and height: HImg
        %and a cylinder of radius : cylRadius and height HCylinder
        %Let A (x,y) be a point in the picture,
        % Taken from: 
        % https://stackoverflow.com/questions/7981815/projection-of-a-plane-onto-a-cylinder
        
        z = pxCell(:, 3) + (70 - 4 - 28);
        z = diameterOfGland .* z ./ stackSize;
        y = pxCell(:, 2);
        x = pxCell(:, 1) - mean([max(maxMins), min(maxMins)]);
        
        zReal = zeros(size(z));
        for numLayer = 1:size(uniqueZs, 1)
            filterByLayer = z == uniqueZs(numLayer);
            radiusOfCircle = radiusOfCirclePerLayer(numLayer);
            
            anglesHError = cos(x(filterByLayer) ./ radiusOfCircle);
            zReal(filterByLayer, 1) = z(filterByLayer) - (radiusOfCircle - radiusOfCircle .* anglesHError);
        end
        
        xReal = x;
        yReal = y;
        
        k = boundary([xReal yReal zReal], 0);
        trisurf(k, xReal, yReal, zReal, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
        hold on;
    end
    axis equal
    camlight left;
    camlight right;
    lighting flat
    
    newFig = gca;
    newFig.CameraPositionMode = 'manual';
    newFig.CameraTargetMode = 'manual';
    newFig.CameraUpVectorMode = 'manual';
    newFig.CameraViewAngleMode = 'manual';
    
    %newFig.CameraPosition = refFig.CameraPosition;
    newFig.CameraUpVector = refFig.CameraUpVector;
    newFig.CameraViewAngle = refFig.CameraViewAngle;
    
    newFig.Visible = 'off';
    set(get(0,'children'),'Color','w')
    print(strcat('../motif_3DCells_4_', date), '-dtiff', '-r600');
end

