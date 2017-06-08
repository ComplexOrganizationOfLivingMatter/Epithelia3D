resolutionEllipse = 300;
numberOfCellsInVoronoi = 400;
xCenter = 0;
yCenter = 0;
zCenter = 0;
xRadius = 1;
yRadius = 0.6;
zRadius = 0.6;
areaOfEllipsoid = ellipsoidSurfaceArea([xRadius, yRadius, zRadius]);

%minDistanceBetweenCentroids = (areaOfEllipsoid / (numberOfCellsInVoronoi)) + 3 * (pi / 2) / (2 * pi) * pi * max([xRadius, yRadius, zRadius])^2;
%minDistanceBetweenCentroids = (areaOfEllipsoid / (numberOfCellsInVoronoi));

[x, y, z] = ellipsoid(xCenter, yCenter, zCenter, xRadius, yRadius, zRadius, resolutionEllipse);
%x = x - min(min(abs(x)));
%y = y - min(min(abs(y)));
%z = z - min(min(abs(z)));

totalNumberOfPossibleCentroids = size(x, 1) * size(x, 1);
distanceMatrix = zeros(totalNumberOfPossibleCentroids, 1);
allCentroids = horzcat(x(:), y(:), z(:));
parfor indexCentroid = 1:totalNumberOfPossibleCentroids
    randomCentroid = [x(indexCentroid), y(indexCentroid), z(indexCentroid)];
    distanceMatrix(indexCentroid) = mean(pdist2(randomCentroid, allCentroids));
    %distanceMatrix(indexCentroid) = mean(cellfun(@(actCentroid) sqrt(randomCentroid(1)^2 + actCentroid(1)^2 - 2*(randomCentroid(1)*actCentroid(1)) * (sin(randomCentroid(2)) * sin(randomCentroid(2)) * cos(randomCentroid(3) - actCentroid(3)) + cos(randomCentroid(2)) * cos(actCentroid(2)))), mat2cell(allCentroids, size(allCentroids, 1), 3)));
end
minDistanceBetweenCentroids = mean(distanceMatrix) / areaOfEllipsoid;
%minDistanceBetweenCentroids = minDistanceBetweenCentroids / totalNumberOfPossibleCentroids * numberOfCellsInVoronoi;

numberOfCentroids = 1;

%First Centroid
indexRandomCentroid = randi(totalNumberOfPossibleCentroids);
randomCentroid = [x(indexRandomCentroid), y(indexRandomCentroid), z(indexRandomCentroid)];
centroids = randomCentroid;
radius = max([xRadius, yRadius, zRadius]);
%The rest centroids
while numberOfCentroids < numberOfCellsInVoronoi && totalNumberOfPossibleCentroids ~= 0
    indexRandomCentroid = randi(totalNumberOfPossibleCentroids);
    randomCentroid = [x(indexRandomCentroid), y(indexRandomCentroid), z(indexRandomCentroid)];
    x(indexRandomCentroid) = [];
    y(indexRandomCentroid) = [];
    z(indexRandomCentroid) = [];
    totalNumberOfPossibleCentroids = totalNumberOfPossibleCentroids - 1;
    
    minDistanceToExistingCentroids = min(pdist2(randomCentroid, centroids));
    if minDistanceToExistingCentroids > minDistanceBetweenCentroids
        numberOfCentroids = numberOfCentroids + 1;
        centroids(numberOfCentroids, :) = randomCentroid;
    end
end
size(centroids, 1)
scatter3(centroids(:, 1), centroids(:, 2), centroids(:, 3))
axis equal
paintVoronoi(centroids(:, 1), centroids(:, 2), centroids(:, 3));