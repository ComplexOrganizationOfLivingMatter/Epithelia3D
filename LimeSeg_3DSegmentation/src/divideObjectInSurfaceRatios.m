function [] = divideObjectInSurfaceRatios(obj_img, startingSurface, endSurface)
%DIVIDEOBJECTINSURFACERATIOS Summary of this function goes here
%   Detailed explanation goes here

    [outsideObject] = getOutsideGland(obj_img);

    stepDilation = strel('sphere', 1);
    %We start at the outer surface
    actualSurface = imclose(startingSurface>0, strel('sphere', 1));
    numSurface = 1;
    
    
    while any(actualSurface(:) & endSurface(:))
        allSurfaceRatioImages{numSurface} = actualSurface;
        
        outsideObject(actualSurface) = 1;
        
        dilatedActualSurface = imdilate(imclose(actualSurface>0, strel('sphere', 1)), stepDilation);
        
        dilatedActualSurface(outsideObject) = 0;
        numSurface = numSurface + 1;
        actualSurface = dilatedActualSurface;
    end

end