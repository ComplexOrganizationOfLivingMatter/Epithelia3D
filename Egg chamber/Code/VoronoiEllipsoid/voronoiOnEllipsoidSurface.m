function [ ] = voronoiOnEllipsoidSurface( centerOfEllipsoid, ellipsoidDimensions, maxNumberOfCellsInVoronoi, minDistanceBetweenCentroids )
%VORONOIONELLIPSOIDSURFACE Summary of this function goes here
%   Detailed explanation goes here
    s = RandStream('mcg16807','Seed',0);
    RandStream.setGlobalStream(s);
    
    close all

    %Init all the info for creating the voronoi
    ellipsoidInfo.xCenter = centerOfEllipsoid(1);
    ellipsoidInfo.yCenter = centerOfEllipsoid(2);
    ellipsoidInfo.zCenter = centerOfEllipsoid(3);
    
    ellipsoidInfo.xRadius = ellipsoidDimensions(1);
    ellipsoidInfo.yRadius = ellipsoidDimensions(2);
    ellipsoidInfo.zRadius = ellipsoidDimensions(3);
    
    ellipsoidInfo.maxNumberOfCellsInVoronoi = maxNumberOfCellsInVoronoi;
    ellipsoidInfo.apicalReduction = 0;
    ellipsoidInfo.minDistanceBetweenCentroids = minDistanceBetweenCentroids;
    
    
    ellipsoidInfo.areaOfEllipsoid = ellipsoidSurfaceArea([ellipsoidInfo.xRadius, ellipsoidInfo.yRadius, ellipsoidInfo.zRadius]);

    %(resolutionEllipse + 1) * (resolutionEllipse + 1) number of points
    %generated at the surface of the ellipsoid
    ellipsoidInfo.resolutionEllipse = 300; %300 seems to be a good number
    [x, y, z] = ellipsoid(ellipsoidInfo.xCenter, ellipsoidInfo.yCenter, ellipsoidInfo.zCenter, ellipsoidInfo.xRadius, ellipsoidInfo.yRadius, ellipsoidInfo.zRadius, ellipsoidInfo.resolutionEllipse);
    
    totalNumberOfPossibleCentroids = size(x, 1) * size(x, 1);
    
    %The actual number of centroids that will be increased per iteration
    numberOfCentroids = 1;
    %First Centroid created
    indexRandomCentroid = randi(totalNumberOfPossibleCentroids);
    randomCentroid = [x(indexRandomCentroid), y(indexRandomCentroid), z(indexRandomCentroid)];
    finalCentroids = randomCentroid;
    %The remaining centroids
    %We'll add a maxNumberOfCellsInVoronoi or if the distance doesn't allow
    %us the number will be decreased
    while numberOfCentroids < maxNumberOfCellsInVoronoi && totalNumberOfPossibleCentroids ~= 0
        %Generate a random index
        indexRandomCentroid = randi(totalNumberOfPossibleCentroids);
        %Get the centroid
        randomCentroid = [x(indexRandomCentroid), y(indexRandomCentroid), z(indexRandomCentroid)];
        %Remove the centroid because we don't want to have the same
        %centroid twice
        x(indexRandomCentroid) = [];
        y(indexRandomCentroid) = [];
        z(indexRandomCentroid) = [];
        totalNumberOfPossibleCentroids = totalNumberOfPossibleCentroids - 1;

        %Check if the minimum distance is satisfaed
        minDistanceToExistingCentroids = min(pdist2(randomCentroid, finalCentroids));
        %If it is farther enough it can be added
        if minDistanceToExistingCentroids > minDistanceBetweenCentroids
            numberOfCentroids = numberOfCentroids + 1;
            finalCentroids(numberOfCentroids, :) = randomCentroid;
        end
    end
    
    %Paint the ellipsoid voronoi
    ellipsoidInfo.verticesPerCell = paintVoronoi(finalCentroids(:, 1), finalCentroids(:, 2), finalCentroids(:, 3), ellipsoidInfo.xRadius, ellipsoidInfo.yRadius, ellipsoidInfo.zRadius);
    [ ellipsoidInfo.polygonDistribution, ellipsoidInfo.neighbourhood ] = calculatePolygonDistributionFromVerticesInEllipsoid(finalCentroids, ellipsoidInfo.verticesPerCell);
    ellipsoidInfo.finalCentroids = finalCentroids;
    savefig(strcat('results/ellipsoid_x', num2str(ellipsoidInfo.xRadius), '_y', num2str(ellipsoidInfo.yRadius), '_z', num2str(ellipsoidInfo.zRadius), '.fig'));
    %Saving info
    save(strcat('results/ellipsoid_x', strrep(num2str(ellipsoidInfo.xRadius), '.', ''), '_y', strrep(num2str(ellipsoidInfo.yRadius), '.', ''), '_z', strrep(num2str(ellipsoidInfo.zRadius), '.', '')), 'ellipsoidInfo', 'minDistanceBetweenCentroids');
    
    for apicalReduction = 0.1:0.1:0.9
        ellipsoidInfo.apicalReduction = apicalReduction;
        %Creating the reduted centroids form the previous ones and the apical
        %reduction
        xReducted = finalCentroids(:, 1) * (ellipsoidInfo.xRadius - apicalReduction) / ellipsoidInfo.xRadius;
        yReducted = finalCentroids(:, 2) * (ellipsoidInfo.yRadius - apicalReduction) / ellipsoidInfo.yRadius;
        zReducted = finalCentroids(:, 3) * (ellipsoidInfo.zRadius - apicalReduction) / ellipsoidInfo.zRadius;

        ellipsoidInfo.verticesPerCell = paintVoronoi(xReducted, yReducted, zReducted, ellipsoidInfo.xRadius - apicalReduction, ellipsoidInfo.yRadius - apicalReduction, ellipsoidInfo.zRadius - apicalReduction);
        ellipsoidInfo.finalCentroids = horzcat([xReducted, yReducted, zReducted]);
        [ ellipsoidInfo.polygonDistribution, ellipsoidInfo.neighbourhood ] = calculatePolygonDistributionFromVerticesInEllipsoid(ellipsoidInfo.finalCentroids, ellipsoidInfo.verticesPerCell);
        savefig(strcat('results/ellipsoidReducted_x', num2str(ellipsoidInfo.xRadius), '_y', num2str(ellipsoidInfo.yRadius), '_z', num2str(ellipsoidInfo.zRadius), '_apicalReduction', num2str(apicalReduction), '.fig'));
        
        %Saving info
        save(strcat('results/ellipsoidReducted_x', strrep(num2str(ellipsoidInfo.xRadius), '.', ''), '_y', strrep(num2str(ellipsoidInfo.yRadius), '.', ''), '_z', strrep(num2str(ellipsoidInfo.zRadius), '.', ''), '_apicalReduction', strrep(num2str(apicalReduction), '.', ''), 'ellipsoidInfo', 'minDistanceBetweenCentroids');
    end
end

