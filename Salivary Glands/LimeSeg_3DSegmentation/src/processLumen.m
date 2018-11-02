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
    
    lumenToSmooth = permute(lumenImageFirstSmooth, [2 3 1]);
    
    % Obtaining the number of pixels of each circumference
    for coordY = 1 : size(lumenToSmooth,3)
        actualPerim = bwperim(lumenToSmooth(:, :, coordY));
        areaOfPerims = regionprops(actualPerim, 'Area');
        areaOfPerims = [areaOfPerims.Area];
        areaOfPerims(areaOfPerims<10) = [];
        pixelsCircumferencePerCoord{coordY} = areaOfPerims;
        if isempty(areaOfPerims) == 0
            imshow(actualPerim)
        end
        %pixelsCircumferencePerCoord(coordY) = mean(actualPerim(:));
    end
    
    allCircumferences = [pixelsCircumferencePerCoord{:}];
    
    quantilesCircumferences = quantile(allCircumferences,  [0.10, 0.5]);
    discardedValues = quantilesCircumferences(1);
    meadiaPixelsCircumferenceOfGland = quantilesCircumferences(2);
    
    %Create array of strel neighborhoods
    for numStrel = 1:10
        strelNeighborhoods(numStrel) = sum(strel('disk', numStrel).Neighborhood(:))-1;
    end
    
    % Smoothing object regarding the difference between the number of
    % pixels in a particular coordY and the calculated median and previous
    % and next coordYs.
    for coordY = 1 : size(lumenToSmooth, 3)
        if pixelsCircumferencePerCoord(coordY) >= discardedValues
            differenceToAdjust = pixelsCircumferencePerCoord(coordY) - mean([pixelsCircumferencePerCoord(coordY-1:coordY+1), meadiaPixelsCircumferenceOfGland]);
            
            [~, closestStrel] = min(abs(strelNeighborhoods - abs(differenceToAdjust)));
            
            if differenceToAdjust > 0 %Erode
                lumenToSmooth(:, :, coordY) = imerode(lumenToSmooth(:, :, coordY), strel('disk', closestStrel));
            else %Dilate
                lumenToSmooth(:, :, coordY) = imdilate(lumenToSmooth(:, :, coordY), strel('disk', closestStrel));
            end
        end
    end
    
    lumenImage = permute(lumenToSmooth, [2 3 1]);
    figure; paint3D(lumenImage);
    
    [x, y, z] = ind2sub(size(lumenImage), find(lumenImageFirstSmooth));
    pixelLocations = [x, y, z];
    [lumenImageSmoothed] = smoothObject(lumenImageFirstSmooth, pixelLocations, 1);
    
    %figure; paint3D(lumenImage);
    
    %% Remove pixels of lumen from the cells image
    labelledImage(lumenImage == 1) = 0;
end