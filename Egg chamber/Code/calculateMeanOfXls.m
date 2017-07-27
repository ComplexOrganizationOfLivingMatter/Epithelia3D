function [ ] = calculateMeanOfXls( nameXlsFile )
%CALCULATEMEANOFXLS Summary of this function goes here
%   Detailed explanation goes here

    transitionsTable = readtable(nameXlsFile);
    uniqueXRadius = unique(transitionsTable.xRadius);
    meanTable = [];
    for numX = 1:size(uniqueXRadius, 1)
        tableActualX = transitionsTable(transitionsTable.xRadius == uniqueXRadius(numX), :);
        uniqueYRadius = unique(tableActualX.yRadius);
        for numY = 1:size(uniqueYRadius, 1)
            tableActualXAndY = tableActualX(tableActualX.yRadius == uniqueYRadius(numY), :);
            uniqueCellHeight = unique(tableActualXAndY.cellHeight);
            for numHeight = 1:size(uniqueCellHeight, 1)
                tableActualX_YAndHeight = tableActualXAndY(tableActualXAndY.cellHeight == uniqueCellHeight(numHeight), :);
                tableActualAux = [tableActualX_YAndHeight{:, :}];
                meanTable(end+1, :) = mean(isfinite(tableActualX_YAndHeight{:, :}), 1);
                for numCol = 1:size(tableActualAux, 2)
                    meanTable(end, numCol) = mean(tableActualAux(isfinite(tableActualAux(:, numCol)), numCol));
                end
            end
        end
    end
    writetable(array2table(meanTable, 'VariableNames', transitionsTable.Properties.VariableNames), strcat('..\results\meanTransitionsInfo_', date, '.xlsx'))

end

