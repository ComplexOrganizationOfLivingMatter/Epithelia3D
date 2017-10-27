%% Process all the trackinInfo files and export it as excel file

resultsPath = '..\results\NoFolds\';
noFoldsFiles = getAllFiles(resultsPath);
trackingFilesLocation = cellfun(@(x) isempty(strfind(x, 'trackingInfo')) == 0 & isempty(strfind(x, '.mat')) == 0, noFoldsFiles);
trackingFiles = noFoldsFiles(trackingFilesLocation);

for numFile = 1:size(trackingFiles, 1)
    actualFile = trackingFiles{numFile};
    strcat(actualFile(1:end-4), '_imgInitial')
    actualFileSplitted = strsplit(actualFile, '\');
    load(actualFile);
    %Write imgs with valid cells
    imwrite(ismember(imgInitialNewLabels, trackingInfo.newLabel(logical(trackingInfo.validCell))) .* imgInitialNewLabels, colorcube(size(trackingInfo, 1)), strcat(actualFile(1:end-4), '_imgInitial_ValidCells.bmp'));
    imwrite(ismember(imgEndNewLabels, trackingInfo.newLabel(logical(trackingInfo.validCell))) .* imgEndNewLabels, colorcube(size(trackingInfo, 1)), strcat(actualFile(1:end-4), '_imgEnd_ValidCells.bmp'));
    
    %Export excel
    trackingInfo.neighboursInitial = cellfun(@(x) size(x, 1), table2cell(trackingInfo(:, 7)));
    trackingInfo.neighboursEnd = cellfun(@(x) size(x, 1), table2cell(trackingInfo(:, 8)));
    %Order:
    % - Header
    % - Number of neighbours, perimeter and area of every valid cells at
    % initial and final frame
    % - Mean of every column
    % - STD of every column
    xlsTable = vertcat(trackingInfo.Properties.VariableNames(7:12) , table2cell(trackingInfo(logical(trackingInfo.validCell), 7:12)), mat2cell(mean(table2array(trackingInfo(logical(trackingInfo.validCell), 7:12))), 1, ones(6, 1)), mat2cell(std(table2array(trackingInfo(logical(trackingInfo.validCell), 7:12))), 1, ones(6, 1)));
    
    xlswrite(strcat(resultsPath, 'noFolds_Cells_', date), xlsTable, actualFileSplitted{4}, 'C5');
end