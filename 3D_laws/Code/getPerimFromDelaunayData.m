folder2save = '..\delaunayData\geometryMeasurementsVoronoiTubes\perimeters\';
mkdir(folder2save)

surfRatios = 1:0.25:10;
voronoiNumber = 1:10;
nRealizations = 20;
for nVor = voronoiNumber

    folderExcel = ['..\InSilicoModels\TubularModel\data\tubularVoronoiModel\expansion\512x4096_200seeds\diagram' num2str(nVor) '_Markov\verticesSamira\'];
    cellTotalSidesPerim = cell(1,nRealizations);
    cellTotalSidesPerim2 = cell(1,nRealizations);
    for nRea = 1:nRealizations

        nameExcel = ['Voronoi_realization' num2str(nRea) '_samirasFormat_26-Nov-2019.xls'];
        tableVertices = readtable([folderExcel nameExcel]);

        noValidCells = unique(tableVertices.CellIDs(tableVertices.TipCells>0));
        validCells = setdiff(unique(tableVertices.CellIDs(:)),noValidCells);

        srOfInterest = ismember(tableVertices.Radius,surfRatios);
        tableVertices = tableVertices(srOfInterest,:);

        tableVerticesValidCells = tableVertices(ismember(tableVertices.CellIDs,validCells),:);
        tableVerticesValidCells(ismember(tableVerticesValidCells.BorderCell,2),:) = [];

        for sr = 1 : length(surfRatios)
            if sr == 1
                listPerimCells = [(1:length(validCells))',zeros(length(validCells),length(surfRatios))];
                listPerim2Cells = [(1:length(validCells))',zeros(length(validCells),length(surfRatios))];
            end

            perimCells = zeros(size(validCells));
            tableSR = tableVerticesValidCells(tableVerticesValidCells.Radius==surfRatios(sr),:);

            for nCell = 1:length(validCells)
                verticesCell = table2array(tableSR(tableSR.CellIDs==validCells(nCell),5:end));
                verticesCell = verticesCell(~isnan(verticesCell));
                polShape = polyshape(verticesCell(1:2:end-1),verticesCell(2:2:end));
                perimCells(nCell) = perimeter(polShape);
            end
            listPerimCells(:,sr+1) = perimCells;
            listPerim2Cells(:,sr+1) = perimCells.^2;
        end
        cellTotalSidesPerim{nRea} = listPerimCells;
        cellTotalSidesPerim2{nRea} = listPerim2Cells;

    end
    totalDataPerim = vertcat(cellTotalSidesPerim{:});
    T = array2table(totalDataPerim);
    writetable(T,[folder2save 'tablePerim_Voronoi_' num2str(nVor) '.xls'])
    
    totalDataPerim2 = vertcat(cellTotalSidesPerim2{:});
    T2 = array2table(totalDataPerim2);
    writetable(T2,[folder2save 'tablePerim^2_Voronoi_' num2str(nVor) '.xls'])
    
end


