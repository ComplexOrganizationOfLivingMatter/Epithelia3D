dirSalivaryVerticesTable = dir('E:\Pedro\LimeSeg_Pipeline\data\Salivary gland\Wildtype\**\*_samirasFormat.xls');

folder2savePerim = 'perimData/';
folder2saveArea = 'areaData/';
mkdir(folder2savePerim)
mkdir(folder2saveArea)

surfRatios =  [1,1.4167,1.8334,2.25,2.6668,3.0835,3.5];  
nRealizations = 20;
    
cellTotalSidesPerim = cell(1,nRealizations);
cellTotalSidesArea = cell(1,nRealizations);
for nRea = 1:nRealizations
    dirExcel = fullfile(dirSalivaryVerticesTable(nRea).folder,dirSalivaryVerticesTable(nRea).name);
    tableVertices = readtable(dirExcel);

    noValidCells = unique(tableVertices.CellIDs(tableVertices.TipCells>0));
    
    validCells = setdiff(unique(tableVertices.CellIDs(:)),unique(noValidCells));

    srOfInterest = ismember(round(tableVertices.Radius,2),round(surfRatios,2));
    tableVertices = tableVertices(srOfInterest,:);

    tableVerticesValidCells = tableVertices(ismember(tableVertices.CellIDs,validCells),:);
%     tableVerticesValidCells(tableVerticesValidCells.BorderCell>0,:) = [];

    for sr = 1 : length(surfRatios)
        if sr == 1
            listPerimCells = [validCells,zeros(length(validCells),length(surfRatios))];
            listAreaCells = [validCells,zeros(length(validCells),length(surfRatios))];
        end
        
        perimCells = zeros(size(validCells));
        areaCells = zeros(size(validCells));
        tableSR = tableVerticesValidCells(round(tableVerticesValidCells.Radius,2)==round(surfRatios(sr),2),:);

        borderCells = unique(tableSR.CellIDs(tableSR.BorderCell>0));
        borderCells = setdiff(borderCells,noValidCells);
        
        for nCell = 1:length(validCells)
            verticesCell = table2array(tableSR(tableSR.CellIDs==validCells(nCell),5:end));
            if any(ismember(validCells(nCell),borderCells))
                verticesCell1 = verticesCell(1,~isnan(verticesCell(1,:)));
                verticesCell2 = verticesCell(2,~isnan(verticesCell(2,:)));
                polShape1 = polyshape(verticesCell1(1,1:2:end-1),verticesCell1(1,2:2:end));
                polShape2 = polyshape(verticesCell2(1,1:2:end-1),verticesCell2(1,2:2:end));
                perimCells(nCell) = mean([perimeter(polShape1),perimeter(polShape2)]);
                areaCells(nCell) = mean([area(polShape1),area(polShape2)]);
            else
                verticesCell = verticesCell(~isnan(verticesCell));
                polShape = polyshape(verticesCell(1:2:end-1),verticesCell(2:2:end));
                perimCells(nCell) = perimeter(polShape);
                areaCells(nCell) = area(polShape);
            end
        end

        listPerimCells(:,sr+1) = perimCells;
        listAreaCells(:,sr+1) = areaCells;
    end
    cellTotalSidesPerim{nRea} = listPerimCells;
    cellTotalSidesArea{nRea} = listAreaCells;
    

end
totalDataPerim = vertcat(cellTotalSidesPerim{:});
totalDataArea = vertcat(cellTotalSidesArea{:});

T_perim = array2table(totalDataPerim);
T_area = array2table(totalDataArea);
writetable(T_perim,[folder2savePerim 'tablePerim_salivaryGlands.xls'])
writetable(T_area,[folder2saveArea 'tableArea_salivaryGlands.xls'])
    


