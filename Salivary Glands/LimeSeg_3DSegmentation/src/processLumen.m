function [labelledImage, apicalLayer, lumenImage] = processLumen(lumenDir, labelledImage, resizeImg, tipValue)
%PROCESSLUMEN Summary of this function goes here
%   Detailed explanation goes here

    lumenStack = dir(fullfile(lumenDir, 'SegmentedLumen', '*.tif'));
    NoValidFiles = startsWith({lumenStack.name},'._','IgnoreCase',true);
    lumenStack=lumenStack(~NoValidFiles);
    lumenImage = zeros(size(labelledImage)-((tipValue+1)*2));
    lumenImage = imrotate(lumenImage, -270);
    for numZ = 1:size(lumenStack, 1)
        imgZ = imread(fullfile(lumenStack(numZ).folder, lumenStack(numZ).name));
        
        [y, x] = find(imgZ == 0);
        if isempty(x) == 0
            lumenIndices = sub2ind(size(lumenImage), round(x*resizeImg), round(y*resizeImg), repmat(numZ, length(x), 1));
            lumenImage(lumenIndices) = 1;
        end
    end
%     lumenFile = dir(fullfile(lumenDir, '**', '*.ply'));
%     lumenPC = pcread(fullfile(lumenFile.folder, lumenFile.name));
    %pcshow(lumenPC);
%     pixelLocations = round(double(lumenPC.Location)*resizeImg);
%     [lumenImage] = addCellToImage(pixelLocations, lumenImage, 1);
    lumenImage = addTipsImg3D(tipValue+1, lumenImage);
    lumenImage = double(lumenImage);
    lumenImage = flip(lumenImage);
    lumenImage = imrotate(lumenImage, 270);
    
    [x, y, z] = ind2sub(size(lumenImage), find(lumenImage));
    pixelLocations = [x, y, z];
    
    [lumenImage] = smoothObject(lumenImage, pixelLocations, 1);
    
    labelledImage(lumenImage == 1) = 0;
    
    
    %% Get apical layer by dilating the lumen
    [apicalLayer] = getApicalFrom3DImage(lumenImage, labelledImage);
end