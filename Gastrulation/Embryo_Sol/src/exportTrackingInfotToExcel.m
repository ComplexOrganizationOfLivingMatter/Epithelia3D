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
    xlsTable = vertcat(trackingInfo.Properties.VariableNames(6:12) , table2cell(trackingInfo(:, 6:12)));
    xlswrite(strcat(resultsPath, 'noFolds_Cells_', date), xlsTable, actualFileSplitted{4});
end