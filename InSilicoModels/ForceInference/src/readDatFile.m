function [forceInferenceValue] = readDatFile( fileName, correspondingImage )
%READDATFILE Summary of this function goes here
%   Detailed explanation goes here

    fileID = fopen(fileName);

    rowFile = fgetl(fileID);
    rowFile = fgetl(fileID);
    
    edgesTensions = true;
    cellInfo = [];
    edgeInfo = [];
    
    imgLabelled = bwlabel(correspondingImage);
    
    [neighbours, sideCells] = calculateNeighbours(imgLabelled);
    [ verticesInfo ] = calculateVertices( imgLabelled, neighbours);
    allVertices = vertcat(verticesInfo.verticesPerCell{:});
    
    %emptyImage = zeros(size(imgLabelled));
    %dilateShape = strel('disk', 6);
    
    while ischar(rowFile)
        
        if isempty(rowFile) == 0
            lineSplitted = strsplit(rowFile);
            if isempty(lineSplitted{1})
                lineSplitted(1) = [];
            end

            if edgesTensions %Tension of the edges
                vertex1_X = lineSplitted{5};
                vertex1_Y = lineSplitted{6};
                vertex2_X = lineSplitted{7};
                vertex2_Y = lineSplitted{8};
                %Id of edge
                edgeInfo(end+1, 1:2) = [str2double(vertex1_X(2:end)), str2double(vertex1_Y(1:end-1))];
                edgeInfo(end, 3:4) = [str2double(vertex2_X(2:end)), str2double(vertex2_Y(1:end-1))];
                edgeInfo(end, 5) = str2double(lineSplitted{2});
                
                %First we should do a correspondance with the real vertices
                %of frusta
                [~, indexV1] = pdist2(allVertices, edgeInfo(end, [2 1]), 'Euclidean', 'Smallest',1);
                [~, indexV2] = pdist2(allVertices, edgeInfo(end, [4 3]), 'Euclidean', 'Smallest', 1);
                %realVertex1 = allVertices(indexV1, :);
                %realVertex2 = allVertices(indexV2, :);
                
                neighboursVertex1 = verticesInfo.verticesConnectCells(indexV1, :);
                neighboursVertex2 = verticesInfo.verticesConnectCells(indexV2, :);
                
%                 %Associate this edge with its cells
%                 emptyImage(edgeInfo(end, 2), edgeInfo(end, 1)) = 1;
%                 neighboursVertex1 = unique(imgLabelled.*imdilate(emptyImage, dilateShape));
%                 emptyImage(edgeInfo(end, 2), edgeInfo(end, 1)) = 0;
%                 
%                 emptyImage(edgeInfo(end, 4), edgeInfo(end, 3)) = 1;
%                 neighboursVertex2 = unique(imgLabelled.*imdilate(emptyImage, dilateShape));
%                 emptyImage(edgeInfo(end, 4), edgeInfo(end, 3)) = 0;
%                 
                cellsOfTheEdge = intersect(neighboursVertex1, neighboursVertex2);
                cellsOfTheEdge(cellsOfTheEdge == 0) = [];
                if length(cellsOfTheEdge) == 2
                    edgeInfo(end, 6:7) = cellsOfTheEdge;
%                 else
%                     disp('Warning! Three cells');
%                     edgeInfo(end, 6:8) = cellsOfTheEdge;
                end
            else %Cell preassure
                cellInfo(end+1, :) = [str2double(lineSplitted{3}), str2double(lineSplitted{4})];
                cellInfo
            end
        elseif edgesTensions == true
            edgesTensions = false;
            edgeInfo = array2table(edgeInfo, 'VariableNames',{'vertex1_X', 'vertex1_Y', 'vertex2_X', 'vertex2_Y', 'TensionValue', 'ConnectingCell1', 'ConnectingCell2'});
        end
        
        rowFile = fgetl(fileID);
    end
    
    fclose(fileID);
    
    for numCell = 1:size(cellInfo, 1)
         actualTensionValues = edgeInfo.TensionValue(edgeInfo.ConnectingCell1 == numCell | edgeInfo.ConnectingCell2 == numCell);
         cellInfo(numCell, 3) = mean(actualTensionValues);
         cellInfo(numCell, 4) = std(actualTensionValues);
         cellInfo(numCell, 5) = length(actualTensionValues);
         cellInfo(numCell, 6) = sideCells(numCell);
    end
    
    
    [correlation, pvalue] = corrcoef(cellInfo(:, 2:5), 'Rows', 'pairwise');
    forceInferenceValue = array2table(cellInfo, 'VariableNames', {'CellID', 'PressureValue', 'MeanTension', 'STDTension', 'NumEdgesOfTension', 'RealSides'});
    
    
end

