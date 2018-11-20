function [finalImage] = fillEmptySpacesByWatershed2D(labelMask, invalidRegion, colours)
%FILLEMPTYSPACESBYWATERSHED Summary of this function goes here
%   Detailed explanation goes here
    
    %erodingRegion = strel('disk', 2);
    labelMaskCleaned = bwareaopen(labelMask, 10);
    labelMaskCleaned = labelMask .* labelMaskCleaned;
    labelMaskEroded = zeros(size(labelMask));
    for numCell = 1:max(labelMask(:))
        %labelMaskPerim = bwperim(labelMask == numCell, 4);
        %labelMaskEroded(labelMaskPerim) = 0;
        %erodedCell = imerode(labelMask == numCell, erodingRegion);
        dilatedCell = bwmorph(labelMaskCleaned == numCell, 'shrink', 2);
        dilatedCell = bwmorph(dilatedCell, 'close', 2);
%         dilatedCell = imdilate(dilatedCell, erodingRegion);
%         dilatedCell = bwmorph(dilatedCell, 'majority');
%         erodedCell = imerode(dilatedCell, erodingRegion);
        labelMaskEroded(dilatedCell) = numCell;
    end
    
    closedNeighbours = strel([0 1 0; 1 0 1; 0 1 0]);
    labelMaskFinal = labelMaskEroded;
    %Remove neighbouring cells
    for numCell = 1:max(labelMask(:))
        actualVicinity = imdilate(labelMaskEroded == numCell, closedNeighbours);
        neighs = unique(labelMaskEroded(actualVicinity));
        neighs(neighs == numCell | neighs == 0) = [];
        if isempty(neighs) == 0
            labelMaskFinal(ismember(labelMaskEroded .* actualVicinity, neighs)) = 0;
        end
    end
    
    maskDist=bwdist(labelMaskFinal>0);
    maskWater=watershed(maskDist, 4);
    %figure;imshow(maskWater,c)
    maskWater(invalidRegion)=0; 
    
    %% relabel cells with original labels
    centroids = regionprops(maskWater,'Centroid');
    centroids = round(cat(1,centroids.Centroid));
    cellsWater = unique(maskWater);
    cellsWater=cellsWater(cellsWater~=0);
    
    finalImage=zeros(size(maskWater));
    dilatedMask = zeros(size(maskWater));
    for nCell = cellsWater'
        dilatedMask(centroids(nCell,2),centroids(nCell,1)) = 1;
        valuesSurroundingCentroid = labelMask(imdilate(dilatedMask, strel('disk', 3))> 0);
        mostFrequentValue = mode(valuesSurroundingCentroid);
        finalImage(maskWater==nCell) = mostFrequentValue;
        
        dilatedMask(centroids(nCell,2),centroids(nCell,1)) = 0;
    end
    
    
    finalImage = double(maskWater);
end

