function [listSeedsProjected,listLOriginalProjection,listDataAnglesTransitionMeasuredInBasal,listDataAnglesTransitionMeasuredInApical,listDataAnglesNoTransitionMeasuredInBasal,listDataAnglesNoTransitionMeasuredInApical,totalAngles,totalEdges,totalCellMotifs,acumListDataAngles] = expansionOrReductionIterative(listOfSurfaceRatios,seedsOriginal,L_original,numCells,name2save,directory2save,kindProjection,nameOfFolder)
%EXPANSIONORREDUCTIONITERATIVE project the seeds over cylinder with 
%different radii, generate a Voronoi diagram over the surface,and provide 
%us of information respect to the presence of transition, the angles and 
%length, measured in both surfaces (basal and apical)      

    %Define acummulative variables in which saving all data
    listDataAnglesTransitionMeasuredInBasal=zeros(length(listOfSurfaceRatios),7);
    listDataAnglesTransitionMeasuredInApical=zeros(length(listOfSurfaceRatios),7);
    listDataAnglesNoTransitionMeasuredInBasal=zeros(length(listOfSurfaceRatios),7);
    listDataAnglesNoTransitionMeasuredInApical=zeros(length(listOfSurfaceRatios),7);
    listSeedsProjected=cell(length(listOfSurfaceRatios),2);
    listLOriginalProjection=cell(length(listOfSurfaceRatios),2);
    
    totalAnglesTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),1);
    totalAnglesTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),1);
    totalAnglesNoTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),1);
    totalAnglesNoTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),1);
    totalEdgesTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),1);
    totalEdgesTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),1);
    totalEdgesNoTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),1);
    totalEdgesNoTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),1);
    totalCellsMotifsTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),1);
    totalCellsMotifsTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),1);
    totalCellsMotifsNoTransitionMeasuredInBasal=cell(length(listOfSurfaceRatios),1);
    totalCellsMotifsNoTransitionMeasuredInApical=cell(length(listOfSurfaceRatios),1);
    
    name2save=strrep(name2save,'.mat','');

    for j=1:length(listOfSurfaceRatios) %parfor
            %surface reduction implication - recalculate seeds and labelled images
            surfaceRatio=listOfSurfaceRatios(j);
            [H,W]=size(L_original);
            %Get seeds projected
            seedsProjected=[seedsOriginal(:,1:2),round(seedsOriginal(:,3)*surfaceRatio)];
            %Generation of cylinder voronoi from projected seeds
            L_originalProjection=generateCylindricalVoronoi(seedsProjected,H,round(W*surfaceRatio));
                
            % Representations of colourful images        
            representAndSaveFigureWithColourfulCells(L_originalProjection,numCells,seedsProjected(:,2:3),[directory2save kindProjection '\' nameOfFolder],name2save, ['_' kindProjection '_' num2str(surfaceRatio)])

            %% Testing neighs exchanges
            if strcmp(kindProjection,'expansion')
                L_basal=L_originalProjection;
                L_apical=L_original;
            else
                L_basal=L_original;
                L_apical=L_originalProjection;
            end
            
             %neighbours in basal layer
            [neighs_basal,~]=calculateNeighbours(L_basal);
            %neighbours in apical layer
            [neighs_apical,~]=calculateNeighbours(L_apical);
            %number of winning neighbourings in basal 
            nWinBasApi=sum(cellfun(@(x,y) ~isempty(setdiff(x,y)),neighs_apical,neighs_basal));

            
            %% Measure and store angles of edges
            if nWinBasApi>0
                [dataAnglesAndLengthEdgesTransitionMeasuredInBasal,dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal]=measureAnglesAndLengthOfEdges(L_basal,L_apical);
                [dataAnglesAndLengthEdgesTransitionMeasuredInApical,dataAnglesAndLengthEdgesNoTransitionMeasuredInApical]=measureAnglesAndLengthOfEdges(L_apical,L_basal);
                
                %transition data
                listDataAnglesTransitionMeasuredInBasal(j,:)=[dataAnglesAndLengthEdgesTransitionMeasuredInBasal.numOfEdges,dataAnglesAndLengthEdgesTransitionMeasuredInBasal.proportionAnglesLess15deg,dataAnglesAndLengthEdgesTransitionMeasuredInBasal.proportionAnglesBetween15_30deg,dataAnglesAndLengthEdgesTransitionMeasuredInBasal.proportionAnglesBetween30_45deg,dataAnglesAndLengthEdgesTransitionMeasuredInBasal.proportionAnglesBetween45_60deg,dataAnglesAndLengthEdgesTransitionMeasuredInBasal.proportionAnglesBetween60_75deg,dataAnglesAndLengthEdgesTransitionMeasuredInBasal.proportionAnglesBetween75_90deg];
                listDataAnglesTransitionMeasuredInApical(j,:)=[dataAnglesAndLengthEdgesTransitionMeasuredInApical.numOfEdges,dataAnglesAndLengthEdgesTransitionMeasuredInApical.proportionAnglesLess15deg,dataAnglesAndLengthEdgesTransitionMeasuredInApical.proportionAnglesBetween15_30deg,dataAnglesAndLengthEdgesTransitionMeasuredInApical.proportionAnglesBetween30_45deg,dataAnglesAndLengthEdgesTransitionMeasuredInApical.proportionAnglesBetween45_60deg,dataAnglesAndLengthEdgesTransitionMeasuredInApical.proportionAnglesBetween60_75deg,dataAnglesAndLengthEdgesTransitionMeasuredInApical.proportionAnglesBetween75_90deg];
                totalAnglesTransitionMeasuredInBasal{j,1}=dataAnglesAndLengthEdgesTransitionMeasuredInBasal.edgeAngle;
                totalAnglesTransitionMeasuredInApical{j,1}=dataAnglesAndLengthEdgesTransitionMeasuredInApical.edgeAngle;
                totalEdgesTransitionMeasuredInBasal{j,1}=dataAnglesAndLengthEdgesTransitionMeasuredInBasal.edgeLength;
                totalEdgesTransitionMeasuredInApical{j,1}=dataAnglesAndLengthEdgesTransitionMeasuredInApical.edgeLength;
                totalCellsMotifsTransitionMeasuredInBasal{j,1}=dataAnglesAndLengthEdgesTransitionMeasuredInBasal.cellularMotifs;
                totalCellsMotifsTransitionMeasuredInApical{j,1}=dataAnglesAndLengthEdgesTransitionMeasuredInApical.cellularMotifs;
                
                %no transition data
                listDataAnglesNoTransitionMeasuredInBasal(j,:)=[dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.numOfEdges,dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.proportionAnglesLess15deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.proportionAnglesBetween15_30deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.proportionAnglesBetween30_45deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.proportionAnglesBetween45_60deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.proportionAnglesBetween60_75deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.proportionAnglesBetween75_90deg];
                listDataAnglesNoTransitionMeasuredInApical(j,:)=[dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.numOfEdges,dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.proportionAnglesLess15deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.proportionAnglesBetween15_30deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.proportionAnglesBetween30_45deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.proportionAnglesBetween45_60deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.proportionAnglesBetween60_75deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.proportionAnglesBetween75_90deg];
                totalAnglesNoTransitionMeasuredInBasal{j,1}=dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.edgeAngle;
                totalAnglesNoTransitionMeasuredInApical{j,1}=dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.edgeAngle;
                totalEdgesNoTransitionMeasuredInBasal{j,1}=dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.edgeLength;
                totalEdgesNoTransitionMeasuredInApical{j,1}=dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.edgeLength;
                totalCellsMotifsNoTransitionMeasuredInBasal{j,1}=dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.cellularMotifs;
                totalCellsMotifsNoTransitionMeasuredInApical{j,1}=dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.cellularMotifs;               
            end
            listSeedsProjected(j,:)=[{surfaceRatio},{seedsProjected}];
            listLOriginalProjection(j,:)=[{surfaceRatio},{L_originalProjection}];
            close all
    end
    
    
    %store data after application of surface ratios
    totalAngles.TransitionInBasal=totalAnglesTransitionMeasuredInBasal;
    totalAngles.TransitionInApical=totalAnglesTransitionMeasuredInApical;
    totalAngles.NoTransitionInBasal=totalAnglesNoTransitionMeasuredInBasal;
    totalAngles.NoTransitionInApical=totalAnglesNoTransitionMeasuredInApical;
    totalEdges.TransitionInBasal=totalEdgesTransitionMeasuredInBasal;
    totalEdges.TransitionInApical=totalEdgesTransitionMeasuredInApical;
    totalEdges.NoTransitionInBasal=totalEdgesNoTransitionMeasuredInBasal;
    totalEdges.NoTransitionInApical=totalEdgesNoTransitionMeasuredInApical;
    totalCellMotifs.TransitionInBasal=totalCellsMotifsTransitionMeasuredInBasal;
    totalCellMotifs.TransitionInApical=totalCellsMotifsTransitionMeasuredInApical;
    totalCellMotifs.NoTransitionInBasal=totalCellsMotifsNoTransitionMeasuredInBasal;
    totalCellMotifs.NoTransitionInApical=totalCellsMotifsNoTransitionMeasuredInApical;

    %transition data
    acumListDataAngles.TransitionInBasal=listDataAnglesTransitionMeasuredInBasal;
    acumListDataAngles.TransitionInApical=listDataAnglesTransitionMeasuredInApical;
    listDataAnglesTransitionMeasuredInBasal=array2table(listDataAnglesTransitionMeasuredInBasal);
    listDataAnglesTransitionMeasuredInBasal.Properties.VariableNames={'numOfEdgesOfTransition','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};
    listDataAnglesTransitionMeasuredInApical=array2table(listDataAnglesTransitionMeasuredInApical);
    listDataAnglesTransitionMeasuredInApical.Properties.VariableNames={'numOfEdgesOfTransition','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};
    
    %no transition data
    acumListDataAngles.NoTransitionInBasal=listDataAnglesNoTransitionMeasuredInBasal;
    acumListDataAngles.NoTransitionInApical=listDataAnglesNoTransitionMeasuredInApical;
    listDataAnglesNoTransitionMeasuredInBasal=array2table(listDataAnglesNoTransitionMeasuredInBasal);
    listDataAnglesNoTransitionMeasuredInBasal.Properties.VariableNames={'numOfEdges','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};
    listDataAnglesNoTransitionMeasuredInApical=array2table(listDataAnglesNoTransitionMeasuredInApical);
    listDataAnglesNoTransitionMeasuredInApical.Properties.VariableNames={'numOfEdges','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};
    
    %projection data
    listSeedsProjected=cell2table(listSeedsProjected);
    listSeedsProjected.Properties.VariableNames = {'surfaceRatio','seedsApical'};
    listLOriginalProjection=cell2table(listLOriginalProjection);
    listLOriginalProjection.Properties.VariableNames= {'surfaceRatio','L_originalProjection'};


    
end

