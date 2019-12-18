function getDelaunayAreasAccumSides(neighsAccum,neighsValidCells,folder2save,voronoiNumber,surfRatios,nRealizations,dataDirection)

    folderExcel = ['..\..\InSilicoModels\TubularModel\data\tubularVoronoiModel\expansion\512x4096_200seeds\diagram' num2str(voronoiNumber) '_Markov\verticesSamira\'];
    cellTotalSidesAccumArea = cell(1,nRealizations);
    cellTotalSidesArea = cell(1,nRealizations);

for nRea = 1:nRealizations
    
    nameExcel = ['Voronoi_realization' num2str(nRea) '_samirasFormat_26-Nov-2019.xls'];
    tableVertices = readtable([folderExcel nameExcel]);
    
    noValidCells = unique(tableVertices.CellIDs(tableVertices.TipCells>0));
    validCells = setdiff(unique(tableVertices.CellIDs(:)),noValidCells);
    
    srOfInterest = ismember(tableVertices.Radius,surfRatios);
    tableVertices = tableVertices(srOfInterest,:);

    tableVerticesValidCells = tableVertices(ismember(tableVertices.CellIDs,validCells),:);
    tableVerticesValidCells(ismember(tableVerticesValidCells.BorderCell,2),:) = [];

    sidesAccumArea = [];
    sidesArea = [];
    for sr = 1 : length(surfRatios)
        
        if sr == 1
            sidesAccumArea = validCells;
            sidesArea = validCells;
        end
        
        areaCells = zeros(size(validCells));
        tableSR = tableVerticesValidCells(tableVerticesValidCells.Radius==surfRatios(sr),:);

        for nCell = 1:length(validCells)
            verticesCell = table2array(tableSR(tableSR.CellIDs==validCells(nCell),5:end));
            verticesCell = verticesCell(~isnan(verticesCell));
            areaCells(nCell) = polyarea(verticesCell(1:2:end-1),verticesCell(2:2:end));
        end
        
        %neighs used in next iteration
        neighsAccumValidCells = neighsAccum{nRea,sr};
        sidesAccumValidCells = cellfun(@length, neighsAccumValidCells);

        sidesValidCells = neighsValidCells{nRea,sr};
        
        sidesAccumArea = [sidesAccumArea,sidesAccumValidCells',areaCells];
        sidesArea = [sidesArea,sidesValidCells',areaCells];
    end
    cellTotalSidesAccumArea{nRea} = sidesAccumArea;
    cellTotalSidesArea{nRea} = sidesArea;

end

totalDataAccum = vertcat(cellTotalSidesAccumArea{:});
T = array2table(totalDataAccum);
% writetable(T,[folder2save 'tableAreaSidesAccum_Voronoi_' num2str(voronoiNumber) '_' dataDirection '.xls'])

totalDataSides = vertcat(cellTotalSidesArea{:});
T2 = array2table(totalDataSides);
writetable(T2,[folder2save 'tableAreaSides_Voronoi_' num2str(voronoiNumber) '_' dataDirection '.xls'])