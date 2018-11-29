function [outsideGland] = getOutsideGland(labelledImage)
%GETOUTSIDEGLAND Summary of this function goes here
%   Detailed explanation goes here
    [allX,allY,allZ] = ind2sub(size(labelledImage),find(zeros(size(labelledImage))==0));
    [x, y, z] = ind2sub(size(labelledImage), find(labelledImage>0));
    glandObject = alphaShape(x, y, z, 5);


    numPartitions = 100;
    partialPxs = ceil(length(allX)/numPartitions);
    idIn = false(length(allX),1);
    for nPart = 1 : numPartitions
        subIndCoord = (1 + (nPart-1) * partialPxs) : (nPart * partialPxs);
        if nPart == numPartitions
            subIndCoord = (1 + (nPart-1) * partialPxs) : length(allX);
        end
        idIn(subIndCoord) = glandObject.inShape([allX(subIndCoord),allY(subIndCoord),allZ(subIndCoord)]);
    end
    outsideGland = true(size(labelledImage));
    outsideGland(idIn) = 0;
end

