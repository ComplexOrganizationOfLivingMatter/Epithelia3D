function [ validPxs, innerLayerPxs, outterLayerPxs ] = getValidPixels(pxXs, pxYs, pxZs, ellipsoidInfo, cellHeight )
%GETVALIDPIXELS Summary of this function goes here
%   Detailed explanation goes here
    pxsInOutterLayer = ((((pxXs / ellipsoidInfo.resolutionFactor) - ellipsoidInfo.xOffset).^2) / (ellipsoidInfo.xRadius + cellHeight)^2) + ((((pxYs / ellipsoidInfo.resolutionFactor) - ellipsoidInfo.yOffset).^2) / (ellipsoidInfo.yRadius + cellHeight)^2) + ((((pxZs / ellipsoidInfo.resolutionFactor) - ellipsoidInfo.zOffset).^2) / (ellipsoidInfo.zRadius + cellHeight)^2);

    pxsInInnerLayer = ((((pxXs / ellipsoidInfo.resolutionFactor) - ellipsoidInfo.xOffset).^2) / ellipsoidInfo.xRadius^2) + ((((pxYs / ellipsoidInfo.resolutionFactor) - ellipsoidInfo.yOffset).^2) / ellipsoidInfo.yRadius^2) + ((((pxZs / ellipsoidInfo.resolutionFactor) - ellipsoidInfo.zOffset).^2) / ellipsoidInfo.zRadius^2);

    validPxs = pxsInInnerLayer > 0.98 & pxsInOutterLayer < 1.02;
    innerLayerPxs = pxsInInnerLayer > 0.99 & pxsInInnerLayer < 1.01;
    outterLayerPxs = pxsInOutterLayer > 0.99 & pxsInOutterLayer < 1.01;
end

