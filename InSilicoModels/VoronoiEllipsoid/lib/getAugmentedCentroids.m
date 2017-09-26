function [ finalCentroidsAugmented ] = getAugmentedCentroids( ellipsoidInfo, initialCentroids, cellHeight )
%GETAUGMENTEDCENTROIDS Summary of this function goes here
%   Detailed explanation goes here
    [xGridAugmentedEllip, yGridAugmentedEllip, zGridAugmentedEllip] = ellipsoid(ellipsoidInfo.xCenter, ellipsoidInfo.yCenter, ellipsoidInfo.zCenter, ellipsoidInfo.xRadius + cellHeight, ellipsoidInfo.yRadius + cellHeight, ellipsoidInfo.zRadius + cellHeight, ellipsoidInfo.resolutionEllipse);

    [nPoints,~]=size(xGridAugmentedEllip);
    xGridAugmentedEllip=reshape(xGridAugmentedEllip,nPoints*nPoints,1);
    yGridAugmentedEllip=reshape(yGridAugmentedEllip,nPoints*nPoints,1);
    zGridAugmentedEllip=reshape(zGridAugmentedEllip,nPoints*nPoints,1);

    newGrid=unique([xGridAugmentedEllip, yGridAugmentedEllip, zGridAugmentedEllip],'rows');
    finalCentroidsCell=mat2cell(initialCentroids,ones(size(initialCentroids,1),1));

    finalCentroidsAugmented=cell2mat(cellfun(@(x) newGrid(pdist2(x, newGrid)==min(pdist2(x, newGrid)),:), finalCentroidsCell, 'UniformOutput', false));
end

