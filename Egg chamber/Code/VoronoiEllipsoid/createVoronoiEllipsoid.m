numberOfPoints = 300;
numberOfCellsInVoronoi = 400;
xCenter = 0;
yCenter = 0;
zCenter = 0;
xRadius = 1;
yRadius = 0.6;
zRadius = 0.6;
areaOfEllipsoid = ellipsoidSurfaceArea([xRadius, yRadius, zRadius]);

minDistanceBetweenCentroids = areaOfEllipsoid / (numberOfCellsInVoronoi * 0.95);

[x, y, z] = ellipsoid(xCenter, yCenter, zCenter, xRadius, yRadius, zRadius, numberOfPoints);

numberOfCentroids = 1;
totalNumberOfPossibleCentroids = size(x, 1) * size(x, 1);

%First Centroid
indexRandomCentroid = randi(totalNumberOfPossibleCentroids);
randomCentroid = [x(indexRandomCentroid), y(indexRandomCentroid), z(indexRandomCentroid)];
centroids = randomCentroid;
%The rest centroids
while numberOfCentroids < numberOfCellsInVoronoi
    indexRandomCentroid = randi(totalNumberOfPossibleCentroids);
    randomCentroid = [x(indexRandomCentroid), y(indexRandomCentroid), z(indexRandomCentroid)];
    
    minDistanceToExistingCentroids = min(pdist2(randomCentroid, centroids));
    if minDistanceToExistingCentroids > minDistanceBetweenCentroids
        numberOfCentroids = numberOfCentroids + 1;
        centroids(numberOfCentroids, :) = randomCentroid;
    end
end
scatter3(centroids(:, 1), centroids(:, 2), centroids(:, 3))