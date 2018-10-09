function plotVerticesPerSurfaceRatio(cellsVertices,dir2save,nameSplitted,nameSimulation,nSurfR)

    figure('Visible', 'off', 'units','normalized','outerposition',[0 0 1 1]);
    faceColours = [1 1 1; 1 1 0; 1 0.5 0];
    edgeColours = [0 0 1; 0 1 0];
    for nRow = 1: size(cellsVertices,1)
        
        edgeColour = edgeColours(cellsVertices{nRow, 3}+1, :);
        faceColour = faceColours(cellsVertices{nRow, 4}+1, :); 
        
        
        allVerticesInCell = cellsVertices{nRow,end};
        
        vertsX = allVerticesInCell(1:2:end-1);
        vertsY = allVerticesInCell(2:2:end);
        patch(vertsX, vertsY, faceColour);
        hold on
        vertsX = [vertsX,vertsX(1)];
        vertsY = [vertsY,vertsY(1)];
        
        for nVert = 1 : length(vertsX)-1
            plot([vertsX(nVert:nVert+1)], [vertsY(nVert:nVert+1)], 'Color', edgeColour, 'LineWidth', 3);
            plot(vertsX(nVert), vertsY(nVert), '*r');
        end
        
        text(round(mean(vertsX(1:end-1))) - 20, round(mean(vertsY(1:end-1))), num2str(cellsVertices{nRow,2}));
        hold on
    end
    
    print([dir2save, '\plot_', nameSimulation,'_realization', nameSplitted{2} , '_SurfaceRatio_', num2str(nSurfR), '_', date, '.png'], '-dpng', '-r300');
    
    close all
end