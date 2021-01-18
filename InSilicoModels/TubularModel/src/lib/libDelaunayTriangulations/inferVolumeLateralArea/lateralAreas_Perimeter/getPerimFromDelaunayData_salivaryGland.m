dirSalivaryVerticesTable = dir('E:\Pedro\LimeSeg_Pipeline\data\Salivary gland\Wildtype\**\*_samirasFormat.xls');

folder2save = 'perimData/';
surfRatios =  [1,1.4167,1.8334,2.25,2.6668,3.0835,3.5];  
nRealizations = 20;
    
cellTotalSidesPerim = cell(1,nRealizations);
cellTotalSidesPerim2 = cell(1,nRealizations);
for nRea = 1:nRealizations
    dirExcel = fullfile(dirSalivaryVerticesTable(nRea).folder,dirSalivaryVerticesTable(nRea).name);
    tableVertices = readtable(dirExcel);

    noValidCells = unique(tableVertices.CellIDs(tableVertices.TipCells>0));
    borderCells = unique(tableVertices.CellIDs(tableVertices.BorderCell>0));

    validCells = setdiff(unique(tableVertices.CellIDs(:)),unique([borderCells,noValidCells]));

    srOfInterest = ismember(round(tableVertices.Radius,2),round(surfRatios,2));
    tableVertices = tableVertices(srOfInterest,:);

    tableVerticesValidCells = tableVertices(ismember(tableVertices.CellIDs,validCells),:);
    tableVerticesValidCells(tableVerticesValidCells.BorderCell>0,:) = [];

    for sr = 1 : length(surfRatios)
        if sr == 1
            listPerimCells = [(1:length(validCells))',zeros(length(validCells),length(surfRatios))];
            listPerim2Cells = [(1:length(validCells))',zeros(length(validCells),length(surfRatios))];

        end

        perimCells = zeros(size(validCells));
        tableSR = tableVerticesValidCells(round(tableVerticesValidCells.Radius,2)==round(surfRatios(sr),2),:);

        for nCell = 1:length(validCells)
            verticesCell = table2array(tableSR(tableSR.CellIDs==validCells(nCell),5:end));
            verticesCell = verticesCell(~isnan(verticesCell));
            polShape = polyshape(verticesCell(1:2:end-1),verticesCell(2:2:end));
            perimCells(nCell) = perimeter(polShape);
        end

        listPerim2Cells(:,sr+1) = perimCells.^2;
        listPerimCells(:,sr+1) = perimCells;
    end
    cellTotalSidesPerim2{nRea} = listPerim2Cells;
    cellTotalSidesPerim{nRea} = listPerimCells;
end
totalDataPerim = vertcat(cellTotalSidesPerim{:});
T = array2table(totalDataPerim);
writetable(T,[folder2save 'tablePerim_salivaryGlands.xls'])

totalDataPerim2 = vertcat(cellTotalSidesPerim2{:});
T2 = array2table(totalDataPerim2);
writetable(T2,[folder2save 'tablePerim^2_salivaryGlands.xls'])    


