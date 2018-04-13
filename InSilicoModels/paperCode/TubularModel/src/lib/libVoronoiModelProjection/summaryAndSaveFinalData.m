function summaryAndSaveFinalData(listOfSurfaceRatios,acumListDataAngles,totalEdgesTransition,totalEdgesNoTransition,totalAngles,directory2save,kindProjection,nameOfFolder,typeSurface)
    
    acumListDataAngles=cat(3,acumListDataAngles{:});
    acumListDataAngles(isnan(acumListDataAngles))=0;
    meanListDataAngles=array2table(mean(acumListDataAngles,3));
    stdListDataAngles=array2table(std(acumListDataAngles,[],3));
    meanListDataAngles.Properties.VariableNames ={'numOfEdgesOfTransition','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};
    stdListDataAngles.Properties.VariableNames ={'numOfEdgesOfTransition','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};

    
    acumAngles=cell(length(listOfSurfaceRatios),1);
    acumEdges=cell(length(listOfSurfaceRatios),1);
    for i=1:length(listOfSurfaceRatios)
        acumAngles{i}=cat(1,totalAngles{i,:});
        acumEdges{i}=cat(1,totalEdgesTransition{i,:});
    end
    
    %Normalize edges only in basal
    [meanListLengthEdges,stdListLengthEdges]=classifyEdgesPerLength(totalEdgesTransition,totalEdgesNoTransition,listOfSurfaceRatios);
        
    %save
    save([directory2save kindProjection '\' nameOfFolder 'edgeLengthAngleMeasuredIn' typeSurface '_' date '.mat'],'meanListDataAngles','stdListDataAngles','acumAngles','acumEdges','totalAngles','totalEdgesTransition','totalEdgesTransition','meanListLengthEdges','stdListLengthEdges')

end

