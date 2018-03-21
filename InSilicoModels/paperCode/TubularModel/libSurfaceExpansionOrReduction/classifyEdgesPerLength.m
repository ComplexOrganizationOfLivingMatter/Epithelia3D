function [meanListLengthEdges,stdListLengthEdges]=classifyEdgesPerLength(totalEdgesTransition,totalEdgesNoTransition,listAcumTransitions)

    totalEdgesPerImage=cellfun(@(x,y) sort([x;y]),totalEdgesTransition,totalEdgesNoTransition,'UniformOutput',false);
    %normalize measured edges in basal by expansion ratio
    listOfSurfaceRatios=listAcumTransitions.apicalReduction;
%     proportionEdges=cell(size(totalEdgesTransition,1),size(totalEdgesTransition,2));
    for i=2:size(totalEdgesPerImage,1)
        allEdgesPerSurfaceRatio=sort(vertcat(totalEdgesPerImage{i,:}));
        allEdgesPerSurfaceRatio(allEdgesPerSurfaceRatio>(3*mean(allEdgesPerSurfaceRatio)))=[];
        perc20=prctile(allEdgesPerSurfaceRatio,20);
        perc40=prctile(allEdgesPerSurfaceRatio,40);
        perc60=prctile(allEdgesPerSurfaceRatio,60);
        perc80=prctile(allEdgesPerSurfaceRatio,80);
        proportionEdges(i,:)=cellfun(@(x) [sum(x<=perc20),sum(x<=perc40 & x>perc20),sum(x<=perc60 & x>perc40),sum(x<=perc80 & x>perc60),sum(x>perc80)]/length(x),totalEdgesTransition(i,:),'UniformOutput',false);    
    end
    
    
    meanListLengthEdges=zeros(length(listOfSurfaceRatios),5);
    stdListLengthEdges=zeros(length(listOfSurfaceRatios),5);
    for i=1:length(listOfSurfaceRatios)
        proportions=cat(1,proportionEdges{i,:});
        proportions(isnan(proportions))=0;
        meanListLengthEdges(i,:)=mean(proportions)/sum(mean(proportions));
        stdListLengthEdges(i,:)=std(proportions);
    end
    meanListLengthEdges=array2table(meanListLengthEdges);
    stdListLengthEdges=array2table(stdListLengthEdges);
    meanListLengthEdges.Properties.VariableNames ={'firstBox','secondBox','thirdBox','fourthBox','fifthBox'};
    stdListLengthEdges.Properties.VariableNames ={'firstBox','secondBox','thirdBox','fourthBox','fifthBox'};
end