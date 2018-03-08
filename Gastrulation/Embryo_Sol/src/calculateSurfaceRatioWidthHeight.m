function [ res ] = calculateSurfaceRatioWidthHeight( trackingInfo )
%CALCULATESURFACERATIOWIDTHHEIGHT Summary of this function goes here
%   Detailed explanation goes here

    regionPropsInitial = trackingInfo.regionPropsInitial;
    bboxRegionProps = vertcat(regionPropsInitial.BoundingBox);
    initialXWidth = bboxRegionProps(trackingInfo.validCell > 0, 3); %Width
    initialYWidth = bboxRegionProps(trackingInfo.validCell > 0, 4); %Height

    regionPropsEnd = trackingInfo.regionPropsEnd;
    bboxRegionProps = vertcat(regionPropsEnd.BoundingBox);
    endXWidth = bboxRegionProps(trackingInfo.validCell > 0, 3); %Width
    endYWidth = bboxRegionProps(trackingInfo.validCell > 0, 4); %Height

    diffWidth = initialXWidth ./ endXWidth;
    diffHeight = initialXWidth ./ endXWidth;

    res = [mean(diffWidth) std(diffWidth) mean(diffHeight) std(diffHeight)];

end

