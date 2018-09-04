function [labelledImage, apicalLayer] = processLumen(lumenDir, labelledImage)
%PROCESSLUMEN Summary of this function goes here
%   Detailed explanation goes here
    lumenFile = dir(fullfile(lumenDir, '**', '*.ply'));
    lumenPC = pcread(fullfile(lumenFile.folder, lumenFile.name));
    %pcshow(lumenPC);
    pixelLocations = round(double(lumenPC.Location));
    lumenImage = zeros(size(labelledImage));
    for numPixel = 1:size(pixelLocations, 1)
        labelledImage(pixelLocations(numPixel, 1), pixelLocations(numPixel, 2), pixelLocations(numPixel, 3)) = 0;
        lumenImage(pixelLocations(numPixel, 1), pixelLocations(numPixel, 2), pixelLocations(numPixel, 3)) = 1;
    end
    
    %% Get apical layer by dilating the lumen
    se = strel('sphere', 3);
    dilatedLumen = imdilate(lumenImage, se);
    apicalLayer = dilatedLumen .* labelledImage;
    
end