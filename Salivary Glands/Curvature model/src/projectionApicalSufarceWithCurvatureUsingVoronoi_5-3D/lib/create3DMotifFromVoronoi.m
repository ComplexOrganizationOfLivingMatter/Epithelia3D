function [ ] = create3DMotifFromVoronoi( )
%CREATE3DMOTIFFROMVORONOI Summary of this function goes here
%   Detailed explanation goes here
    load('D:\Pablo\Epithelia3D\Salivary Glands\Curvature model\data\Image_10.mat')
    
    selectedCells = [22, 25, 30];
    %% Rb/Ra = 2
    
    for selectedCell = 1:size(selectedCells, 1)
        for numPlane = 1:6
            actualPlaneImg = listLOriginalProjection.L_originalProjection(numPlane);
            actualCellPxs = actualPlaneImg == selectedCells(selectedCell);
            actualCellBoundary = boundary(actualCellPxs(:, 1), actualCellPxs(:, 2), 0);
            
        end
    end
end

