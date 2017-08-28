function [ ] = create3DMotifFromVoronoi( )
%CREATE3DMOTIFFROMVORONOI Summary of this function goes here
%   Detailed explanation goes here
    load('D:\Pablo\Epithelia3D\Salivary Glands\Curvature model\data\Image_10.mat')
    
    selectedCells = [22, 25, 30];
    %% Rb/Ra = 2
    pixelsPerCell = {};
    
    for selectedCell = 1:size(selectedCells, 2)
        for numPlane = 1:6
            actualPlaneImg = cell2mat(listLOriginalProjection.L_originalProjection(numPlane));
            
            [imgRows,imgCols] = size(actualPlaneImg);
%             [X,Y,Z] = cylinder(imgRows,imgCols);
%             Z=Z*4000;
%             X=X*0.2*listLOriginalProjection.surfaceRatio(numPlane);
%             Y=Y*0.2*listLOriginalProjection.surfaceRatio(numPlane);
%             hRef = warp(X,Y,Z,actualPlaneImg);
            
            [actualCellPxX, actualCellPxY] = find(actualPlaneImg == selectedCells(selectedCell));
            
            actualCellPxX = actualCellPxX * 0.2;
            actualCellPxY = actualCellPxY * 0.2;
            
            actualCellPxs = [actualCellPxX, actualCellPxY];
            
            actualCellBoundary = boundary(actualCellPxX, actualCellPxY, 0);
            boundaryPxs = [actualCellPxs(actualCellBoundary, :), ones(size(actualCellBoundary, 1), 1) * listLOriginalProjection.surfaceRatio(numPlane) * 4000];
            if numPlane == 1
                pixelsPerCell{selectedCell} = boundaryPxs;
            else
                pixelsPerCell{selectedCell} = vertcat(pixelsPerCell{selectedCell}, boundaryPxs);
            end
        end
        pixelsPerCell;
    end
    
    colours = [255 255 51;  255 0 0; 102 153 51; 102 153 255] / 255;
    plotFigure3DFromCellBoundaries(pixelsPerCell, colours);
%     figure;
%     for numCell = 1:size(selectedCells, 2);
%         actualCellPxs = pixelsPerCell{numCell};
%         xCell = actualCellPxs(:, 1);
%         yCell = actualCellPxs(:, 2);
%         zCell = actualCellPxs(:, 3);
%         [yCellPol, zCellPol, xCellPol] = cart2pol(yCell, zCell, xCell);
%         actualCellPxs = [xCellPol, yCellPol, zCellPol];
%         k = boundary(actualCellPxs, 0);
%         trisurf(k, xCellPol, yCellPol, zCellPol, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
%         hold on;
%     end
end

