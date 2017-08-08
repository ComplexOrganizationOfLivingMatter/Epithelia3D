%normalize measured edges in basal by expansion ratio

load('D:\Pedro\Epithelia3D\Salivary Glands\Curvature model\data\expansion\512x1024_400seeds\summaryAverageTransitionsMeasuredInbasal.mat','totalEdgesTransition','listAcumTransitions')

listOfSurfaceRatios=listAcumTransitions.apicalReduction;
totalEdgesTransitionNormalized=cell(size(totalEdgesTransition,1),size(totalEdgesTransition,2));
for i=1:size(totalEdgesTransition,1)
    for j=1:size(totalEdgesTransition,2)
        totalEdgesTransitionNormalized{i,j}=totalEdgesTransition{i,j}/listOfSurfaceRatios(i);
    end
end



boxTreshLength=round(max(vertcat(totalEdgesTransitionNormalized{:,:}))/5)-1;
proportionEdges=cellfun(@(x) [sum(x<=boxTreshLength),sum(x<=2*boxTreshLength & x>boxTreshLength),sum(x<=3*boxTreshLength & x>2*boxTreshLength),sum(x<=4*boxTreshLength & x>3*boxTreshLength),sum(x>4*boxTreshLength)]/length(x),totalEdgesTransitionNormalized,'UniformOutput',false);
    
meanListLengthEdges=zeros(length(listOfSurfaceRatios),5);
stdListLengthEdges=zeros(length(listOfSurfaceRatios),5);
for i=1:length(listOfSurfaceRatios)
    meanListLengthEdges(i,:)=mean(cat(1,proportionEdges{i,:}));
    stdListLengthEdges(i,:)=std(cat(1,proportionEdges{i,:}));
end
meanListLengthEdges=array2table(meanListLengthEdges);
stdListLengthEdges=array2table(stdListLengthEdges);
meanListLengthEdges.Properties.VariableNames ={['XlowerOrEqual' num2str(boxTreshLength)],['between' num2str(boxTreshLength) 'and' num2str(2*boxTreshLength) ],['between' num2str(2*boxTreshLength) 'and' num2str(3*boxTreshLength) ],['between' num2str(3*boxTreshLength) 'and' num2str(4*boxTreshLength) ],['Xupper' num2str(4*boxTreshLength) ]};
stdListLengthEdges.Properties.VariableNames ={['XlowerOrEqual' num2str(boxTreshLength)],['between' num2str(boxTreshLength) 'and' num2str(2*boxTreshLength) ],['between' num2str(2*boxTreshLength) 'and' num2str(3*boxTreshLength) ],['between' num2str(3*boxTreshLength) 'and' num2str(4*boxTreshLength) ],['Xupper' num2str(4*boxTreshLength) ]};
