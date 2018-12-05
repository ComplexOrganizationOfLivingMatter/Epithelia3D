function [] = createSamiraFormatExcel_NaturalTissues(pathFile, nameOfSimulation)
%CREATESAMIRAFORMATEXCEL_NATURALTISSUES Summary of this function goes here
%   Detailed explanation goes here
    addpath(genpath('lib'))

    maxDistance = 4;
    
    %% Salivary gland
    load(pathFile);
    
    % Calculate vertices connecting 3 cells and add them to the list
    %extendedImage = wholeImage;
    extendedImage = midSectionImage;
    [neighbours, ~] = calculateNeighbours(extendedImage);
    [ verticesInfoOf3Fold ] = calculateVertices(extendedImage, neighbours);
    
    [verticesInfoOf3Fold] = removingVeryCloseVertices(verticesInfoOf3Fold, maxDistance);
    
    %CARE!!! ALLVERTICES MAY BE UNASSIGNED
    %[allVertices] = detectVerticesOfEdges(midSectionImage, verticesInfoOf3Fold, validCellsFinal, maxDistance);


    %midCells = unique(extendedImage(finalImageWithValidCells>0));
    validCellsProp = regionprops(midSectionImage, 'EulerNumber','Centroid');
    borderCells = find([validCellsProp.EulerNumber] > 1);
    %borderCellsOfNewLabels = unique(extendedImage(ismember(finalImageWithValidCells, borderCells)));
    borderCellsOfNewLabels = borderCells;

    %noBorderCells = setdiff(midCells, borderCellsOfNewLabels);
    validCells = validCellsFinal;
    noValidCells = setdiff(1:max(wholeImage(:)), validCells);

    for numCell = validCellsFinal
        newVertices = verticesInfoOf3Fold.verticesPerCell(any(ismember(verticesInfoOf3Fold.verticesConnectCells, numCell), 2), :);
        actualVertices = vertcat(cellVertices{numCell}, newVertices{:});
        cellVertices{numCell} = unique(actualVertices, 'rows');
        
        
%         figure;
%         for numVertex = 1:size(actualVertices, 1)
%             plot(actualVertices(numVertex, 1), actualVertices(numVertex, 2), 'r+');
%             hold on;
%         end
    end
%     
%     verticesInfo.verticesConnectCells = verticesInfoOf3Fold.verticesConnectCells(noBorderCells);
%     verticesInfo.verticesPerCell = verticesInfoOf3Fold.verticesPerCell(noBorderCells);
%     
%     verticesNoValidCellsInfo.verticesConnectCells = verticesInfoOf3Fold.verticesConnectCells(borderCellsOfNewLabels);
%     verticesNoValidCellsInfo.verticesPerCell = verticesInfoOf3Fold.verticesPerCell(borderCellsOfNewLabels);

    cellVerticesNoValid = cellVertices;
    cellVerticesNoValid(validCells) = {[]};
    
    cellVerticesValid = cellVertices;
    cellVerticesValid(noValidCells) = {[]};

    ySize = size(wholeImage, 2);
    cellInfoWithVertices = groupingVerticesPerCellSurface(wholeImage(:, (ySize/3):(2*ySize/3)), cellVerticesValid, cellVerticesNoValid, [], 1, borderCells);

    cellInfoWithVertices(cellfun(@isempty, cellInfoWithVertices(:, 6)), :) = [];
    cellInfoWithVertices(cellfun(@(x) ismember(x, noValidCells), cellInfoWithVertices(:, 3)), :) = [];
    
%     figure;imshow(finalImageWithValidCells');
    [samiraTable, cellsVoronoi] = tableWithSamiraFormat(cellInfoWithVertices, cat(1,validCellsProp.Centroid), [], surfaceRatio, strsplit(pathFile, '\'), nameOfSimulation);
    
    samiraTableT = cell2table(samiraTable, 'VariableNames',{'Radius', 'CellIDs', 'TipCells', 'BorderCell','verticesValues_x_y'});

%     figure;imshow(finalImageWithValidCells');
    newCrossesTable = lookFor4cellsJunctionsAndExportTheExcel(samiraTableT);
    
    splitPath = strsplit(pathFile,{'\','/'});
   	typeOfSurface = strsplit(splitPath{end},'_');
    typeOfSurface = typeOfSurface{1};
    dir2save = fullfile(splitPath{1:end-1});
    writetable(samiraTableT, strcat(dir2save, '\',typeOfSurface,'_',nameOfSimulation,'_vertSamirasFormat_', date, '.xls'));
    writetable(newCrossesTable, strcat(dir2save, '\',typeOfSurface,'_',nameOfSimulation,'_vertCrossesSamirasFormat_', date, '.xls'));
end

