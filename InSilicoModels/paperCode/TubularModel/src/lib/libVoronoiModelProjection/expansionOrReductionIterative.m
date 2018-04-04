function [listTransitionsBySurfaceRatio,listSeedsProjected,listLOriginalProjection,listDataAnglesTransitionMeasuredInBasal,listDataAnglesTransitionMeasuredInApical,totalAnglesTransitionMeasuredInBasal,totalAnglesTransitionMeasuredInApical,acumListDataAnglesTransitionInBasal,acumListDataAnglesNoTransitionInBasal,acumListDataAnglesTransitionInApical,acumListDataAnglesNoTransitionInApical,totalEdgesTransitionMeasuredInBasal,totalEdgesTransitionMeasuredInApical,listDataAnglesNoTransitionMeasuredInBasal,listDataAnglesNoTransitionMeasuredInApical,totalAnglesNoTransitionMeasuredInBasal,totalAnglesNoTransitionMeasuredInApical,totalEdgesNoTransitionMeasuredInBasal,totalEdgesNoTransitionMeasuredInApical] = expansionOrReductionIterative(listOfSurfaceRatios,seedsOriginal,L_original,numCells,pathV5data,directory2save,kindProjection,nameOfFolder,i,totalAnglesTransitionMeasuredInBasal,totalAnglesTransitionMeasuredInApical,acumListDataAnglesTransitionInBasal,acumListDataAnglesNoTransitionInBasal,acumListDataAnglesTransitionInApical,acumListDataAnglesNoTransitionInApical,totalEdgesTransitionMeasuredInBasal,totalEdgesTransitionMeasuredInApical,totalAnglesNoTransitionMeasuredInBasal,totalAnglesNoTransitionMeasuredInApical,totalEdgesNoTransitionMeasuredInBasal,totalEdgesNoTransitionMeasuredInApical)
        
    listTransitionsBySurfaceRatio=zeros(length(listOfSurfaceRatios),4);
    listDataAnglesTransitionMeasuredInBasal=zeros(length(listOfSurfaceRatios),7);
    listDataAnglesTransitionMeasuredInApical=zeros(length(listOfSurfaceRatios),7);
    listDataAnglesNoTransitionMeasuredInBasal=zeros(length(listOfSurfaceRatios),7);
    listDataAnglesNoTransitionMeasuredInApical=zeros(length(listOfSurfaceRatios),7);
    listSeedsProjected=cell(length(listOfSurfaceRatios),2);
    listLOriginalProjection=cell(length(listOfSurfaceRatios),2);

    for j=1:length(listOfSurfaceRatios)
            %% surface reduction implication - recalculate seeds and labelled images
            surfaceRatio=listOfSurfaceRatios(j);
            [H,W]=size(L_original);
            seedsExpansion=[seedsOriginal(:,1:2),round(seedsOriginal(:,3)*surfaceRatio)];
            L_originalProjection=generateCylindricalVoronoi(seedsExpansion,H,round(W*surfaceRatio));
                
            %% Representations of colourful images        
            name2save=pathV5data(i).name;
            name2save=strsplit(name2save,'.mat');
            name2save=name2save{1};
            representAndSaveFigureWithColourfulCells(L_originalProjection,numCells,seedsExpansion(:,2:3),[directory2save kindProjection '\' nameOfFolder],name2save, ['_' kindProjection '_' num2str(surfaceRatio)])

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
                totalAnglesTransitionMeasuredInBasal{j,i}=dataAnglesAndLengthEdgesTransitionMeasuredInBasal.angles;
                totalAnglesTransitionMeasuredInApical{j,i}=dataAnglesAndLengthEdgesTransitionMeasuredInApical.angles;
                totalEdgesTransitionMeasuredInBasal{j,i}=dataAnglesAndLengthEdgesTransitionMeasuredInBasal.edgeLength;
                totalEdgesTransitionMeasuredInApical{j,i}=dataAnglesAndLengthEdgesTransitionMeasuredInApical.edgeLength;
                
                %no transition data
                listDataAnglesNoTransitionMeasuredInBasal(j,:)=[dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.numOfEdges,dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.proportionAnglesLess15deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.proportionAnglesBetween15_30deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.proportionAnglesBetween30_45deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.proportionAnglesBetween45_60deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.proportionAnglesBetween60_75deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.proportionAnglesBetween75_90deg];
                listDataAnglesNoTransitionMeasuredInApical(j,:)=[dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.numOfEdges,dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.proportionAnglesLess15deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.proportionAnglesBetween15_30deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.proportionAnglesBetween30_45deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.proportionAnglesBetween45_60deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.proportionAnglesBetween60_75deg,dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.proportionAnglesBetween75_90deg];
                totalAnglesNoTransitionMeasuredInBasal{j,i}=dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.angles;
                totalAnglesNoTransitionMeasuredInApical{j,i}=dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.angles;
                totalEdgesNoTransitionMeasuredInBasal{j,i}=dataAnglesAndLengthEdgesNoTransitionMeasuredInBasal.edgeLength;
                totalEdgesNoTransitionMeasuredInApical{j,i}=dataAnglesAndLengthEdgesNoTransitionMeasuredInApical.edgeLength;
                               
            end
            
            listSeedsProjected(j,:)=[{surfaceRatio},{seedsExpansion}];
            listLOriginalProjection(j,:)=[{surfaceRatio},{L_originalProjection}];
            close all

            
    end
    
    %store data after application of surface ratios
        
    %transition data
    acumListDataAnglesTransitionInBasal{i,1}=listDataAnglesTransitionMeasuredInBasal;
    acumListDataAnglesTransitionInApical{i,1}=listDataAnglesTransitionMeasuredInApical;
    listDataAnglesTransitionMeasuredInBasal=array2table(listDataAnglesTransitionMeasuredInBasal);
    listDataAnglesTransitionMeasuredInBasal.Properties.VariableNames={'numOfEdgesOfTransition','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};
    listDataAnglesTransitionMeasuredInApical=array2table(listDataAnglesTransitionMeasuredInApical);
    listDataAnglesTransitionMeasuredInApical.Properties.VariableNames={'numOfEdgesOfTransition','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};
    
    %no transition data
    acumListDataAnglesNoTransitionInBasal{i,1}=listDataAnglesNoTransitionMeasuredInBasal;
    acumListDataAnglesNoTransitionInApical{i,1}=listDataAnglesNoTransitionMeasuredInApical;
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

