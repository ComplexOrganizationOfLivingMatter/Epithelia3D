function LabelImageSequence()
%PIPELINE Summary of this function goes here
%   Detailed explanation goes here
    selpath = uigetdir('data');

    if isempty(selpath) == 0
        outputDir = selpath;
        
        mkdir(fullfile(outputDir, 'Cells', 'OutputLimeSeg'));
        mkdir(fullfile(outputDir, 'ImageSequence'));
        

        resizeImg = 0.25;

        tipValue = 4;

        imageSequenceFiles = dir(fullfile(outputDir, 'ImageSequence/*.tif'));
        demoFile =  imageSequenceFiles(3);
        demoImg = imread(fullfile(demoFile.folder, demoFile.name));

        imgSize = round(size(demoImg)*resizeImg);

        [labelledImage] = processCells(fullfile(outputDir, 'Cells', filesep), resizeImg, imgSize, tipValue);

        [colours] = exportAsImageSequence(labelledImage, fullfile(outputDir, 'Cells', 'Cellslabelled', filesep), [], tipValue);
        
        setappdata(0,'outputDir', outputDir);
        setappdata(0,'labelledImage',labelledImage);
        setappdata(0,'resizeImg',resizeImg);
        setappdata(0,'tipValue', tipValue);
        exportAsImageSequence(labelledImage, fullfile(outputDir, 'Cells', 'Cellslabelled', filesep), colours, tipValue);
    end
end

