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
    imwrite(ismember(imgInitialNewLabels, trackingInfo.newLabel(logical(trackingInfo.validCell))) .* imgInitialNewLabels + 1, colorcube(size(trackingInfo, 1)+2), strcat(actualFile(1:end-4), '_imgInitial_ValidCells.bmp'));
    imwrite(ismember(imgEndNewLabels, trackingInfo.newLabel(logical(trackingInfo.validCell))) .* imgEndNewLabels + 1, colorcube(size(trackingInfo, 1)+2), strcat(actualFile(1:end-4), '_imgEnd_ValidCells.bmp'));
    
    imwrite(imgInitialNewLabels+1, colorcube(size(trackingInfo, 1)+2), strcat(actualFile(1:end-4), '_imgInitial.bmp'));
    imwrite(imgEndNewLabels+1, colorcube(size(trackingInfo, 1)+2), strcat(actualFile(1:end-4), '_imgEnd.bmp'));
    
    %Export excel
    
    trackingInfo.neighboursInitial = calculateNeighbours(imgInitialNewLabels)';
    trackingInfo.neighboursEnd = calculateNeighbours(imgEndNewLabels)';
    
    trackingInfo.AreaInitial = struct2array(regionprops(imgInitialNewLabels, 'area'))';
    trackingInfo.AreaEnd = struct2array(regionprops(imgEndNewLabels, 'area'))';
    
    trackingInfo.PerimeterInitial = struct2array(regionprops(imgInitialNewLabels, 'perimeter'))';
    trackingInfo.PerimeterEnd = struct2array(regionprops(imgEndNewLabels, 'perimeter'))';
    
    trackingInfo.regionPropsInitial = regionprops(imgInitialNewLabels, 'all');
    trackingInfo.regionPropsEnd = regionprops(imgEndNewLabels, 'all');
    
    trackingInfo.neighboursInitial = cellfun(@(x) size(x, 1), table2cell(trackingInfo(:, 7)));
    trackingInfo.neighboursEnd = cellfun(@(x) size(x, 1), table2cell(trackingInfo(:, 8)));
    
%     imshow(ismember(imgInitialNewLabels, trackingInfo.newLabel(trackingInfo.neighboursInitial ~= trackingInfo.neighboursEnd)) .* imgInitialNewLabels);
%     
%     percentageOfScutoids = sum(trackingInfo.neighboursInitial(logical(trackingInfo.validCell)) ~= trackingInfo.neighboursEnd(logical(trackingInfo.validCell))) / sum(trackingInfo.validCell)
%     percentageOfScutoids = sum(trackingInfo.neighboursInitial ~= trackingInfo.neighboursEnd) / size(trackingInfo, 1)
    %Order:
    % - Header
    % - Number of neighbours, perimeter and area of every valid cells at
    % initial and final frame
    % - Mean of every column
    % - STD of every column
    xlsTable = vertcat(trackingInfo.Properties.VariableNames(7:12) , table2cell(trackingInfo(logical(trackingInfo.validCell), 7:12)), mat2cell(mean(table2array(trackingInfo(logical(trackingInfo.validCell), 7:12))), 1, ones(6, 1)), mat2cell(std(table2array(trackingInfo(logical(trackingInfo.validCell), 7:12))), 1, ones(6, 1)));
    
    if isequal(actualFileSplitted{end-1}, 'top') || isequal(actualFileSplitted{end-1}, 'bottom')
        xlswrite(strcat(resultsPath, 'noFolds_Cells_', date), xlsTable, strcat(actualFileSplitted{4}, '_' ,actualFileSplitted{end-1}), 'C5');
    else
        xlswrite(strcat(resultsPath, 'noFolds_Cells_', date), xlsTable, actualFileSplitted{4}, 'C5');
    end
end