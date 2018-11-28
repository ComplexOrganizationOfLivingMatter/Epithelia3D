function [labelledImage] = smoothObject(labelledImage,pixelLocations, numCell)
%SMOOTHOBJECT Summary of this function goes here
%   Detailed explanation goes here
    cellShape = alphaShape(pixelLocations, 20, 'HoleThreshold', size(labelledImage, 1)*size(labelledImage, 2)/2);
    [qx,qy,qz]=ind2sub(size(labelledImage),find(labelledImage == 0));
    actualCell = zeros(size(labelledImage));
    if numCell == -1
        lumenImage = 1;
        numCell = 1;
    else
        lumenImage = 0;
    end
    try
        tf = inShape(cellShape,qx,qy,qz);
        inCellIndices = sub2ind(size(labelledImage), qx(tf), qy(tf), qz(tf));
        actualCell(inCellIndices) = 1;
        actualCell(labelledImage == numCell) = 1;
        filledCell = imfill(double(actualCell),  4, 'holes');
        if lumenImage
            filledCellOpen = imopen(filledCell, strel('sphere', 2));
        else
            filledCellOpen = filledCell;
        end
        labelledImage(filledCellOpen>0) = numCell;
        %labelledImage(filledCell) = numCell;
    catch ex
        ex.rethrow();
    end
end

