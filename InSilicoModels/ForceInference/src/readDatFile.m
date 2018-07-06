function [forceInferenceInfo] = readDatFile( fileName, correspondingImage )
%READDATFILE Summary of this function goes here
%   Detailed explanation goes here

    fileID = fopen(fileName);

    rowFile = fgetl(fileID);
    rowFile = fgetl(fileID);
    
    edgesTensions = true;
    cellInfo = [];
    edgeInfo = [];
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
            else %Cell preassure
                cellInfo(end+1, :) = [str2double(lineSplitted{3}), str2double(lineSplitted{4})];
            end
        else
            edgesTensions = false;
            edgeInfo = array2table(edgeInfo, 'VariableNames',{'vertex1_X', 'vertex1_Y', 'vertex2_X', 'vertex2_Y', 'TensionValue'});
        end
        
        rowFile = fgetl(fileID);
    end
    cellInfo = array2table(cellInfo, 'VariableNames', {'CellID', 'PressureValue'});
    fclose(fileID);
    
    imgLabelled = bwlabel(correspondingImage);
    
end

