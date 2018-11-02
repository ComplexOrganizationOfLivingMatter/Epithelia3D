function [labelledImage, lumenImage] = processLumen(lumenDir, labelledImage, resizeImg, tipValue)
%PROCESSLUMEN Summary of this function goes here
%   Detailed explanation goes here

    lumenStack = dir(fullfile(lumenDir, 'SegmentedLumen', '*.tif'));
    NoValidFiles = startsWith({lumenStack.name},'._','IgnoreCase',true);
    lumenStack=lumenStack(~NoValidFiles);
    lumenImage = zeros(size(labelledImage)-((tipValue+1)*2));
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
    
    %% Put both lumen and labelled image at a 90 degrees
    orientationGland = regionprops3(lumenImage>0, 'Orientation');
    glandOrientation = -orientationGland.Orientation(1);
    lumenImage = imrotate(lumenImage, glandOrientation);
    labelledImage = imrotate(labelledImage, glandOrientation);
    
    
    %% Smooth lumen to get a more cylinder-like object
    
    % We first remove irregularities. Like a pre-smooth.
    lumenImageFirstSmooth = bwmorph3(lumenImage, 'majority');
    
    lumenToSmooth = permute(lumenImageFirstSmooth, [1 3 2]);
    
    % Obtaining the number of pixels of each circumference
    for coordY = 1 : size(lumenToSmooth,3)
        actualPerim = bwperim(lumenToSmooth(:, :, coordY));
        pixelsCircumferencePerCoord(coordY) = sum(actualPerim(:));
    end
    
    [x, y, z] = ind2sub(size(lumenImage), find(lumenImageFirstSmooth));
    pixelLocations = [x, y, z];
    [lumenImageSmoothed] = smoothObject(lumenImageFirstSmooth, pixelLocations, 1);
    
    %figure; paint3D(lumenImage);
    
    %% Remove pixels of lumen from the cells image
    labelledImage(lumenImage == 1) = 0;
end