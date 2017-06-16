function [ ] = voronoiOnEllipsoidSurface( centerOfEllipsoid, ellipsoidDimensions, maxNumberOfCellsInVoronoi, minDistanceBetweenCentroids )
%VORONOIONELLIPSOIDSURFACE Summary of this function goes here
%   Detailed explanation goes here
    s = RandStream('mcg16807','Seed',0);
    RandStream.setGlobalStream(s);

    %Init all the info for creating the voronoi
    ellipsoidInfo.xCenter = centerOfEllipsoid(1);
    ellipsoidInfo.yCenter = centerOfEllipsoid(2);
    ellipsoidInfo.zCenter = centerOfEllipsoid(3);

    ellipsoidInfo.xRadius = ellipsoidDimensions(1);
    ellipsoidInfo.yRadius = ellipsoidDimensions(2);
    ellipsoidInfo.zRadius = ellipsoidDimensions(3);

    ellipsoidInfo.maxNumberOfCellsInVoronoi = maxNumberOfCellsInVoronoi;
    ellipsoidInfo.cellHeight = 0;
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
    [ellipsoidInfo.verticesPerCell,ellipsoidInfo.verticesPerCellOutlayers]  = paintVoronoi(finalCentroids(:, 1), finalCentroids(:, 2), finalCentroids(:, 3), ellipsoidInfo.xRadius, ellipsoidInfo.yRadius, ellipsoidInfo.zRadius);
    ellipsoidInfo.finalCentroids = finalCentroids;

    [ ellipsoidInfo ] = refineVerticesOfVoronoi( ellipsoidInfo );

    [ ellipsoidInfo.polygonDistribution, ellipsoidInfo.neighbourhood ] = calculatePolygonDistributionFromVerticesInEllipsoid(finalCentroids, ellipsoidInfo.verticesPerCell);
    savefig(strcat('..\resultsVoronoiEllipsoid/ellipsoid_x', num2str(ellipsoidInfo.xRadius), '_y', num2str(ellipsoidInfo.yRadius), '_z', num2str(ellipsoidInfo.zRadius), '.fig'));
    %Saving info
    save(strcat('..\resultsVoronoiEllipsoid/ellipsoid_x', strrep(num2str(ellipsoidInfo.xRadius), '.', ''), '_y', strrep(num2str(ellipsoidInfo.yRadius), '.', ''), '_z', strrep(num2str(ellipsoidInfo.zRadius), '.', '')), 'ellipsoidInfo', 'minDistanceBetweenCentroids');
    initialNeighbourhood = ellipsoidInfo.neighbourhood;

    for cellHeight = 0.5:0.5:(min(ellipsoidDimensions)-0.1)
        ellipsoidInfo.cellHeight = cellHeight;
        %Creating the reduted centroids form the previous ones and the apical
        %reduction
        xReducted = finalCentroids(:, 1) * (ellipsoidInfo.xRadius - cellHeight) / ellipsoidInfo.xRadius;
        yReducted = finalCentroids(:, 2) * (ellipsoidInfo.yRadius - cellHeight) / ellipsoidInfo.yRadius;
        zReducted = finalCentroids(:, 3) * (ellipsoidInfo.zRadius - cellHeight) / ellipsoidInfo.zRadius;
        try
            [ellipsoidInfo.verticesPerCell, ellipsoidInfo.verticesPerCellOutlayers] = paintVoronoi(xReducted, yReducted, zReducted, ellipsoidInfo.xRadius - cellHeight, ellipsoidInfo.yRadius - cellHeight, ellipsoidInfo.zRadius - cellHeight);
            ellipsoidInfo.finalCentroids = horzcat([xReducted, yReducted, zReducted]);
            [ ellipsoidInfo ] = refineVerticesOfVoronoi( ellipsoidInfo );

            [ ellipsoidInfo.polygonDistribution, ellipsoidInfo.neighbourhood ] = calculatePolygonDistributionFromVerticesInEllipsoid(ellipsoidInfo.finalCentroids, ellipsoidInfo.verticesPerCell);
            savefig(strcat('..\resultsVoronoiEllipsoid/ellipsoidReducted_x', num2str(ellipsoidInfo.xRadius), '_y', num2str(ellipsoidInfo.yRadius), '_z', num2str(ellipsoidInfo.zRadius), '_cellHeight', num2str(cellHeight), '.fig'));

            %Saving info
            save(strcat('..\resultsVoronoiEllipsoid/ellipsoidReducted_x', strrep(num2str(ellipsoidInfo.xRadius), '.', ''), '_y', strrep(num2str(ellipsoidInfo.yRadius), '.', ''), '_z', strrep(num2str(ellipsoidInfo.zRadius), '.', ''), '_cellHeight', strrep(num2str(cellHeight), '.', '')), 'ellipsoidInfo', 'minDistanceBetweenCentroids');

            %Creating heatmap
            paintHeatmapOfTransitions( ellipsoidInfo, initialNeighbourhood,  cellHeight);
            savefig(strcat('..\resultsVoronoiEllipsoid/heatMap_ellipsoidReducted_x', num2str(ellipsoidInfo.xRadius), '_y', num2str(ellipsoidInfo.yRadius), '_z', num2str(ellipsoidInfo.zRadius), '_cellHeight', num2str(cellHeight), '.fig'));
        catch mexception
            disp(strcat('Error in creating ellipsoid xRadius=', num2str(ellipsoidInfo.xRadius), ', yRadius=', num2str(ellipsoidInfo.yRadius), ', zRadius=', num2str(ellipsoidInfo.zRadius), ' and cell height=', num2str(cellHeight)));
            disp(mexception.getReport);
            disp('--------------------------');
        end
    end
    %You can see the figures:
    %set(get(0,'children'),'visible','on')
end

