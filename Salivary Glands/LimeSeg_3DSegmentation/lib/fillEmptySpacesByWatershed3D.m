function [finalImage] = fillEmptySpacesByWatershed3D(labelMask, invalidRegion)
%FILLEMPTYSPACESBYWATERSHED Summary of this function goes here
%   Detailed explanation goes here
    labelMaskEroded = imerode(labelMask, strel('sphere', 3));
    maskDist=bwdist(labelMaskEroded>0);
    maskWater=watershed(maskDist, 26);
    %     maskDist=bwdist(maskWater>0);
    %     maskWater=watershed(maskDist,4);
    %figure;imshow(maskWater,c)
    maskWater(invalidRegion)=0;

    %figure;imshow(maskWater,c)

    %% relabel cells with original labels
    centroids = regionprops(maskWater,'Centroid');
    centroids = round(cat(1,centroids.Centroid));
    cellsWater = unique(maskWater);
    cellsWater=cellsWater(cellsWater~=0);

    finalImage=zeros(size(maskWater));
    for nCell = cellsWater'
        finalImage(maskWater==nCell) = labelMask(maskWater==nCell);
    end
end

