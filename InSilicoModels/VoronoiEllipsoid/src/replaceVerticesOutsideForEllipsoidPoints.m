function [ goodPoints ] = replaceVerticesOutsideForEllipsoidPoints( badPoints, pointsInEllipsoid)
%REPLACECENTROIDSOUTSIDEFORELLIPSOIDCENTROIDS Summary of this function goes here
%   Detailed explanation goes here
    distanceMatrix = pdist2(badPoints, pointsInEllipsoid);
    [~, indices] = min(distanceMatrix, [], 2);
    goodPoints = pointsInEllipsoid(indices, :);
end

