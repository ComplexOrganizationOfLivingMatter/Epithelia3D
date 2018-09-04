function [labelledImage] = processLumen(lumenDir, labelledImage)
%PROCESSLUMEN Summary of this function goes here
%   Detailed explanation goes here
    lumenFile = dir(fullfile(lumenDir, '**', '*.ply'));
    lumenPC = pcread(fullfile(lumenFile.folder, lumenFile.name));
    pcshow(lumenPC);
    pixelLocations = round(double(lumenPC.Location));
    for numPixel = 1:size(pixelLocations, 1)
        labelledImage(pixelLocations(numPixel, 1), pixelLocations(numPixel, 2), pixelLocations(numPixel, 3)) = 0;
    end
end