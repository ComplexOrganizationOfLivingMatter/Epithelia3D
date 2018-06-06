function [] = paintLineTensionEdges( energyExcel, surfaceRatio, totalEnergyData, typeOfSimulation, inputDirectory)
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
        
        if isequal(typeOfSimulation, 'Voronoi')
            load(strcat(inputDirectory, 'Voronoi\2048x4096_200seeds\Image_', num2str(nRandom), '_Diagram_5\Image_', num2str(nRandom),'_Diagram_5.mat'));
            imageLabelled = listLOriginalProjection(round(listLOriginalProjection.surfaceRatio, 2) == round(surfaceRatio, 2), :).L_originalProjection{1};
            initialDilated = 0;
            
            heatMapImage = zeros(size(imageLabelled));
            imgOnlyEdges = imdilate(imageLabelled == 0, strel('disk', 3));
            for numRow = 1:size(actualEnergyExcel, 1)
                neighbouringCells = actualEnergyExcel{numRow, 1:2};
                cell1Dilated = imdilate(ismember(imageLabelled, neighbouringCells(1)), strel('disk', 4));
                cell2Dilated = imdilate(ismember(imageLabelled, neighbouringCells(2)), strel('disk', 4));
                dilatedImg = cell1Dilated & cell2Dilated;
                heatmapValue = (actualTotalEnergy(numRow, 1) - minValue)/(maxValue-minValue)*maxColours;
                heatMapImage(dilatedImg & imgOnlyEdges) = round(heatmapValue);
            end
            
        else
            load(strcat(inputDirectory, 'AllFrusta\2048x4096_200seeds\randomization', num2str(nRandom), '\totalVerticesData.mat'));
            imageLabelled = L_img;
            imageLabelled = imresize(imageLabelled, [size(imageLabelled, 1) size(imageLabelled, 2)*surfaceRatio], 'nearest');
            
            frustaInfo = frustaTable(round(frustaTable.surfaceRatio, 2) == round(surfaceRatio, 2), :);
            
            heatMapImage = zeros(size(imageLabelled));
        
            borderVertices = find(arrayValidVerticesBorderLeft | arrayValidVerticesBorderRight);
            
            blankImage = zeros(size(imageLabelled));
            
            for numRow = 1:size(actualEnergyExcel, 1)
                numRow
                neighbouringCells = actualEnergyExcel{numRow, 1:2};
                %Cells that are not  connected but share the edge of the motif
                edgeEndCells = actualEnergyExcel{numRow, 3:4};
                
                numVertex1 = find(ismember(frustaInfo.vertices.verticesConnectCells, sort(horzcat(neighbouringCells, edgeEndCells(1))), 'rows'));
                numVertex2 = find(ismember(frustaInfo.vertices.verticesConnectCells, sort(horzcat(neighbouringCells, edgeEndCells(2))), 'rows'));
                
                if ismember(numVertex1, borderVertices) || ismember(numVertex2, borderVertices)
                    continue;
                end
                
                vertex1 = frustaInfo.vertices.verticesPerCell{numVertex1};
                vertex2 = frustaInfo.vertices.verticesPerCell{numVertex2};
                
                [xToPaint, yToPaint] = Drawline3D(vertex1(1), vertex1(2), 0, vertex2(1), vertex2(2), 0);
                  
                indicesToPaint = sub2ind(size(imageLabelled),xToPaint, yToPaint);
                
                blankImage(indicesToPaint) = 1;
                %New indices dilated
                indicesToPaint = find(imdilate(blankImage, strel('disk', 4)));

                heatmapValue = (actualTotalEnergy(numRow, 1) - minValue)/(maxValue-minValue)*maxColours;
                heatMapImage(indicesToPaint) = round(heatmapValue);
                blankImage(indicesToPaint) = 0;
            end
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

