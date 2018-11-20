function [labelMaskPerim] = unifyingNearCells(labelMaskPerim, invalidRegion)
%UNIFYINGNEARCELLS Unifying splitted near cells
%   Detailed explanation goes here

    connected4 = [0 1 0; 1 0 1; 0 1 0];
    edgePixels = find(labelMaskPerim == 0 & invalidRegion == 0);
    dilatedMask = zeros(size(labelMaskPerim));
%     hold on;
    for edgePixel = edgePixels'
        dilatedMask(edgePixel) = 1;
        values4Connected = labelMaskPerim(imdilate(dilatedMask, connected4)>0);
        values4ConnectedUnique = unique(values4Connected);
        values4ConnectedUnique(values4ConnectedUnique==0) = [];
        if length(values4ConnectedUnique) == 1
            labelMaskPerim(edgePixel) = values4ConnectedUnique;
%             [x,y] = ind2sub(size(finalImage), edgePixel);
%             plot(y, x, '*r')
        end
        dilatedMask(edgePixel) = 0;
    end
end

