function [labelledImage] = smoothCellContour3D(labelledImage, idCell, zToSmooth, lumenImage)
%SMOOTHCELLCONTOUR3D Summary of this function goes here
%   Detailed explanation goes here

    [x,y,z] = ind2sub(size(labelledImage),find(labelledImage == idCell));
    
    cellShape = alphaShape(x,y,z, 10);
    
    %zToSmooth = unique(z);
    
    [x,y,z] = ind2sub(size(labelledImage),find(labelledImage ~= idCell & lumenImage == 0));
    pixelsToCheck = ismember(z, zToSmooth);

    xToCheck = x(pixelsToCheck);
    yToCheck = y(pixelsToCheck);
    zToCheck = z(pixelsToCheck);
    
    inPixels = inShape(cellShape, xToCheck, yToCheck, zToCheck);
    
    for numInPixels = find(inPixels)'
        labelledImage(xToCheck(numInPixels), yToCheck(numInPixels), zToCheck(numInPixels)) = idCell;
    end
    
    labelledImage(lumenImage>0) = 0;
end

