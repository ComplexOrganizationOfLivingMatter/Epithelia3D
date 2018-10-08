function [finalLayer] = getApicalFrom3DImage(lumenImage, labelledImage)
%GETAPICALFRO3DIMAGE Summary of this function goes here
%   Detailed explanation goes here

    [lumenPerimeter] = bwperim(lumenImage);
    
    se = strel('sphere', 3);
    dilatedLumen = imdilate(lumenPerimeter, se);
    apicalLayer = dilatedLumen .* labelledImage;
    
    se = strel('sphere', 2);
    dilatedLumen = imdilate(lumenPerimeter, se);
    
    
    [xToBeFilled,yToBeFilled,zToBeFilled] = ind2sub(size(apicalLayer), find(apicalLayer == 0 & dilatedLumen>0));
    pixelsWith0s = [xToBeFilled,yToBeFilled,zToBeFilled];
    
    [xToBeFilled,yToBeFilled,zToBeFilled] = ind2sub(size(apicalLayer), find(apicalLayer > 0 & dilatedLumen>0));
    pixelsOfCells = [xToBeFilled,yToBeFilled,zToBeFilled];
    cellIdsPerPixel = apicalLayer(apicalLayer > 0 & dilatedLumen>0);
    
    distanceFrom0sToCells = pdist2(pixelsWith0s, pixelsOfCells);
    [~, idsOfPixels] = min(distanceFrom0sToCells, [], 2);
    
    apicalLayerWithoutHoles = apicalLayer;
    apicalLayerWithoutHoles(apicalLayer == 0 & dilatedLumen>0) = cellIdsPerPixel(idsOfPixels);
    
    finalLayer = zeros(size(apicalLayerWithoutHoles));
    for numCell = unique(apicalLayerWithoutHoles)'
%         [x,y,z] = ind2sub(size(apicalLayerWithoutHoles),find(apicalLayerWithoutHoles == numCell & dilatedLumen>0));
%         figure;
%         pcshow([x,y,z]);
        finalLayer(imerode(apicalLayerWithoutHoles == numCell & dilatedLumen>0, strel('sphere', 1))>0) = numCell;
    end
   
    %% Do watershed
    imgWatersheded = watershed(apicalLayerWithoutHoles);
    paint3D(double(imgWatersheded));
end

