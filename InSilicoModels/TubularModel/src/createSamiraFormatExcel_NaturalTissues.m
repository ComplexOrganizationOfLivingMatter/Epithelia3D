function [] = createSamiraFormatExcel_NaturalTissues(pathFile)
%CREATESAMIRAFORMATEXCEL_NATURALTISSUES Summary of this function goes here
%   Detailed explanation goes here
    addpath(genpath('lib'))

    %% Salivary gland
    load(pathFile);
    
    midSectionImgToCalculateCorners = midSectionImage == 0;
    corners = detectHarrisFeatures(midSectionImgToCalculateCorners, 'FilterSize', 3, 'MinQuality', 0.01);
    corners = corners.selectUniform(9*length(validCellsFinal), size(midSectionImgToCalculateCorners));
%     figure;imshow(midSectionImgToCalculateCorners); hold on;
%     plot(corners.selectUniform(9*length(validCellsFinal), size(midSectionImgToCalculateCorners)));

    %We found the closest white pixels to the pixels we found in black
    [whitePixelsY, whitePixelsX] = find(midSectionImgToCalculateCorners);
    whitePixelsY = single(whitePixelsY);
    whitePixelsX = single(whitePixelsX);
    se = strel('disk', 3);
    imgToDilate = zeros(size(midSectionImgToCalculateCorners));
    for numVertexCells = 1:corners.Count
        %hold on; plot(corners.Location(numVertexCells, 1), corners.Location(numVertexCells, 2), 'r+');
        if midSectionImgToCalculateCorners(round(corners.Location(numVertexCells, 2)), round(corners.Location(numVertexCells, 1))) == 0
            [~, minDistanceIndex] = pdist2([whitePixelsY, whitePixelsX], round([corners.Location(numVertexCells, 2), corners.Location(numVertexCells, 1)]),'euclidean', 'Smallest', 1);
            corners.Location(numVertexCells, :) = [whitePixelsX(minDistanceIndex), whitePixelsY(minDistanceIndex)];
        else
            corners.Location(numVertexCells, :) = round(corners.Location(numVertexCells, :));
        end
        
        imgToDilate(corners.Location(numVertexCells, 2), corners.Location(numVertexCells, 1)) = 1;
        imdilate(imgToDilate, se);
        
        
        imgToDilate(corners.Location(numVertexCells, 2), corners.Location(numVertexCells, 1)) = 0;
    end

%     figure;imshow(midSectionImgToCalculateCorners); hold on;
%     plot(corners);
    
    % Calculate vertices connecting 3 cells and add them to the list
    [neighbours, ~] = calculateNeighbours(extendedImage);
    [ verticesInfoAll ] = calculateVertices(extendedImage, neighbours);
    
    %midCells = unique(extendedImage(finalImageWithValidCells>0));
    eulerNumberOfCells = regionprops(finalImageWithValidCells, 'all');
    borderCells = find([eulerNumberOfCells.EulerNumber] > 1);
    %borderCellsOfNewLabels = unique(extendedImage(ismember(finalImageWithValidCells, borderCells)));
    borderCellsOfNewLabels = borderCells;
    
    %noBorderCells = setdiff(midCells, borderCellsOfNewLabels);
    noBorderCells = validCellsFinal;
    
    verticesInfo.verticesConnectCells = verticesInfoAll.verticesConnectCells(noBorderCells);
    verticesInfo.verticesPerCell = verticesInfoAll.verticesPerCell(noBorderCells);
    
    verticesNoValidCellsInfo.verticesConnectCells = verticesInfoAll.verticesConnectCells(borderCellsOfNewLabels);
    verticesNoValidCellsInfo.verticesPerCell = verticesInfoAll.verticesPerCell(borderCellsOfNewLabels);
    
    [samiraTableVoronoi, cellsVoronoi] = tableWithSamiraFormat(verticesInfo, verticesNoValidCellsInfo, extendedImage, finalImageWithValidCells);
    
    samiraTableT = cell2table(samiraTableVoronoi, 'VariableNames',{'Radius', 'CellIDs', 'TipCells', 'BorderCell','verticesValues_x_y'});

    writetable(samiraTableT, strcat(dir2save, '\samirasFormat_', date, '.xls'));

end

