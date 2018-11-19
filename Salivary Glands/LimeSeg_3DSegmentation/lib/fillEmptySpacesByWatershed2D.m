function [finalImage] = fillEmptySpacesByWatershed2D(labelMask, invalidRegion, colours)
%FILLEMPTYSPACESBYWATERSHED Summary of this function goes here
%   Detailed explanation goes here
    %labelMaskEroded = imerode(labelMask, strel('sphere', 1));
    
    labelMaskEroded = labelMask;
    for numCell = 1:max(labelMask(:))
        labelMaskPerim = bwperim(labelMask == numCell, 4);
        labelMaskEroded(labelMaskPerim) = 0;
    end
    
    maskDist=bwdist(labelMaskEroded>0);
    maskWater=watershed(maskDist, 4);
    %     maskDist=bwdist(maskWater>0);
    %     maskWater=watershed(maskDist,4);
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

