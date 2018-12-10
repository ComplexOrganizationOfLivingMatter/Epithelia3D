function [allSurfaceRatioImages] = divideObjectInSurfaceRatios(obj_img, startingSurface, endSurface, validCells, noValidCells, colours)
%DIVIDEOBJECTINSURFACERATIOS Summary of this function goes here
%   Detailed explanation goes here

    %obj_img_WithoutNoValidCells = ismember(obj_img, validCells) .* obj_img;
%     startingSurface = ismember(startingSurface, validCells) .* startingSurface;
    [outsideObject] = getOutsideGland(obj_img);
    
    outsideObject(imdilate(endSurface, strel('sphere', 2))>0) = 0;
    stepDilation = strel('sphere', 1);
    %We start at the outer surface
    actualSurface = imclose(startingSurface>0, strel('sphere', 1));
    numSurface = 1;
    
    apical3dInfo = calculateNeighbours3D(endSurface);
    while any(any(any(endSurface>0 & (ismember(obj_img, validCells) .*actualSurface)>0))) == 0
        allSurfaceRatioImages{numSurface, 1} = obj_img .* actualSurface;
        allSurfaceRatioImages{numSurface, 2} = calculateNeighbours3D(allSurfaceRatioImages{numSurface, 1});
        
        basal3dInfo = calculateNeighbours3D(allSurfaceRatioImages{numSurface, 1});
        neighbours_data = table(apical3dInfo.neighbourhood, basal3dInfo.neighbourhood);
        neighbours_data.Properties.VariableNames = {'Apical','Basal'};
        allSurfaceRatioImages{numSurface, 3} = calculate_CellularFeatures(neighbours_data, apical3dInfo, basal3dInfo, endSurface, allSurfaceRatioImages{numSurface, 1}, obj_img .* (outsideObject == 0), noValidCells, '.');
        
        outsideObject(actualSurface) = 1;
        
        dilatedActualSurface = imdilate(imclose(actualSurface>0, strel('sphere', 1)), stepDilation);
        
        dilatedActualSurface(outsideObject) = 0;
        numSurface = numSurface + 1;
        actualSurface = bwmorph3(dilatedActualSurface, 'clean');
        %figure; paint3D( obj_img .* actualSurface, [], colours);
    end
    figure; paint3D( obj_img .* actualSurface, [], colours);
    hold on;
    [indices] = find(endSurface>0 & (ismember(obj_img, validCells) .*actualSurface)>0);
    [x, y, z] = ind2sub(size(endSurface), indices);
    for numIndex = 1:length(x)
       plot3(x(numIndex), y(numIndex), z(numIndex), '*r'); 
    end
end