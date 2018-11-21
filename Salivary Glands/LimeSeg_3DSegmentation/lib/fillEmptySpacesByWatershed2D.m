function [finalImage] = fillEmptySpacesByWatershed2D(labelMask, invalidRegion, colours)
%FILLEMPTYSPACESBYWATERSHED Summary of this function goes here
%   Detailed explanation goes here
    
    %% Create perim of cells
    labelMaskCleaned = bwareaopen(labelMask, 10);
    labelMaskCleaned = labelMask .* labelMaskCleaned;
    labelMaskEroded = zeros(size(labelMask));
    for numCell = 1:max(labelMask(:))
        % You always need to dilate the cell to unify possible separated
        % cells
        dilatedCell = imclose(labelMaskCleaned == numCell, strel('disk', 10));
        labelMaskEroded (imerode(dilatedCell, strel('disk', 2))) = numCell;
    end
    
    closedNeighbours = strel([0 1 0; 1 0 1; 0 1 0]);
    labelMaskFinal = labelMaskEroded;
    %% Remove neighbouring cells
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
%     centroids = regionprops(maskWater,'Centroid');
%     centroids = round(cat(1,centroids.Centroid));
    cellsWater = unique(maskWater);
    cellsWater=cellsWater(cellsWater~=0);
    
    unifiedCellsImage=zeros(size(maskWater));
%     dilatedMask = zeros(size(maskWater));
    for nCell = cellsWater'
%         dilatedMask(centroids(nCell,2),centroids(nCell,1)) = 1;
%         valuesSurroundingCentroid = labelMask(imdilate(dilatedMask, strel('disk', 3))> 0);
%         mostFrequentValue = mode(valuesSurroundingCentroid);
%         finalImage(maskWater==nCell) = mostFrequentValue;
%         
%         dilatedMask(centroids(nCell,2),centroids(nCell,1)) = 0;

        values = unique(labelMaskFinal(maskWater == nCell));
        
        unifiedCellsImage(maskWater == nCell) = values(values~=0);
    end
    
    %% Unify splitted cells
    [imgWater_Unified] = unifyingNearCells(unifiedCellsImage, invalidRegion);
    
    finalImage = double(imgWater_Unified);
end

