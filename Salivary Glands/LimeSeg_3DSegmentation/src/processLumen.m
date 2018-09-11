function [labelledImage, apicalLayer, lumenImage] = processLumen(lumenDir, labelledImage, resizeImg, tipValue)
%PROCESSLUMEN Summary of this function goes here
%   Detailed explanation goes here
    lumenFile = dir(fullfile(lumenDir, '**', '*.ply'));
    lumenPC = pcread(fullfile(lumenFile.folder, lumenFile.name));
    %pcshow(lumenPC);
    pixelLocations = round(double(lumenPC.Location)*resizeImg)+tipValue+1;
    lumenImage = zeros(size(labelledImage));
    [lumenImage] = addCellToImage(pixelLocations, lumenImage, 1);
    labelledImage(lumenImage == 1) = 0;
    
    %% Get apical layer by dilating the lumen
    [apicalLayer] = getApicalFrom3DImage(lumenImage, labelledImage);
    
end