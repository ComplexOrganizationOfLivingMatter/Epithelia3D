function [labelledImage, apicalLayer] = processLumen(lumenDir, labelledImage, resizeImg, numDepth)
%PROCESSLUMEN Summary of this function goes here
%   Detailed explanation goes here
    lumenFile = dir(fullfile(lumenDir, '**', '*.ply'));
    lumenPC = pcread(fullfile(lumenFile.folder, lumenFile.name));
    %pcshow(lumenPC);
    pixelLocations = round(double(lumenPC.Location)*resizeImg);
    lumenImage = zeros(size(labelledImage));
    for numPixel = 1:size(pixelLocations, 1)
        zPixels = pixelLocations(numPixel, 3)-numDepth:1:pixelLocations(numPixel, 3)+numDepth;
        zPixels(zPixels < 1) = [];
        labelledImage(pixelLocations(numPixel, 1), pixelLocations(numPixel, 2), zPixels) = 0;
        lumenImage(pixelLocations(numPixel, 1), pixelLocations(numPixel, 2), zPixels) = 1;
    end
    
    %% Get apical layer by dilating the lumen
    se = strel('sphere', 2);
    dilatedLumen = imdilate(lumenImage, se);
    apicalLayer = dilatedLumen .* labelledImage;
    
    [x,y,z] = ind2sub(size(apicalLayer),find(apicalLayer>0));
    figure;
    pcshow([x,y,z]);
end