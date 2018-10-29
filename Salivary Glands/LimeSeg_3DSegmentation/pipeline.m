function [polygon_distribution, neighbours_data,neighbours_UnrollTube,polygon_distribution_UnrollTube,selpath] = pipeline()
%PIPELINE Summary of this function goes here
%   Detailed explanation goes here
    selpath = uigetdir('data');

    if isempty(selpath) == 0
        outputDir = selpath;

        mkdir(fullfile(outputDir, 'Cells', 'OutputLimeSeg'));
        mkdir(fullfile(outputDir, 'ImageSequence'));
        mkdir(fullfile(outputDir, 'Lumen'));
        mkdir(fullfile(outputDir, 'Results'));


        resizeImg = 0.25;

        tipValue = 4;

        imageSequenceFiles = dir(fullfile(outputDir, 'ImageSequence/*.tif'));
        NoValidFiles = startsWith({imageSequenceFiles.name},'._','IgnoreCase',true);
        imageSequenceFiles=imageSequenceFiles(~NoValidFiles);
        demoFile =  imageSequenceFiles(3);
        demoImg = imread(fullfile(demoFile.folder, demoFile.name));

        imgSize = round(size(demoImg)*resizeImg);

        if exist(fullfile(selpath, 'Results', '3d_layers_info.mat')) == 2
            load(fullfile(selpath, 'Results', '3d_layers_info.mat'))
        else
            colours = [];
            [labelledImage, basalLayer] = processCells(fullfile(outputDir, 'Cells', filesep), resizeImg, imgSize, tipValue);
        end
        
        [labelledImage, apicalLayer, lumenImage] = processLumen(fullfile(outputDir, 'Lumen', filesep), labelledImage, resizeImg, tipValue);

        [colours] = exportAsImageSequence(labelledImage, fullfile(outputDir, 'Cells', 'labelledSequence', filesep), colours, tipValue);

        setappdata(0,'outputDir', outputDir);
        setappdata(0,'labelledImage',labelledImage);
        setappdata(0, 'lumenImage', lumenImage);
        setappdata(0,'resizeImg',resizeImg);
        setappdata(0,'tipValue', tipValue);

        if exist(fullfile(selpath, 'Results', 'valid_cells.mat'), 'file')
            load(fullfile(selpath, 'Results', 'valid_cells.mat'))
        else
            [noValidCells] = insertNoValidCells();
            validCells = setdiff(1:max(labelledImage(:)), noValidCells);
            save(fullfile(selpath, 'Results', 'valid_cells.mat'), 'noValidCells', 'validCells')
        end
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
                if exist(fullfile(selpath, '3d_layers_info.mat')) == 0
                    [basalLayer] = getBasalFrom3DImage(labelledImage, tipValue);
                    [apicalLayer] = getApicalFrom3DImage(lumenImage, labelledImage);
                    [answer, apical3dInfo, notFoundCellsApical, basal3dInfo, notFoundCellsBasal] = calculateMissingCells(labelledImage, lumenImage, apicalLayer, basalLayer, colours, noValidCells);
                end

            else
                [answer] = isEverythingCorrect();
            end
        end
        %% Save apical and basal 3d information
        save(fullfile(selpath, 'Results', '3d_layers_info.mat'), 'labelledImage', 'basalLayer', 'apicalLayer', 'apical3dInfo', 'basal3dInfo', 'colours', '-v7.3')

        %% Calculate poligon distribution and Unroll the tube.
        [polygon_distribution_Apical] = calculate_polygon_distribution(cellfun(@length, apical3dInfo.neighbourhood), validCells);
        [polygon_distribution_Basal] = calculate_polygon_distribution(cellfun(@length, basal3dInfo.neighbourhood), validCells);
        neighbours_data = table(apical3dInfo.neighbourhood, basal3dInfo.neighbourhood);
        polygon_distribution = table(polygon_distribution_Apical, polygon_distribution_Basal);
        neighbours_data.Properties.VariableNames = {'Apical','Basal'};
        polygon_distribution.Properties.VariableNames = {'Apical','Basal'};

        [neighs_apical,side_cells_apical, apicalAreaValidCells] = unrollTube(apicalLayer, fullfile(selpath,  'Results', 'apical'), noValidCells, colours);
        [neighs_basal,side_cells_basal] = unrollTube(basalLayer, fullfile(selpath, 'Results', 'basal'), noValidCells, colours, apicalAreaValidCells);
        
        missingCellsUnroll = find(side_cells_basal<3 | side_cells_apical<3, 1);
        if isempty(missingCellsUnroll) == 0
            msgbox(strcat('CARE!! Missing (or ill formed) cells at unrolltube: ', strjoin(arrayfun(@num2str, missingCellsUnroll, 'UniformOutput', false), ' ')))
        end
        
        [polygon_distribution_UnrollTubeApical] = calculate_polygon_distribution(side_cells_apical, validCells);
        [polygon_distribution_UnrollTubeBasal] = calculate_polygon_distribution(side_cells_basal, validCells);
        neighbours_UnrollTube = table(neighs_apical,neighs_basal);
        polygon_distribution_UnrollTube = table(polygon_distribution_UnrollTubeApical,polygon_distribution_UnrollTubeBasal);
        neighbours_UnrollTube.Properties.VariableNames = {'Apical','Basal'};
        polygon_distribution_UnrollTube.Properties.VariableNames = {'Apical','Basal'};
    end
end

