function draw3dSurfaces(setOfCells,layer1,layer2,names,nNam)
    colours = jet(double(max(setOfCells.Layer1)));
    colours = colours(randperm(max(setOfCells.Layer1)), :);
    h=figure;    
    for nCell=setOfCells.Layer1'
        [x,y,z] = ind2sub(size(layer1.outerSurface),find(layer1.outerSurface==nCell));
        shp=alphaShape(x,y,z,10);
        plot(shp, 'FaceColor', colours(nCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
        hold on
    end
    
    savefig(h,['..\' names{nNam} '\outerSurfaceLayer1.fig']);
    close(h)
    
    h=figure;    
    for nCell=setOfCells.Layer1'
        [x,y,z] = ind2sub(size(layer1.innerSurface),find(layer1.innerSurface==nCell));
        shp=alphaShape(x,y,z,10);
        plot(shp, 'FaceColor', colours(nCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
        hold on
    end
    savefig(h,['..\' names{nNam} '\innerSurfaceLayer1.fig']);
    close(h)
    
    colours = jet(double(max(setOfCells.Layer2)));
    colours = colours(randperm(max(setOfCells.Layer2)), :);
    h=figure;    
    for nCell=setOfCells.Layer2'
        [x,y,z] = ind2sub(size(layer2.outerSurface),find(layer2.outerSurface==nCell));
        shp=alphaShape(x,y,z,10);
        plot(shp, 'FaceColor', colours(nCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
        hold on
    end
    
    savefig(h,['..\' names{nNam} '\outerSurfaceLayer2.fig']);
    close(h)
    
    h=figure;    
    for nCell=setOfCells.Layer2'
        [x,y,z] = ind2sub(size(layer2.innerSurface),find(layer2.innerSurface==nCell));
        shp=alphaShape(x,y,z,10);
        plot(shp, 'FaceColor', colours(nCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
        hold on
    end
    savefig(h,['..\' names{nNam} '\innerSurfaceLayer2.fig']);
    close(h)
end

