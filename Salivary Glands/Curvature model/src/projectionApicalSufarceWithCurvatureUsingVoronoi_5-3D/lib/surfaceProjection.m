function surfaceProjection( pathV5data,nameOfFolder,directory2save,path3dVoronoi,kindProjection,listOfSurfaceRatios,numSeeds)

    %Define acummulative variables
    acumListTransitionBySurfaceRatio=zeros(length(listOfSurfaceRatios),size(pathV5data,1)*3);
    acumListDataAnglesInBasal=cell(size(pathV5data,1),1);
    acumListDataAnglesInApical=cell(size(pathV5data,1),1);
    totalAnglesMeasuredInBasal=cell(length(listOfSurfaceRatios),size(pathV5data,1));
    totalAnglesMeasuredInApical=cell(length(listOfSurfaceRatios),size(pathV5data,1));
    totalEdgesTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),size(pathV5data,1));
    totalEdgesTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),size(pathV5data,1));

    
    
    for i=1:size(pathV5data,1)

        
        %load cylindrical Voronoi 5 data
        load([path3dVoronoi pathV5data(i).name])
        
        %% Diameter of cell calculation and estimate heigth of cell and 'lumen'
        mask=L_original;
        for j=1:length(border_cells)
            mask(L_original==border_cells(j))=0;
        end
        
        seedsOriginal=sortrows(seeds_values_before,1);
        numCells=size(seeds_values_before,1);
        
        %% We apply ratio of surface to get in iterative way new layers in apical or basal surface
        [listTransitionsBySurfaceRatio,listSeedsProjected,listLOriginalProjection,listDataAnglesMeasuredInBasal,listDataAnglesMeasuredInApical,totalAnglesMeasuredInBasal,totalAnglesMeasuredInApical,acumListTransitionBySurfaceRatio,acumListDataAnglesInBasal,acumListDataAnglesInApical,totalEdgesTransitionMeasuredInBasal,totalEdgesTransitionMeasuredInApical]=expansionOrReductionIterative(listOfSurfaceRatios,seedsOriginal,L_original,numCells,pathV5data,directory2save,kindProjection,nameOfFolder,i,totalAnglesMeasuredInBasal,totalAnglesMeasuredInApical,acumListTransitionBySurfaceRatio,acumListDataAnglesInBasal,acumListDataAnglesInApical,totalEdgesTransitionMeasuredInBasal,totalEdgesTransitionMeasuredInApical);
        
        %save data for each random
        name2save=pathV5data(i).name;
        name2save=name2save(1:end-16);
        save([directory2save kindProjection '\' nameOfFolder name2save '\'  name2save '.mat'],'listLOriginalProjection','listSeedsProjected','listTransitionsBySurfaceRatio','listDataAnglesMeasuredInBasal','listDataAnglesMeasuredInApical')



    end

    %save global data
    summaryAndSaveFinalData(listOfSurfaceRatios,numSeeds,acumListTransitionBySurfaceRatio,acumListDataAnglesInBasal,totalEdgesTransitionMeasuredInBasal,totalAnglesMeasuredInBasal,directory2save,kindProjection,nameOfFolder,'basal')
    summaryAndSaveFinalData(listOfSurfaceRatios,numSeeds,acumListTransitionBySurfaceRatio,acumListDataAnglesInApical,totalEdgesTransitionMeasuredInApical,totalAnglesMeasuredInApical,directory2save,kindProjection,nameOfFolder,'apical')
    
end

