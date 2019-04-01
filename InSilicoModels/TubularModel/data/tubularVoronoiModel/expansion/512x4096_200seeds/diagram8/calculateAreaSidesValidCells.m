%calculate area and sides

addpath(genpath('..\..\..\..\..\src'))
nDiagram = 8;
nRealizations = 20;
surfRatios = unique([10./(1:10),1.8,1:10]);

cellTotal = cell(1,nRealizations);

parfor nRea = 1:nRealizations
    
    varLoad = load(['Image_' num2str(nRea) '_Diagram_' num2str(nDiagram) '\Image_' num2str(nRea) '_Diagram_' num2str(nDiagram) '.mat'],'listLOriginalProjection');
    sidesArea = [];
        
    for sr = 1 : length(surfRatios)
        
        indSr = round(varLoad.listLOriginalProjection.surfaceRatio,2) == round(surfRatios(sr),2);
        L_basal = varLoad.listLOriginalProjection.L_originalProjection{indSr};
        if sr == 1
            indSr = round(varLoad.listLOriginalProjection.surfaceRatio,2) == round(max(surfRatios),2);
            L_basalMax = varLoad.listLOriginalProjection.L_originalProjection{indSr};
            noValidCells = unique([L_basalMax(1,:),L_basalMax(end,:)]);
            validCells = setdiff(unique(L_basalMax),noValidCells);
            sidesArea = validCells;
        end
        
        [~,sidesCellsBasal]=calculateNeighbours(L_basal);
        areaCells = regionprops(L_basal,'Area');
        areaCells = cat(1,areaCells.Area);
        sidesValidCells = sidesCellsBasal(validCells);
        areaValidCells = areaCells(validCells);

        sidesArea = [sidesArea,sidesValidCells',areaValidCells];
        
    end
    cellTotal{nRea} = sidesArea;   

end
totalData = vertcat(cellTotal{:});
T = array2table(totalData);

writetable(T,'tableAreaSides.xls')