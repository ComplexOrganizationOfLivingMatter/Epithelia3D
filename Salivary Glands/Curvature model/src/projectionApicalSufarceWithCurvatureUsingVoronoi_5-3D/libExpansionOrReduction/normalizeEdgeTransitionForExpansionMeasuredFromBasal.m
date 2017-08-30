%normalize measured edges in basal by expansion ratio

load('D:\Pedro\Epithelia3D\Salivary Glands\Curvature model\data\expansion\512x1024_400seeds\summaryAverageTransitionsMeasuredInbasal_Transitions.mat','totalEdges','listAcumTransitions')

listOfSurfaceRatios=listAcumTransitions.apicalReduction;
totalEdgesNormalized=cell(size(totalEdges,1),size(totalEdges,2));
for i=1:size(totalEdges,1)
    for j=1:size(totalEdges,2)
        totalEdgesNormalized{i,j}=totalEdges{i,j}/listOfSurfaceRatios(i);
    end
end

allEdges=vertcat(totalEdgesNormalized{:,:});
allEdges=allEdges(allEdges<150);

boxTreshLength=round(max(allEdges)/5)-1;
proportionEdges=cellfun(@(x) [sum(x<=boxTreshLength),sum(x<=2*boxTreshLength & x>boxTreshLength),sum(x<=3*boxTreshLength & x>2*boxTreshLength),sum(x<=4*boxTreshLength & x>3*boxTreshLength),sum(x>4*boxTreshLength)]/length(x),totalEdgesNormalized,'UniformOutput',false);
    
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
