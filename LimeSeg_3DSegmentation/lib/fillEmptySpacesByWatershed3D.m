function [finalImage] = fillEmptySpacesByWatershed3D(labelMask, invalidRegion, putOriginalIndices)
%FILLEMPTYSPACESBYWATERSHED Summary of this function goes here
%   Detailed explanation goes here
    %labelMaskEroded = imerode(labelMask, strel('sphere', 1));
    
    labelMaskEroded = labelMask;
    for numCell = 1:max(labelMask(:))
        labelMaskPerim = bwperim(labelMask == numCell, 26);
        labelMaskEroded(labelMaskPerim) = 0;
    end
    
    maskDist=bwdist(labelMaskEroded>0);
    maskWater=watershed(maskDist, 26);
    %     maskDist=bwdist(maskWater>0);
    %     maskWater=watershed(maskDist,4);
    %figure;imshow(maskWater,c)
    maskWater(invalidRegion)=0;
    finalImage = double(maskWater);
    
    if exist('putOriginalIndices', 'var')
        if putOriginalIndices
            originalImageToRename = finalImage;

            for numCell = unique(finalImage(:))


            end

            finalImage = originalImageToRename;
        end
    end
end

