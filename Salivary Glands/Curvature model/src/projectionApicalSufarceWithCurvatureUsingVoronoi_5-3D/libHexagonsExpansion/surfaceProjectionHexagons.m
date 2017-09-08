function surfaceProjectionHexagons(pathHexagonalImage,nameOfFolder,directory2save,path3dVoronoi,kindProjection,listOfSurfaceRatios,numSeeds)

      
    %loading image data
    load([path3dVoronoi pathHexagonalImage(1).name])
    
    %% Diameter of cell calculation and estimate heigth of cell and 'lumen'
    mask=L_original;
    for j=1:length(border_cells)
        mask(L_original==border_cells(j))=0;
    end
    
    valuesLOriginal=arrayfun(@(x,y) L_original(x,y),seeds(:,1),seeds(:,2));
    seeds_values_before=[valuesLOriginal,seeds];
    seedsOriginal=sortrows(seeds_values_before,1);
    numCells=size(seeds,1);
    
    
    %% We apply ratio of surface to get in iterative way new layers in apical or basal surface
    [listTransitionsBySurfaceRatio,listSeedsProjected,listLOriginalProjection,...
    listDataAnglesTransitionMeasuredInBasal,listDataAnglesTransitionMeasuredInApical,...
    listDataAnglesNoTransitionMeasuredInBasal,listDataAnglesNoTransitionMeasuredInApical,]...
    =expansionHexagonalCylinderIterative(listOfSurfaceRatios,seedsOriginal,L_original,...
    numCells,pathHexagonalImage,directory2save,kindProjection,nameOfFolder);
     
    %save data for each random
    name2save=pathHexagonalImage(1).name;
    
    save([directory2save '512x1024_' num2str(numSeeds) 'seeds\' name2save],'listLOriginalProjection','listSeedsProjected','listTransitionsBySurfaceRatio','listDataAnglesTransitionMeasuredInBasal','listDataAnglesTransitionMeasuredInApical','listDataAnglesNoTransitionMeasuredInBasal','listDataAnglesNoTransitionMeasuredInApical')


    
    
    
end

