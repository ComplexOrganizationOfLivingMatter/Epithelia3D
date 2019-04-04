%calculate area and sides

addpath(genpath('..\..\..\..\..\src'))
nDiagram = 8;
nRealizations = 20;
surfRatios = 1:0.25:5;

cellTotal = cell(1,nRealizations);
cellTotalSidesArea = cell(1,length(nRealizations));
cellTotalSidesAccumArea = cell(1,length(nRealizations));

parfor nRea = 1:nRealizations
    
    varLoad = load(['Image_' num2str(nRea) '_Diagram_' num2str(nDiagram) '\Image_' num2str(nRea) '_Diagram_' num2str(nDiagram) '.mat'],'listLOriginalProjection');
    sidesArea = [];
    sidesAccumArea = [];

    for sr = 1 : length(surfRatios)
        
        indSr = round(varLoad.listLOriginalProjection.surfaceRatio,2) == round(surfRatios(sr),2);
        L_basal = varLoad.listLOriginalProjection.L_originalProjection{indSr};
        if sr == 1
            indSr = round(varLoad.listLOriginalProjection.surfaceRatio,2) == round(max(surfRatios),2);
            L_basalMax = varLoad.listLOriginalProjection.L_originalProjection{indSr};
            noValidCells = unique([L_basalMax(1,:),L_basalMax(end,:)]);
            validCells = setdiff(unique(L_basalMax),noValidCells);
            sidesArea = validCells;
            sidesAccumArea = validCells;
            neighsAccumValidCells = cell(1,length(validCells));
        end
        
        [neighs,sidesCellsBasal]=calculateNeighbours(L_basal);
        areaCells = regionprops(L_basal,'Area');
        areaCells = cat(1,areaCells.Area);
        neighsAccum = cellfun(@(x,y) unique([x(:);y(:)]),neighsAccumValidCells,neighs(validCells),'UniformOutput',false); 

        %neighs used in next iteration
        neighsAccumValidCells = neighsAccum;
        sidesAccumValidCells = cellfun(@length, neighsAccumValidCells);

        sidesValidCells = sidesCellsBasal(validCells);
        areaValidCells = areaCells(validCells);

        sidesArea = [sidesArea,sidesValidCells',areaValidCells];
        sidesAccumArea = [sidesAccumArea,sidesAccumValidCells',areaValidCells];
    end
    cellTotalSidesArea{nRea} = sidesArea;   
    cellTotalSidesAccumArea{nRea} = sidesAccumArea;
end

totalDataBasal = vertcat(cellTotalSidesArea{:});
T = array2table(totalDataBasal);
writetable(T,'tableAreaSidesBasal.xls')
totalDataAccum = vertcat(cellTotalSidesAccumArea{:});
T = array2table(totalDataAccum);
writetable(T,'tableAreaSidesAccum.xls')

