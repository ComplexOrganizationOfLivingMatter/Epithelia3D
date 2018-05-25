function [] = paintLineTensionEdges( energyExcel, surfaceRatio, totalEnergyData, typeOfSimulation )
%PAINTLINETENSIONEDGES Summary of this function goes here
%   Detailed explanation goes here

	minValue = 0.5;
    maxValue = 1.5;
    maxColours = 100;

    maxRandoms = 20;
    colours = colormap(jet(maxColours));
    colours(1, :) = [0 0 0];
    for nRandom = 1%:maxRandoms
        actualEnergyExcel = energyExcel(energyExcel.nRand == nRandom, :);
        actualTotalEnergy = totalEnergyData(energyExcel.nRand == nRandom, :);
        load(strcat('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\data\voronoiModel\expansion\512x4096_800seeds\Image_', num2str(nRandom), '_Diagram_5\Image_', num2str(nRandom),'_Diagram_5.mat'));
        
        if isequal(typeOfSimulation, 'Voronoi')
            imageLabelled = listLOriginalProjection(round(listLOriginalProjection.surfaceRatio, 2) == round(surfaceRatio, 2), :).L_originalProjection{1};
            initialDilated = 0;
        else
            imageLabelled = listLOriginalProjection.L_originalProjection{1};
            initialDilated = 3;
            imgLabelledDilated = imdilate(imageLabelled == 0, strel('disk', initialDilated));
            imageLabelled(imgLabelledDilated) = 0;
            imageLabelled = imresize(imageLabelled, [size(imageLabelled, 1) size(imageLabelled, 2)*surfaceRatio], 'nearest');
        end
        
        heatMapImage = zeros(size(imageLabelled));
        
        imgOnlyEdges = imdilate(imageLabelled == 0, strel('disk', 3));
        for numRow = 1:size(actualEnergyExcel, 1)
            neighbouringCells = actualEnergyExcel{numRow, 1:2};
            cell1Dilated = imdilate(ismember(imageLabelled, neighbouringCells(1)), strel('disk', 4+initialDilated));
            cell2Dilated = imdilate(ismember(imageLabelled, neighbouringCells(2)), strel('disk', 4+initialDilated));
            dilatedImg = cell1Dilated & cell2Dilated;
            heatmapValue = (actualTotalEnergy(numRow, 1) - minValue)/(maxValue-minValue)*maxColours;
            heatMapImage(dilatedImg & imgOnlyEdges) = round(heatmapValue);
        end
        
        outputDir = strcat('results/', typeOfSimulation, '/SurfaceRatio', num2str(surfaceRatio), '/');
        mkdir(outputDir)
%         h = figure('visible', 'off');
%         imshow(heatMapImage, colours);
%         colorbar('northoutside')
%         print(h, strcat(outputDir, 'lineTensionPlot_NRandom', num2str(nRandom), '_withColorBar.tif'), '-dtiff', '-r300')
%         close(h);
        imwrite(heatMapImage, colours, strcat(outputDir, 'lineTensionPlot_NRandom', num2str(nRandom), '.tif'))
    end
end

