function [] = paintLineTensionEdges( energyExcel, surfaceRatio, totalEnergyData )
%PAINTLINETENSIONEDGES Summary of this function goes here
%   Detailed explanation goes here

	minValue = 0.5;
    maxValue = 1.5;
    maxColours = 100;

    maxRandoms = 20;
    for nRandom = 1:maxRandoms
        load(strcat('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\data\voronoiModel\expansion\512x4096_800seeds\Image_', num2str(nRandom), '_Diagram_5\Image_', num2str(nRandom),'_Diagram_5.mat'));
        imageLabelled = listLOriginalProjection(round(listLOriginalProjection.surfaceRatio, 2) == round(surfaceRatio, 2), :).L_originalProjection{1};
        
        heatMapImage = zeros(size(imageLabelled));
        
        for numRow = 1:size(energyExcel, 1)
            neighbouringCells = energyExcel{numRow, 1:2};
            dilatedImg = imdilate(ismember(imageLabelled, neighbouringCells), strel('disk', 1));
            imgOnlyEdges = imageLabelled == 0;
            heatmapValue = (totalEnergyData(numRow, 1) - minValue)/(maxValue-minValue)*maxColours;
            heatMapImage(dilatedImg & imgOnlyEdges) = round(heatmapValue);
        end
        
        figure;
        imshow(heatMapImage, colormap('parula', maxColours));
    end


end

