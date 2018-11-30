function [allSurfaceRatioImages] = divideObjectInSurfaceRatios(obj_img, startingSurface, endSurface, validCells, noValidCells)
%DIVIDEOBJECTINSURFACERATIOS Summary of this function goes here
%   Detailed explanation goes here

    obj_img = ismember(obj_img, validCells) .* obj_img;
    startingSurface = ismember(startingSurface, validCells) .* startingSurface;
    [outsideObject] = getOutsideGland(obj_img);
    
    stepDilation = strel('sphere', 1);
    %We start at the outer surface
    actualSurface = imclose(startingSurface>0, strel('sphere', 1));
    numSurface = 1;
    
    apical3dInfo = calculateNeighbours3D(endSurface);
    while any(endSurface(actualSurface)) == 0
        allSurfaceRatioImages{numSurface, 1} = obj_img .* actualSurface;
        allSurfaceRatioImages{numSurface, 2} = calculateNeighbours3D(allSurfaceRatioImages{numSurface, 1});
        
        basal3dInfo = calculateNeighbours3D(allSurfaceRatioImages{numSurface, 1});
        neighbours_data = table(apical3dInfo.neighbourhood, basal3dInfo.neighbourhood);
        neighbours_data.Properties.VariableNames = {'Apical','Basal'};
        allSurfaceRatioImages{numSurface, 3} = calculate_CellularFeatures(neighbours_data, apical3dInfo, basal3dInfo, endSurface, allSurfaceRatioImages{numSurface, 1}, obj_img, noValidCells, '.');
        
        outsideObject(actualSurface) = 1;
        
        dilatedActualSurface = imdilate(imclose(actualSurface>0, strel('sphere', 1)), stepDilation);
        
        dilatedActualSurface(outsideObject) = 0;
        numSurface = numSurface + 1;
        actualSurface = bwmorph3(dilatedActualSurface, 'clean');
        %figure; paint3D( obj_img .* actualSurface);
    end
    
    
end