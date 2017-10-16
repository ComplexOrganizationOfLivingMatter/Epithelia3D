function [ trackingInfo ] = trackingCells(imgInitial, imgEnd)
%TRACKINGCELLS Summary of this function goes here
%   Detailed explanation goes here

    imgInitial =  bwareaopen( 1 - imgInitial(:, :, 1), 10);
    imgEnd =  bwareaopen(1 - imgEnd(:, :, 1), 10);

    imgEnd = bwareaopen(1 - imgEnd, 10);
    imgInitial =  bwareaopen( 1 - imgInitial, 10);

    imgInitialWts = double(watershed(imgInitial));
    imgEndWts = double(watershed(imgEnd));

    fig = figure;
    axInitial = subplot(1,2,1); imshow(imgInitialWts), title ('Initial Image')
    axEnd = subplot(1,2,2); imshow(imgEndWts), title('End Image')

    trackingInfo = {};

    finished = false;
    while finished == false
        disp('Select cell at Initial image');
        [x, y] = getpts(axInitial);
        idCellInit = imgInitialWts(round(y), round(x));
        [xCentroid, yCentroid] = find(imgInitialWts == idCellInit);
        centroidCell = round(mean([xCentroid, yCentroid]));
        hold on;
        hPlot = plot(axInitial, centroidCell(2), centroidCell(1), '*');

        pixelsInit = [xCentroid, yCentroid];

        disp('Select the correponding cell at End Image');
        [x, y] = getpts(axEnd);
        idCellEnd = imgEndWts(round(y), round(x));
        [xCentroid, yCentroid] = find(imgEndWts == idCellEnd);
        centroidCell = round(mean([xCentroid, yCentroid]));
        hold on;
        hPlot2 = plot(axEnd, centroidCell(2), centroidCell(1), '*', 'Color', hPlot.Color);

        pixelsEnd = [xCentroid, yCentroid];
        trackingInfo{end+1} = table(idCellInit, pixelsInit, idCellEnd, pixelsEnd);

        finished = input('Did you finish? (0/1)');
    end
end

