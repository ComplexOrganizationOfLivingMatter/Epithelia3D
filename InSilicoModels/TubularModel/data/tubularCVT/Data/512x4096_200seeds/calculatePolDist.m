%calculate polygon distribution

addpath(genpath('..\..\..\..\src'))
nDiagram = 9;
nRealizations = 20;

polygonDis = cell(1,nRealizations);
logNormArea = cell(1,nRealizations);
totalSidesCells = cell(1,nRealizations);
normArea = cell(1,nRealizations);
for nRea = 1:nRealizations
    
    load(['Image_' num2str(nRea) '_Diagram_' num2str(nDiagram) '.mat'])
    
    [~,sidesCells]=calculateNeighbours(L_original);
    
    polygonDisImg = calculate_polygon_distribution(sidesCells,valid_cells);
    polygonDis{nRea} = polygonDisImg(2,:);
    
    
    areaCells = regionprops(L_original,'Area');
    areaCells = cat(1,areaCells.Area);
    areaValidCells = areaCells(valid_cells);
    logNormArea{nRea} = log10(areaValidCells./(mean(areaValidCells)));
    normArea{nRea} = areaValidCells./(mean(areaValidCells));
    totalSidesCells{nRea} = sidesCells(valid_cells);

end

polyDist = cell2mat(vertcat(polygonDis{:}));
meanPolyDist = mean(polyDist);
stdPolyDist = std(polyDist);
dispersionLogNormArea = vertcat(logNormArea{:});
dispersionNormArea = vertcat(normArea{:});

relationNormArea_numSides = [horzcat(totalSidesCells{:})',dispersionNormArea];
uniqSides = unique(horzcat(totalSidesCells{:}));
lewis_NormArea = [uniqSides;arrayfun(@(x) mean(relationNormArea_numSides(ismember(relationNormArea_numSides(:,1),x),2)),uniqSides);
    arrayfun(@(x) std(relationNormArea_numSides(ismember(relationNormArea_numSides(:,1),x),2)),uniqSides)];


save(['polygonDistribution_diag_' num2str(nDiagram) '.mat'],'meanPolyDist','stdPolyDist','polyDist','dispersionLogNormArea','dispersionNormArea','lewis_NormArea')


