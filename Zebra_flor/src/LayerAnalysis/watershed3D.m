function [ imgWatersheded ] = watershed3D( imgDistanced, seeds )
%WATERSHED3D Summary of this function goes here
%   Detailed explanation goes here

    imgWatersheded = zeros(size(imgDistanced));
    for numSeed = 1:size(seeds, 1)
        actualSeed = seeds(numSeed, :);
        imgWithEdges = getEdgesOfCells(imgDistanced, actualSeed(1), actualSeed(2), actualSeed(3));
        imgWatersheded = imgWatersheded | imgWithEdges;
    end
end

