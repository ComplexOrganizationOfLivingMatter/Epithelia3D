function [labelledImage] = addCellToImage(pixelLocations, labelledImage, numCell)
%ADDCELLTOIMAGE Summary of this function goes here
%   Detailed explanation goes here
    % We added for the same x,y several zs, because we found that some
    % of the zs were not completed (i.e. some zs of some cells were
    % composed by only a few pixels).
    for numPixel = 1:size(pixelLocations, 1)
        %zPixels = pixelLocations(numPixel, 3)-numDepth:1:pixelLocations(numPixel, 3)+numDepth;
        %zPixels(zPixels < 1) = [];
        labelledImage(pixelLocations(numPixel, 1)+1, pixelLocations(numPixel, 2)+1, pixelLocations(numPixel, 3)+1) = numCell;
    end
    cellShape = alphaShape(pixelLocations, 20);
    [qx,qy,qz]=ind2sub(size(labelledImage),find(labelledImage == 0));
    try
        tf = inShape(cellShape,qx,qy,qz);
        inCellIndices = sub2ind(size(labelledImage), qx(tf), qy(tf), qz(tf));
        labelledImage(inCellIndices) = numCell;
    catch ex
        ex.rethrow();
    end
end

