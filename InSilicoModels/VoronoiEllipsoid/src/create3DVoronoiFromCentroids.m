function [ img3D ] = create3DVoronoiFromCentroids( centroids,  augmentedCentroids)
%CREATE3DVORONOIFROMCENTROIDS Summary of this function goes here
%   Detailed explanation goes here

    resolutionFactor = 20;

    centroids(:, 1) = centroids(:, 1) + abs(min(augmentedCentroids(:, 1)));
    augmentedCentroids(:, 1) = augmentedCentroids(:, 1) + abs(min(augmentedCentroids(:, 1)));
    
    centroids(:, 2) = centroids(:, 2) + abs(min(augmentedCentroids(:, 2)));
    augmentedCentroids(:, 2) = augmentedCentroids(:, 2) + abs(min(augmentedCentroids(:, 2)));
    
    centroids(:, 3) = centroids(:, 3) + abs(min(augmentedCentroids(:, 3)));
    augmentedCentroids(:, 3) = augmentedCentroids(:, 3) + abs(min(augmentedCentroids(:, 3)));

    centroids = round(centroids * resolutionFactor) + 1;
    augmentedCentroids = round(augmentedCentroids * resolutionFactor) + 1;
    
    img3D = zeros(max(augmentedCentroids));

    for numCentroid = 1:size(centroids, 1)
        img3D = Drawline3D(img3D, centroids(numCentroid, 1), centroids(numCentroid, 2), centroids(numCentroid, 3), augmentedCentroids(numCentroid, 1), augmentedCentroids(numCentroid, 2), augmentedCentroids(numCentroid, 3), numCentroid);
    end
    
    imgWithDistances = bwdist(img3D);
end

