function surfaceProjection( pathV5data,nameOfFolder,directory2save,path3dVoronoi,kindProjection,listOfSurfaceRatios,numSeeds)

    %Define acummulative variables
    acumListTransitionBySurfaceRatio=zeros(length(listOfSurfaceRatios),size(pathV5data,1)*3);
    acumListDataAnglesTransitionInBasal=cell(size(pathV5data,1),1);
    acumListDataAnglesTransitionInApical=cell(size(pathV5data,1),1);
    totalAnglesTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),size(pathV5data,1));
    totalAnglesTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),size(pathV5data,1));
    totalEdgesTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),size(pathV5data,1));
    totalEdgesTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),size(pathV5data,1));

    acumListDataAnglesNoTransitionInBasal=cell(size(pathV5data,1),1);
    acumListDataAnglesNoTransitionInApical=cell(size(pathV5data,1),1);
    totalAnglesNoTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),size(pathV5data,1));
    totalAnglesNoTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),size(pathV5data,1));
    totalEdgesNoTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),size(pathV5data,1));
    totalEdgesNoTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),size(pathV5data,1));
    
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
        [listTransitionsBySurfaceRatio,listSeedsProjected,listLOriginalProjection,...
            listDataAnglesTransitionMeasuredInBasal,listDataAnglesTransitionMeasuredInApical,...
            totalAnglesTransitionMeasuredInBasal,totalAnglesTransitionMeasuredInApical,...
            acumListTransitionBySurfaceRatio,acumListDataAnglesTransitionInBasal,...
            acumListDataAnglesNoTransitionInBasal,acumListDataAnglesTransitionInApical,...
            acumListDataAnglesNoTransitionInApical,totalEdgesTransitionMeasuredInBasal,...
            totalEdgesTransitionMeasuredInApical,listDataAnglesNoTransitionMeasuredInBasal,...
            listDataAnglesNoTransitionMeasuredInApical,totalAnglesNoTransitionMeasuredInBasal,...
            totalAnglesNoTransitionMeasuredInApical,totalEdgesNoTransitionMeasuredInBasal,...
            totalEdgesNoTransitionMeasuredInApical]...
            =expansionOrReductionIterative(listOfSurfaceRatios,seedsOriginal,L_original,...
            numCells,pathV5data,directory2save,kindProjection,nameOfFolder,i,...
            totalAnglesTransitionMeasuredInBasal,totalAnglesTransitionMeasuredInApical,...
            acumListTransitionBySurfaceRatio,acumListDataAnglesTransitionInBasal,...
            acumListDataAnglesNoTransitionInBasal,acumListDataAnglesTransitionInApical,...
            acumListDataAnglesNoTransitionInApical,totalEdgesTransitionMeasuredInBasal,...
            totalEdgesTransitionMeasuredInApical,totalAnglesNoTransitionMeasuredInBasal,...
            totalAnglesNoTransitionMeasuredInApical,totalEdgesNoTransitionMeasuredInBasal,...
            totalEdgesNoTransitionMeasuredInApical);
        
        
        
        %save data for each random
        name2save=pathV5data(i).name;
        name2save=strsplit(name2save,'.mat');
        name2save=name2save{1};
        save([directory2save kindProjection '\' nameOfFolder name2save '\'  name2save '.mat'],'listLOriginalProjection','listSeedsProjected','listTransitionsBySurfaceRatio','listDataAnglesTransitionMeasuredInBasal','listDataAnglesTransitionMeasuredInApical','listDataAnglesNoTransitionMeasuredInBasal','listDataAnglesNoTransitionMeasuredInApical')



    end

    %save global data
    summaryAndSaveFinalData(listOfSurfaceRatios,numSeeds,acumListTransitionBySurfaceRatio,acumListDataAnglesTransitionInBasal,totalEdgesTransitionMeasuredInBasal,totalEdgesNoTransitionMeasuredInBasal,totalAnglesTransitionMeasuredInBasal,directory2save,kindProjection,nameOfFolder,'Basal_Transitions')
    summaryAndSaveFinalData(listOfSurfaceRatios,numSeeds,acumListTransitionBySurfaceRatio,acumListDataAnglesNoTransitionInBasal,totalEdgesNoTransitionMeasuredInBasal,totalEdgesTransitionMeasuredInBasal,totalAnglesNoTransitionMeasuredInBasal,directory2save,kindProjection,nameOfFolder,'Basal_NoTransitions')
    summaryAndSaveFinalData(listOfSurfaceRatios,numSeeds,acumListTransitionBySurfaceRatio,acumListDataAnglesTransitionInApical,totalEdgesTransitionMeasuredInApical,totalEdgesNoTransitionMeasuredInApical,totalAnglesTransitionMeasuredInApical,directory2save,kindProjection,nameOfFolder,'Apical_Transitions')
    summaryAndSaveFinalData(listOfSurfaceRatios,numSeeds,acumListTransitionBySurfaceRatio,acumListDataAnglesNoTransitionInApical,totalEdgesNoTransitionMeasuredInApical,totalEdgesTransitionMeasuredInApical,totalAnglesNoTransitionMeasuredInApical,directory2save,kindProjection,nameOfFolder,'Apical_NoTransitions')
    
   
end

