function [ ] = create3DMotifFromVoronoi( )
%CREATE3DMOTIFFROMVORONOI Summary of this function goes here
%   Detailed explanation goes here
    load('D:\Pablo\Epithelia3D\Salivary Glands\Curvature model\data\Image_10.mat')
    
    %selectedCells = 1:max(listLOriginalProjection.L_originalProjection{1});
    %Yellow, Red, Green, Blue
    selectedCells = [9, 40, 48, 39];
    addedCells = [8, 15, 27, 20, 30];
    selectedCells = horzcat(selectedCells, addedCells);
    %% Rb/Ra = 2.5
    pixelsPerCell = {};
    maxPlanes = 7;
    for selectedCell = 1:size(selectedCells, 2)
        for numPlane = 1:maxPlanes
            actualPlaneImg = cell2mat(listLOriginalProjection.L_originalProjection(numPlane));
            
            [imgRows,imgCols] = size(actualPlaneImg);
            [X,Y,~] = cylinder(imgRows, imgCols);
            X=X*0.2*listLOriginalProjection.surfaceRatio(numPlane);
            Y=Y*0.2*listLOriginalProjection.surfaceRatio(numPlane);
%             hRef = warp(X,Y,Z,actualPlaneImg);
            
            [actualCellPxX, actualCellPxY] = find(actualPlaneImg == selectedCells(selectedCell));
            
            actualCellPxX = actualCellPxX';
            actualCellPxZ = X(1, actualCellPxY);
            actualCellPxY = Y(1, actualCellPxY);
            
            actualCellPxs = vertcat(actualCellPxX, actualCellPxY, actualCellPxZ);
            
            %actualCellBoundary = boundary(actualCellPxX', actualCellPxY', actualCellPxZ', 0);
            boundaryPxs = actualCellPxs';
            if numPlane == 1
                pixelsPerCell{selectedCell} = boundaryPxs;
            else
                pixelsPerCell{selectedCell} = vertcat(pixelsPerCell{selectedCell}, boundaryPxs);
            end
        end
        pixelsPerCell;
    end
    
    %Yellow, Red, Green, Blue
    colours = [255 255 51;  255 0 0; 102 153 51; 102 153 255] / 255;
    %colours = colorcube(50);
%    plotFigure3DFromCellBoundaries(pixelsPerCell, colours);
    figure;
    for numCell = 1:size(selectedCells, 2);
        actualCellPxs = pixelsPerCell{numCell};
        xCell = actualCellPxs(:, 1);
        yCell = actualCellPxs(:, 2);
        zCell = actualCellPxs(:, 3);
        actualCellPxs = [xCell, yCell, zCell];
        %k = boundary(actualCellPxs, 0);
        shp = alphaShape(xCell, yCell, zCell);
        shp.Alpha = 100;
        if numCell > 4
            plot(shp, 'FaceColor', [204 204 204] / 255, 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
            %trisurf(k, xCell, yCell, zCell, 'FaceColor', [204 204 204] / 255, 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
        else
            plot(shp, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
            %trisurf(k, xCell, yCell, zCell, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
        end
        hold on;
    end
    axis equal
    camlight left;
    camlight right;
    lighting flat
    newFig = gca;
    newFig.Visible = 'off';
    newFig.CameraPositionMode = 'manual';
    newFig.CameraTargetMode = 'manual';
    newFig.CameraUpVectorMode = 'manual';
    newFig.CameraViewAngleMode = 'manual';
    set(get(0,'children'),'Color','w')
    %print(strcat('../motif_3DCells_4_', date), '-dtiff', '-r600');
end

