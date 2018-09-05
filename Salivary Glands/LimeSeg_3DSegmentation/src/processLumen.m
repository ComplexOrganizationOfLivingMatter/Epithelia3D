function [labelledImage, apicalLayer] = processLumen(lumenDir, labelledImage, resizeImg, numDepth)
%PROCESSLUMEN Summary of this function goes here
%   Detailed explanation goes here
    lumenFile = dir(fullfile(lumenDir, '**', '*.ply'));
    lumenPC = pcread(fullfile(lumenFile.folder, lumenFile.name));
    %pcshow(lumenPC);
    pixelLocations = round(double(lumenPC.Location)*resizeImg);
    lumenImage = zeros(size(labelledImage));
    for numPixel = 1:size(pixelLocations, 1)
        [labelledImage] = addCellToImage(pixelLocations, labelledImage, 0);
        [lumenImage] = addCellToImage(pixelLocations, lumenImage, 1);
    end
    
    %% Get apical layer by dilating the lumen
    se = strel('sphere', 5);
    dilatedLumen = imdilate(lumenImage, se);
    apicalLayer = dilatedLumen .* labelledImage;
    
%     [x,y,z] = ind2sub(size(apicalLayer),find(apicalLayer>0));
%     figure;
%     pcshow([x,y,z]);
end