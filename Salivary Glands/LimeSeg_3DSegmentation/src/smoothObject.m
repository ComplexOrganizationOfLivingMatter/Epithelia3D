function [labelledImage] = smoothObject(labelledImage,pixelLocations, numCell)
%SMOOTHOBJECT Summary of this function goes here
%   Detailed explanation goes here
    cellShape = alphaShape(pixelLocations, 20, 'HoleThreshold', size(labelledImage, 1)*size(labelledImage, 2)/2);
    [qx,qy,qz]=ind2sub(size(labelledImage),find(labelledImage == 0));
    try
        tf = inShape(cellShape,qx,qy,qz);
        inCellIndices = sub2ind(size(labelledImage), qx(tf), qy(tf), qz(tf));
        labelledImage(inCellIndices) = numCell;
        filledCell = imfill(double(labelledImage==numCell),  4, 'holes');
        filledCellOpen = imopen(filledCell, strel('sphere', 1));
        labelledImage(filledCellOpen>0) = numCell;
        %labelledImage(filledCell) = numCell;
    catch ex
        ex.rethrow();
    end
end

