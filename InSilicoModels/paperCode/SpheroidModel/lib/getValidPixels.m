function [ validPxs, innerLayerPxs, outterLayerPxs ] = getValidPixels(pxXs, pxYs, pxZs, ellipsoidInfo, cellHeight )
%GETVALIDPIXELS Get the valid pixels of the ellipsoid
%   While discarding the pixels of the image that do not belong to the
%   given ellipsoid.

    pxsInOutterLayer = (((((single(pxXs)/ellipsoidInfo.resolutionFactor) - ellipsoidInfo.xCenter)).^2) / (ellipsoidInfo.xRadius + cellHeight)^2) + (((((single(pxYs)/ellipsoidInfo.resolutionFactor)- ellipsoidInfo.yCenter)).^2) / (ellipsoidInfo.yRadius + cellHeight)^2) + (((((single(pxZs)/ellipsoidInfo.resolutionFactor)- ellipsoidInfo.zCenter)).^2) / (ellipsoidInfo.zRadius + cellHeight)^2);

    pxsInInnerLayer = (((((single(pxXs)/ellipsoidInfo.resolutionFactor)- ellipsoidInfo.xCenter)).^2) / ellipsoidInfo.xRadius^2) + (((((single(pxYs)/ellipsoidInfo.resolutionFactor)- ellipsoidInfo.yCenter)).^2) / ellipsoidInfo.yRadius^2) + (((((single(pxZs)/ellipsoidInfo.resolutionFactor)- ellipsoidInfo.zCenter)).^2) / ellipsoidInfo.zRadius^2);

    validPxs = pxsInInnerLayer >= 0.985 & pxsInOutterLayer <= 1.015;
    innerLayerPxs = pxsInInnerLayer >= 0.985 & pxsInInnerLayer < 1.015;
    outterLayerPxs = pxsInOutterLayer > 0.985 & pxsInOutterLayer <= 1.015;
end

