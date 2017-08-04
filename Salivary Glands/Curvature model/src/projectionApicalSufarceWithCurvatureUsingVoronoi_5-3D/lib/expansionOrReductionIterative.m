function [listTransitionsBySurfaceRatio,listSeedsProjected,listLOriginalProjection,listDataAnglesMeasuredInBasal,listDataAnglesMeasuredInApical,totalAnglesMeasuredInBasal,totalAnglesMeasuredInApical,acumListTransitionByCurv,acumListDataAnglesInBasal,acumListDataAnglesInApical,totalEdgesTransitionMeasuredInBasal,totalEdgesTransitionMeasuredInApical]=expansionOrReductionIterative(listOfSurfaceRatios,seedsOriginal,L_original,numCells,pathV5data,directory2save,kindProjection,nameOfFolder,i,totalAnglesMeasuredInBasal,totalAnglesMeasuredInApical,acumListTransitionByCurv,acumListDataAnglesInBasal,acumListDataAnglesInApical,totalEdgesTransitionMeasuredInBasal,totalEdgesTransitionMeasuredInApical)
        
    listTransitionsBySurfaceRatio=zeros(length(listOfSurfaceRatios),4);
    listDataAnglesMeasuredInBasal=zeros(length(listOfSurfaceRatios),7);
    listDataAnglesMeasuredInApical=zeros(length(listOfSurfaceRatios),7);
    listSeedsProjected=cell(length(listOfSurfaceRatios),1);
    listLOriginalProjection=cell(length(listOfSurfaceRatios),1);

    for j=1:length(listOfSurfaceRatios)
            %% surface reduction implication - recalculate seeds and labelled images
            surfaceRatio=listOfSurfaceRatios(j);
            
            [H,W]=size(L_original);
            seedsExpansion=[seedsOriginal(:,1:2),round(seedsOriginal(:,3)*surfaceRatio)];
            L_originalProjection=generateCylindricalVoronoi(seedsExpansion,H,round(W*surfaceRatio));
                
            %% Representations        

            name2save=pathV5data(i).name;
            name2save=name2save(1:end-16);
            representAndSaveFigureWithColourfulCells(L_originalProjection,numCells,seedsExpansion(:,2:3),[directory2save kindProjection '\' nameOfFolder],name2save, ['_expansion' num2str(surfaceRatio)])

            %% Testing neighs exchanges
            if strcmp(kindProjection,'expansion')
                L_basal=L_originalProjection;
                L_apical=L_original;
            else
                L_basal=L_original;
                L_apical=L_originalProjection;
            end
            [numberOfTransitionsBasApi,nWinBasApi,nLossBasApi] = testingNeighsExchange(L_basal,L_apical);

            
            %% Measure and store angles of edges
            if nWinBasApi>0
                [dataAnglesMeasuredInBasal]=measureAnglesAndLengthOfEdgesTransition(L_basal,L_apical);
                [dataAnglesMeasuredInApical]=measureAnglesAndLengthOfEdgesTransition(L_apical,L_basal);
                listDataAnglesMeasuredInBasal(j,:)=[dataAnglesMeasuredInBasal.numOfEdgesOfTransition,dataAnglesMeasuredInBasal.proportionAnglesLess15deg,dataAnglesMeasuredInBasal.proportionAnglesBetween15_30deg,dataAnglesMeasuredInBasal.proportionAnglesBetween30_45deg,dataAnglesMeasuredInBasal.proportionAnglesBetween45_60deg,dataAnglesMeasuredInBasal.proportionAnglesBetween60_75deg,dataAnglesMeasuredInBasal.proportionAnglesBetween75_90deg];
                listDataAnglesMeasuredInApical(j,:)=[dataAnglesMeasuredInApical.numOfEdgesOfTransition,dataAnglesMeasuredInApical.proportionAnglesLess15deg,dataAnglesMeasuredInApical.proportionAnglesBetween15_30deg,dataAnglesMeasuredInApical.proportionAnglesBetween30_45deg,dataAnglesMeasuredInApical.proportionAnglesBetween45_60deg,dataAnglesMeasuredInApical.proportionAnglesBetween60_75deg,dataAnglesMeasuredInApical.proportionAnglesBetween75_90deg];
                totalAnglesMeasuredInBasal{j,i}=dataAnglesMeasuredInBasal.angles;
                totalAnglesMeasuredInApical{j,i}=dataAnglesMeasuredInApical.angles;
                totalEdgesTransitionMeasuredInBasal{j,i}=dataAnglesMeasuredInBasal.edgeLength;
                totalEdgesTransitionMeasuredInApical{j,i}=dataAnglesMeasuredInApical.edgeLength;                
            end
            
            listTransitionsBySurfaceRatio(j,:)=[surfaceRatio,nWinBasApi,nLossBasApi,numberOfTransitionsBasApi];
            listSeedsProjected{j,1}=surfaceRatio;
            listSeedsProjected{j,2}=seedsExpansion;
            listLOriginalProjection{j,1}=surfaceRatio;
            listLOriginalProjection{j,2}=L_originalProjection;
            
            close all

            
    end
    
    %store data of applying surface ratios
    acumListTransitionByCurv(:,i)=listTransitionsBySurfaceRatio(:,2);
    acumListTransitionByCurv(:,i+20)=listTransitionsBySurfaceRatio(:,3);
    acumListTransitionByCurv(:,i+40)=listTransitionsBySurfaceRatio(:,4);

    acumListDataAnglesInBasal{i,1}=listDataAnglesMeasuredInBasal;
    acumListDataAnglesInApical{i,1}=listDataAnglesMeasuredInApical;

    listDataAnglesMeasuredInBasal=array2table(listDataAnglesMeasuredInBasal);
    listDataAnglesMeasuredInBasal.Properties.VariableNames={'numOfEdgesOfTransition','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};
    listDataAnglesMeasuredInApical=array2table(listDataAnglesMeasuredInApical);
    listDataAnglesMeasuredInApical.Properties.VariableNames={'numOfEdgesOfTransition','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};
    listTransitionsBySurfaceRatio=array2table(listTransitionsBySurfaceRatio);
    listTransitionsBySurfaceRatio.Properties.VariableNames = {'surfaceRatio','nWins', 'nLoss','nTransitions'};
    listSeedsProjected=cell2table(listSeedsProjected);
    listSeedsProjected.Properties.VariableNames = {'surfaceRatio','seedsApical'};
    listLOriginalProjection=cell2table(listLOriginalProjection);
    listLOriginalProjection.Properties.VariableNames= {'surfaceRatio','L_originalProjection'};


    
end

