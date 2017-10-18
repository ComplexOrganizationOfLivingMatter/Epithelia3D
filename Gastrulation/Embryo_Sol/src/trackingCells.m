function [ trackingInfo ] = trackingCells(imgInitial, imgEnd)
%TRACKINGCELLS Summary of this function goes here
%   Detailed explanation goes here

    imgInitial =  bwareaopen( 1 - imgInitial(:, :, 1), 10);
    imgEnd =  bwareaopen(1 - imgEnd(:, :, 1), 10);

    imgEnd = bwareaopen(1 - imgEnd, 10);
    imgInitial =  bwareaopen( 1 - imgInitial, 10);

    imgInitialWts = double(watershed(imgInitial));
    imgEndWts = double(watershed(imgEnd));
    
%     initialFrameNeighbours = calculateNeighbours(imgInitialWts);
%     endFrameNeighbours = calculateNeighbours(imgEndWts);

    fig = figure;
    axInitial = subplot(1,2,1); imshow(imgInitialWts), title ('Initial Image')
    axEnd = subplot(1,2,2); imshow(imgEndWts), title('End Image')

    trackingInfo = {};
    
%     load('..\results\NoFolds\Scribgfp_Emb4_gast_AP\trackingCells\trackingInfo_16_10_2017.mat')
%     uiopen('..\results\NoFolds\Scribgfp_Emb4_gast_AP\trackingCells\trackingInfo.fig',1)
%     fig = gcf;
%     allAxis = get(gcf, 'Children');
%     axInitial = allAxis(2);
%     axEnd = allAxis(1);
    
    colours = colorcube(max(imgInitialWts(:)));
    finished = false;
    while finished == false
        disp('Select cell at Initial image');
        [x, y] = getpts(axInitial);
        idCellInit = imgInitialWts(round(y), round(x));
        [xCentroid, yCentroid] = find(imgInitialWts == idCellInit);
        centroidCell = round(mean([xCentroid, yCentroid]));
        hold on;
        hPlot = plot(axInitial, centroidCell(2), centroidCell(1), '*', 'Color', colours(idCellInit, :));

        pixelsInit = [xCentroid, yCentroid];

        disp('Select the correponding cell at End Image');
        [x, y] = getpts(axEnd);
        idCellEnd = imgEndWts(round(y), round(x));
        [xCentroid, yCentroid] = find(imgEndWts == idCellEnd);
        centroidCell = round(mean([xCentroid, yCentroid]));
        hold on;
        hPlot2 = plot(axEnd, centroidCell(2), centroidCell(1), '*', 'Color', hPlot.Color);

        pixelsEnd = [xCentroid, yCentroid];
        trackingInfo{end+1, 1} = table(idCellInit, {pixelsInit}, idCellEnd, {pixelsEnd});

        
        finished = input('Did you finish? (0/1)');
        mkdir('..\results\NoFolds\OR_Emb4 BC AP\trackingCells\');
        savefig(fig, '..\results\NoFolds\OR_Emb4 BC AP\trackingCells\trackingInfo.fig');
        save('..\results\NoFolds\OR_Emb4 BC AP\trackingCells\trackingInfo_18_10_2017.mat', 'trackingInfo');
    end
end

