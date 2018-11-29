function [allSurfaceRatioImages] = divideObjectInSurfaceRatios(obj_img, startingSurface, endSurface, validCells)
%DIVIDEOBJECTINSURFACERATIOS Summary of this function goes here
%   Detailed explanation goes here

    obj_img = ismember(obj_img, validCells) .* obj_img;
    startingSurface = ismember(startingSurface, validCells) .* startingSurface;
    [outsideObject] = getOutsideGland(obj_img);
    
    stepDilation = strel('sphere', 1);
    %We start at the outer surface
    actualSurface = imclose(startingSurface>0, strel('sphere', 1));
    numSurface = 1;
    
    
    while any(endSurface(actualSurface)) == 0
        allSurfaceRatioImages{numSurface} = actualSurface;
        
        outsideObject(actualSurface) = 1;
        
        dilatedActualSurface = imdilate(imclose(actualSurface>0, strel('sphere', 1)), stepDilation);
        
        dilatedActualSurface(outsideObject) = 0;
        numSurface = numSurface + 1;
        actualSurface = dilatedActualSurface;
        figure; paint3D(actualSurface)
    end

end