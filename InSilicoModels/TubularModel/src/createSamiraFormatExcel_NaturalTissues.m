function [] = createSamiraFormatExcel_NaturalTissues(pathFile)
%CREATESAMIRAFORMATEXCEL_NATURALTISSUES Summary of this function goes here
%   Detailed explanation goes here
    addpath(genpath('lib'))

    %% Salivary gland
    load(pathFile);
    
    extendedImage = bwlabel(wholeImage > 0, 4);
    [neighbours, ~] = calculateNeighbours(extendedImage);
    [ verticesInfoAll ] = calculateVertices(extendedImage, neighbours);
    
    midCells = unique(extendedImage(finalImageWithValidCells>0));
    eulerNumberOfCells = regionprops(finalImageWithValidCells, 'all');
    borderCells = find([eulerNumberOfCells.EulerNumber] > 1);
    borderCellsOfNewLabels = unique(extendedImage(ismember(finalImageWithValidCells, borderCells)));
    
    noBorderCells = setdiff(midCells, borderCellsOfNewLabels);
    
    verticesInfo.verticesConnectCells = verticesInfoAll.verticesConnectCells(noBorderCells);
    verticesInfo.verticesPerCell = verticesInfoAll.verticesPerCell(noBorderCells);
    
    verticesNoValidCellsInfo.verticesConnectCells = verticesInfoAll.verticesConnectCells(borderCellsOfNewLabels);
    verticesNoValidCellsInfo.verticesPerCell = verticesInfoAll.verticesPerCell(borderCellsOfNewLabels);
    
    [samiraTableVoronoi, cellsVoronoi] = tableWithSamiraFormat(verticesInfo, verticesNoValidCellsInfo, extendedImage, L_img);
    
    samiraTableT = cell2table(samiraTableVoronoi, 'VariableNames',{'Radius', 'CellIDs', 'TipCells', 'BorderCell','verticesValues_x_y'});

    writetable(samiraTableT, strcat(dir2save, '\samirasFormat_', date, '.xls'));

end

