
addpath(genpath('src'))
addpath(genpath('lib'))

addpath(genpath(fullfile('..', '..', 'InSilicoModels', 'TubularModel', 'src')));

dataDirs = dir('data/*/');

resizeImg = 0.25;

tipValue = 4;

for numDir = 3:size(dataDirs, 1)
    
    actualFile = dataDirs(numDir);
    
    outputDir = fullfile(actualFile.folder, actualFile.name);
    imageSequenceFiles = dir(fullfile(outputDir, 'ImageSequence'));
    demoFile =  imageSequenceFiles(3);
    demoImg = imread(fullfile(demoFile.folder, demoFile.name));
    
    imgSize = round(size(demoImg)*resizeImg);
    
    [labelledImage, basalLayer] = processCells(fullfile(actualFile.folder, actualFile.name, 'Cells', filesep), resizeImg, imgSize);
    
    [labelledImage, apicalLayer, lumenImage] = processLumen(fullfile(actualFile.folder, actualFile.name, 'Lumen', filesep), labelledImage, resizeImg);
    
    [colours] = exportAsImageSequence(labelledImage, fullfile(actualFile.folder, actualFile.name, 'Cells', 'labelledSequence', filesep));
    
    setappdata(0,'outputDir',fullfile(actualFile.folder, actualFile.name));
    setappdata(0,'labelledImage',labelledImage);
    setappdata(0,'resizeImg',resizeImg);
    
    [answer, apical3dInfo, notFoundCellsApical, basal3dInfo, notFoundCellsBasal] = calculateMissingCells(labelledImage, lumenImage, apicalLayer, basalLayer);
    
    %% Insert no valid cells
    [noValidCells] = insertNoValidCells();
    while isequal(answer, 'No')
        h = window();
        waitfor(h);

        labelledImage = getappdata(0, 'labelledImage');

        exportAsImageSequence(labelledImage, fullfile(actualFile.folder, actualFile.name, 'Cells', 'labelledSequence', filesep), colours, tipValue);
        
        %% Calculate neighbours and plot missing cells
        [answer, apical3dInfo, notFoundCellsApical, basal3dInfo, notFoundCellsBasal] = calculateMissingCells(labelledImage, lumenImage, apicalLayer, basalLayer, colours, noValidCells);
        
        polygonDistributions(numDir - 2, :) = {apical3dInfo, basal3dInfo};
        
%         labelledImage = importImageSequence(labelledImage, fullfile(actualFile.folder, actualFile.name, 'Cells', 'labelledSequence', filesep), tipValue);
%         
%         [apical3dInfo] = calculateNeighbours3D(apicalLayer);
%         [basal3dInfo] = calculateNeighbours3D(basalLayer);

    end
end