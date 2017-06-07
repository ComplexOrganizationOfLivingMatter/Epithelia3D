numberOfPoints = 300;
numberOfCellsInVoronoi = 400;
minDistanceBetweenCentroids = 0.5;
xCenter = 0;
yCenter = 0;
zCenter = 0;
ellipsoidSurfaceArea(
[x, y, z] = ellipsoid(xCenter, yCenter, zCenter,5.9,3.25,3.25, numberOfPoints);

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
    
    minDistanceToExistingCentroids = min(pdist2(randomCentroid, centroids))
    if minDistanceToExistingCentroids > minDistanceBetweenCentroids
        numberOfCentroids = numberOfCentroids + 1;
        centroids(numberOfCentroids, :) = randomCentroid;
    end
end