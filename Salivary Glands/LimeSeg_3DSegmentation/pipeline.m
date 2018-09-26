function [polygon_distribution_Apical, polygon_distribution_Basal, polygonDistributions,selpath] = pipeline()
%PIPELINE Summary of this function goes here
%   Detailed explanation goes here
    selpath = uigetdir('data');

    if isempty(selpath) == 0
        outputDir = selpath;
        
        mkdir(fullfile(outputDir, 'Cells', 'OutputLimeSeg'));
        mkdir(fullfile(outputDir, 'ImageSequence'));
        mkdir(fullfile(outputDir, 'Lumen', 'OutputLimeSeg'));
        

        resizeImg = 0.25;

        tipValue = 4;

        imageSequenceFiles = dir(fullfile(outputDir, 'ImageSequence/*.tif'));
        demoFile =  imageSequenceFiles(3);
        demoImg = imread(fullfile(demoFile.folder, demoFile.name));

        imgSize = round(size(demoImg)*resizeImg);

        [labelledImage, basalLayer] = processCells(fullfile(outputDir, 'Cells', filesep), resizeImg, imgSize, tipValue);

        [labelledImage, apicalLayer, lumenImage] = processLumen(fullfile(outputDir, 'Lumen', filesep), labelledImage, resizeImg, tipValue);

        [colours] = exportAsImageSequence(labelledImage, fullfile(outputDir, 'Cells', 'labelledSequence', filesep), [], tipValue);

        setappdata(0,'outputDir', outputDir);
        setappdata(0,'labelledImage',labelledImage);
        setappdata(0, 'lumenImage', lumenImage);
        setappdata(0,'resizeImg',resizeImg);
        setappdata(0,'tipValue', tipValue);

        [noValidCells] = insertNoValidCells();

        [answer, apical3dInfo, notFoundCellsApical, basal3dInfo, notFoundCellsBasal] = calculateMissingCells(labelledImage, lumenImage, apicalLayer, basalLayer, colours, noValidCells);

        %% Insert no valid cells
        while isequal(answer, 'Yes')
            h = window();
            waitfor(h);

            savingResults = saveResults();

            if isequal(savingResults, 'Yes')
                labelledImage = getappdata(0, 'labelledImageTemp');
                close all
                exportAsImageSequence(labelledImage, fullfile(outputDir, 'Cells', 'labelledSequence', filesep), colours, tipValue);

                %% Calculate neighbours and plot missing cells
                [basalLayer] = getBasalFrom3DImage(labelledImage, tipValue);
                [apicalLayer] = getApicalFrom3DImage(lumenImage, labelledImage);

                [answer, apical3dInfo, notFoundCellsApical, basal3dInfo, notFoundCellsBasal] = calculateMissingCells(labelledImage, lumenImage, apicalLayer, basalLayer, colours, noValidCells);

                validCells = setdiff(1:max(labelledImage(:)), noValidCells);

                [polygon_distribution_Apical] = calculate_polygon_distribution(cellfun(@length, apical3dInfo.neighbourhood), validCells);
                [polygon_distribution_Basal] = calculate_polygon_distribution(cellfun(@length, basal3dInfo.neighbourhood), validCells);
                polygonDistributions = {apical3dInfo.neighbourhood(validCells), basal3dInfo.neighbourhood(validCells)};
                
                
            else
                [answer] = isEverythingCorrect();
            end
        end
    end
end

