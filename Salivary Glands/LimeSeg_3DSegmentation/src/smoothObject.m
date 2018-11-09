function [labelledImage] = smoothObject(labelledImage,pixelLocations, numCell)
%SMOOTHOBJECT Summary of this function goes here
%   Detailed explanation goes here
    cellShape = alphaShape(pixelLocations, 10);
    [qx,qy,qz]=ind2sub(size(labelledImage),find(labelledImage == 0));
    try
        tf = inShape(cellShape,qx,qy,qz);
        inCellIndices = sub2ind(size(labelledImage), qx(tf), qy(tf), qz(tf));
        labelledImage(inCellIndices) = numCell;
        c = imfill(double(labelledImage==numCell),  4, 'holes');
        labelledImage(c>0) = numCell;
        %labelledImage(filledCell) = numCell;
    catch ex
        ex.rethrow();
    end
end

