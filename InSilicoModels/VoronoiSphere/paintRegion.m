function [ ] = paintRegion(x, y, z, regionPoints )
%PAINTREGION Summary of this function goes here
%   Detailed explanation goes here
    tri = delaunay(x(regionPoints), y (regionPoints));
    trisurf(tri, x(regionPoints), y (regionPoints), z (regionPoints));
    hold on;
end

