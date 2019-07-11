function surfaceProjection( pathV5data,nameOfFolder,directory2save,path3dVoronoi,kindProjection,listOfSurfaceRatios)
%SURFACEPROJECTION project the seeds over cylinder with 
%different radii, generate a Voronoi diagram over the surface,and provide 
%us of information respect to the presence of transition, the angles and 
%length, measured in both surfaces (basal and apical)    

%     %Define acummulative variables in which saving all data
%     acumListDataAnglesTransitionInBasal=cell(size(pathV5data,1),1);
%     acumListDataAnglesTransitionInApical=cell(size(pathV5data,1),1);
%     acumListDataAnglesNoTransitionInBasal=cell(size(pathV5data,1),1);
%     acumListDataAnglesNoTransitionInApical=cell(size(pathV5data,1),1);
%     
%     totalAnglesTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),size(pathV5data,1));
%     totalAnglesNoTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),size(pathV5data,1));
%     totalAnglesTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),size(pathV5data,1));
%     totalAnglesNoTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),size(pathV5data,1));
%     
%     totalEdgesTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),size(pathV5data,1));
%     totalEdgesNoTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),size(pathV5data,1));
%     totalEdgesTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),size(pathV5data,1));
%     totalEdgesNoTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),size(pathV5data,1));
    
    for i=1:size(pathV5data,1)

        
        %load cylindrical Voronoi 5 data
        load([path3dVoronoi pathV5data(i).name])        
        if contains(pathV5data(i).name,'Diagram_1.mat')
            indSeeds = sub2ind(size(L_original),seeds(:,1),seeds(:,2));
            labSeeds = L_original(indSeeds);
            seeds_values_before = [labSeeds,seeds];
        end
        seedsOriginal=sortrows(seeds_values_before,1);
        numCells=size(seeds_values_before,1);
        
        %% We apply surface ratio to get in an iterative way new layers in apical or basal surfaces
        [listSeedsProjected,listLOriginalProjection]...
            = expansionOrReductionIterative(listOfSurfaceRatios,seedsOriginal,L_original,...
            numCells,pathV5data(i).name,directory2save,kindProjection,nameOfFolder);
        
%             [listSeedsProjected,listLOriginalProjection,totalAngles,totalEdges,totalCellMotifs,acumListDataAngles,...
%             listDataAnglesTransitionMeasuredInBasal,listDataAnglesTransitionMeasuredInApical,...
%             listDataAnglesNoTransitionMeasuredInBasal,listDataAnglesNoTransitionMeasuredInApical]...
%                 = expansionOrReductionIterative(listOfSurfaceRatios,seedsOriginal,L_original,...
%                 numCells,pathV5data(i).name,directory2save,kindProjection,nameOfFolder);
%         
%             totalAnglesTransitionMeasuredInBasal(:,i)=totalAngles.TransitionInBasal;
%             totalAnglesNoTransitionMeasuredInBasal(:,i)=totalAngles.NoTransitionInBasal;
%             totalAnglesTransitionMeasuredInApical(:,i)=totalAngles.TransitionInApical;
%             totalAnglesNoTransitionMeasuredInApical(:,i)=totalAngles.NoTransitionInApical;
% 
%             totalEdgesTransitionMeasuredInBasal(:,i)=totalEdges.TransitionInBasal;
%             totalEdgesNoTransitionMeasuredInBasal(:,i)=totalEdges.NoTransitionInBasal;
%             totalEdgesTransitionMeasuredInApical(:,i)=totalEdges.TransitionInApical;
%             totalEdgesNoTransitionMeasuredInApical(:,i)=totalEdges.NoTransitionInApical;
% 
%             acumListDataAnglesTransitionInBasal{i}=acumListDataAngles.TransitionInBasal;
%             acumListDataAnglesNoTransitionInBasal{i}=acumListDataAngles.NoTransitionInBasal;
%             acumListDataAnglesTransitionInApical{i}=acumListDataAngles.TransitionInApical;
%             acumListDataAnglesNoTransitionInApical{i}=acumListDataAngles.NoTransitionInApical;
                    
        %save data for each random
        name2save=strrep(pathV5data(i).name,'.mat','');
        nameSplit = strsplit(name2save,'_');
        diagFolder = [lower(nameSplit{end-1}) nameSplit{end}];
%         save([directory2save kindProjection '\' nameOfFolder diagFolder '\' name2save '\'  name2save '.mat'],'listLOriginalProjection','listSeedsProjected','listDataAnglesTransitionMeasuredInBasal','listDataAnglesTransitionMeasuredInApical','listDataAnglesNoTransitionMeasuredInBasal','listDataAnglesNoTransitionMeasuredInApical','totalEdges','totalAngles','totalCellMotifs','-v7.3')
        save([directory2save kindProjection '\' nameOfFolder diagFolder '\' name2save '\'  name2save '.mat'],'listLOriginalProjection','listSeedsProjected','-v7.3')
        disp(['Projections of ' kindProjection ' ' nameOfFolder name2save ' completed'])

    end

%     %save global data
%     summaryAndSaveFinalDataWithoutFilter(listOfSurfaceRatios,acumListDataAnglesTransitionInBasal,totalEdgesTransitionMeasuredInBasal,totalEdgesNoTransitionMeasuredInBasal,totalAnglesTransitionMeasuredInBasal,directory2save,kindProjection,nameOfFolder,'Basal_Transitions')
%     summaryAndSaveFinalDataWithoutFilter(listOfSurfaceRatios,acumListDataAnglesNoTransitionInBasal,totalEdgesNoTransitionMeasuredInBasal,totalEdgesTransitionMeasuredInBasal,totalAnglesNoTransitionMeasuredInBasal,directory2save,kindProjection,nameOfFolder,'Basal_NoTransitions')
%     summaryAndSaveFinalDataWithoutFilter(listOfSurfaceRatios,acumListDataAnglesTransitionInApical,totalEdgesTransitionMeasuredInApical,totalEdgesNoTransitionMeasuredInApical,totalAnglesTransitionMeasuredInApical,directory2save,kindProjection,nameOfFolder,'Apical_Transitions')
%     summaryAndSaveFinalDataWithoutFilter(listOfSurfaceRatios,acumListDataAnglesNoTransitionInApical,totalEdgesNoTransitionMeasuredInApical,totalEdgesTransitionMeasuredInApical,totalAnglesNoTransitionMeasuredInApical,directory2save,kindProjection,nameOfFolder,'Apical_NoTransitions')
%     
%    
end

