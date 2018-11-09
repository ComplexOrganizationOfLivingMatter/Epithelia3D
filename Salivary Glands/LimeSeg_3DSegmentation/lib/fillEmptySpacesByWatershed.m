function [finalImage] = fillEmptySpacesByWatershed(labelMaskPerim, invalidRegion)
%FILLEMPTYSPACESBYWATERSHED Summary of this function goes here
%   Detailed explanation goes here
    maskDist=bwdist(labelMaskPerim>0);
    maskWater=watershed(maskDist,4);
    %     maskDist=bwdist(maskWater>0);
    %     maskWater=watershed(maskDist,4);
    %figure;imshow(maskWater,c)
    maskWater(invalidRegion)=0;
    validArea=bwareaopen(maskWater,10,4);
    maskWater(~validArea & smallCellsImg == 0)=0;

    %figure;imshow(maskWater,c)

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
end

