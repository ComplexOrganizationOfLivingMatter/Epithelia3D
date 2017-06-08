resolutionEllipse = 300;
numberOfCellsInVoronoi = 400;
xCenter = 0;
yCenter = 0;
zCenter = 0;
xRadius = 1;
yRadius = 1;
zRadius = 1;
areaOfEllipsoid = ellipsoidSurfaceArea([xRadius, yRadius, zRadius]);

minDistanceBetweenCentroids = (areaOfEllipsoid / (numberOfCellsInVoronoi)) + 3 * (pi / 2) / (2 * pi) * pi * max([xRadius, yRadius, zRadius])^2;

[x, y, z] = ellipsoid(xCenter, yCenter, zCenter, xRadius, yRadius, zRadius, resolutionEllipse);
x = x - min(min(x));
y = y - min(min(y));
z = z - min(min(z));

cellfun(@(actCentroid) sqrt(randomCentroid(1)^2 + actCentroid(1)^2 - 2*(randomCentroid(1)*actCentroid(1)) * (sin(randomCentroid(2)) * sin(randomCentroid(2)) * cos(randomCentroid(3) - actCentroid(3)) + cos(randomCentroid(2)) * cos(actCentroid(2)))), mat2cell(centroids, size(centroids, 1), 3));

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
    
    minDistanceToExistingCentroids = min(cellfun(@(actCentroid) sqrt(randomCentroid(1)^2 + actCentroid(1)^2 - 2*(randomCentroid(1)*actCentroid(1)) * (sin(randomCentroid(2)) * sin(randomCentroid(2)) * cos(randomCentroid(3) - actCentroid(3)) + cos(randomCentroid(2)) * cos(actCentroid(2)))), mat2cell(centroids, size(centroids, 1), 3)));
    if minDistanceToExistingCentroids > minDistanceBetweenCentroids
        numberOfCentroids = numberOfCentroids + 1;
        centroids(numberOfCentroids, :) = randomCentroid;
    end
end
scatter3(centroids(:, 1), centroids(:, 2), centroids(:, 3))
axis equal