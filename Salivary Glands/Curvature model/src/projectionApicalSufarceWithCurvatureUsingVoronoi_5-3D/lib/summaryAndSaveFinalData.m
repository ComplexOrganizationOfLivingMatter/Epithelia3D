function summaryAndSaveFinalData(listOfSurfaceRatios,acumListTransitionByCurv,acumListDataAngles,totalEdgesTransition,totalAngles,directory2save,kindProjection,nameOfFolder,typeSurface)
    
    listAcumTransitions=sortrows([(listOfSurfaceRatios'),mean(acumListTransitionByCurv(:,1:20),2)/numSeeds,std(acumListTransitionByCurv(:,1:20),0,2)/numSeeds,mean(acumListTransitionByCurv(:,21:40),2)/numSeeds,...
            std(acumListTransitionByCurv(:,21:40),0,2)/numSeeds,mean(acumListTransitionByCurv(:,41:end),2)/numSeeds,std(acumListTransitionByCurv(:,41:end),0,2)/numSeeds]);

    listAcumTransitions=array2table(listAcumTransitions);
    listAcumTransitions.Properties.VariableNames = {'apicalReduction','meanWins','stdWins','meanLoss','stdLoss','meanTransitions' ,'stdTransitions'};    

    acumListDataAngles=cat(3,acumListDataAngles{:});
    meanListDataAngles=array2table(mean(acumListDataAngles,3));
    stdListDataAngles=array2table(std(acumListDataAngles,[],3));
    meanListDataAngles.Properties.VariableNames ={'numOfEdgesOfTransition','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};
    stdListDataAngles.Properties.VariableNames ={'numOfEdgesOfTransition','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};

    boxTreshLength=round(max(vertcat(totalEdgesTransition{:,:}))/5)-1;
    proportionEdges=cellfun(@(x) [sum(x<=boxTreshLength),sum(x<=2*boxTreshLength & x>boxTreshLength),sum(x<=3*boxTreshLength & x>2*boxTreshLength),sum(x<=4*boxTreshLength & x>3*boxTreshLength),sum(x>4*boxTreshLength)]/length(x),totalEdgesTransition,'UniformOutput',false);
    
    meanListLengthEdges=zeros(length(listOfSurfaceRatios),5);
    stdListLengthEdges=zeros(length(listOfSurfaceRatios),5);
    acumAngles=cell(length(listOfSurfaceRatios),1);
    acumEdgesTransition=cell(length(listOfSurfaceRatios),1);
    for i=1:length(listOfSurfaceRatios)
        acumAngles{i}=cat(1,totalAngles{i,:});
        acumEdgesTransition{i}=cat(1,totalEdgesTransition{i,:});
        meanListLengthEdges(i,:)=mean(cat(1,proportionEdges{i,:}));
        stdListLengthEdges(i,:)=std(cat(1,proportionEdges{i,:}));
    end
    meanListLengthEdges=array2table(meanListLengthEdges);
    stdListLengthEdges=array2table(stdListLengthEdges);
    meanListLengthEdges.Properties.VariableNames ={['XlowerOrEqual' num2str(boxTreshLength)],['between' num2str(boxTreshLength) 'and' num2str(2*boxTreshLength) ],['between' num2str(2*boxTreshLength) 'and' num2str(3*boxTreshLength) ],['between' num2str(3*boxTreshLength) 'and' num2str(4*boxTreshLength) ],['Xupper' num2str(4*boxTreshLength) ]};
    stdListLengthEdges.Properties.VariableNames ={['XlowerOrEqual' num2str(boxTreshLength)],['between' num2str(boxTreshLength) 'and' num2str(2*boxTreshLength) ],['between' num2str(2*boxTreshLength) 'and' num2str(3*boxTreshLength) ],['between' num2str(3*boxTreshLength) 'and' num2str(4*boxTreshLength) ],['Xupper' num2str(4*boxTreshLength) ]};
    
    %save
    save([directory2save kindProjection '\' nameOfFolder 'summaryAverageTransitionsMeasuredIn' typeSurface '.mat'],'listAcumTransitions','meanListDataAngles','stdListDataAngles','acumAngles','acumEdgesTransition','totalAngles','totalEdgesTransition','boxTreshLength','meanListLengthEdges','stdListLengthEdges')

end

