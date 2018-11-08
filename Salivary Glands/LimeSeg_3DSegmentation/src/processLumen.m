function [labelledImage, lumenImage, glandOrientation] = processLumen(lumenDir, labelledImage, resizeImg, tipValue)
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
    lumenFirstSmooth = bwmorph3(lumenImage, 'majority');
    
    [lumenSmoothed] = smoothPerimeterByAxis(permute(lumenFirstSmooth, [2 3 1]));
    [lumenSmoothed] = smoothPerimeterByAxis(permute(lumenSmoothed, [3 2 1])); % Real: [1 3 2] in the permute
    lumenImage = permute(lumenSmoothed, [1 3 2]);
    %figure; paint3D(lumenImage);
    
    [x, y, z] = ind2sub(size(lumenImage), find(lumenImage));
    pixelLocations = [x, y, z];
    [lumenImageSmoothed] = smoothObject(lumenImage, pixelLocations, 1);
    
    lumenImageSmoothed = imdilate(lumenImageSmoothed, strel('sphere', 3));
    lumenImage = imerode(lumenImageSmoothed, strel('sphere', 3));
    %figure; paint3D(lumenImageSmoothed);
    

    %% Remove pixels of lumen from the cells image

    lumenImageLabel = bwlabeln(lumenImage,26);
    volume = regionprops3(lumenImageLabel,'Volume');
    [~,indMax] = max(cat(1,volume.Volume));
    lumenImage = lumenImageLabel==indMax;
    
    labelledImage(lumenImage == 1) = 0;
end