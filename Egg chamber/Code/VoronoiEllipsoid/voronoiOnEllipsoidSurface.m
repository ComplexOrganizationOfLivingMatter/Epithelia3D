function [ transitionsCSVInfo ] = voronoiOnEllipsoidSurface( centerOfEllipsoid, ellipsoidDimensions, maxNumberOfCellsInVoronoi, outputDir )
%VORONOIONELLIPSOIDSURFACE Summary of this function goes here
%   Detailed explanation goes here
%

    %In case you want to debug
%    s = RandStream('mcg16807','Seed',0);
%    RandStream.setGlobalStream(s);

    %Init all the info for creating the voronoi
    ellipsoidInfo.xCenter = centerOfEllipsoid(1);
    ellipsoidInfo.yCenter = centerOfEllipsoid(2);
    ellipsoidInfo.zCenter = centerOfEllipsoid(3);

    ellipsoidInfo.xRadius = ellipsoidDimensions(1);
    ellipsoidInfo.yRadius = ellipsoidDimensions(2);
    ellipsoidInfo.zRadius = ellipsoidDimensions(3);

    ellipsoidInfo.maxNumberOfCellsInVoronoi = maxNumberOfCellsInVoronoi;
    ellipsoidInfo.cellHeight = 0;

    ellipsoidInfo.areaOfEllipsoid = ellipsoidSurfaceArea([ellipsoidInfo.xRadius, ellipsoidInfo.yRadius, ellipsoidInfo.zRadius]);

    ellipsoidInfo.minDistanceBetweenCentroids = (ellipsoidInfo.areaOfEllipsoid / maxNumberOfCellsInVoronoi) * (0.50 - ((sum([ellipsoidInfo.xRadius, ellipsoidInfo.yRadius, ellipsoidInfo.zRadius])-30)/ 90));
    minDistanceBetweenCentroids = ellipsoidInfo.minDistanceBetweenCentroids;
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

    %totalNumberOfPossibleCentroids
    %size(finalCentroids, 1)
    
    try
        transitionsCSVInfo = {};
        transitionsAngleCSV = {};
        
        %Paint the ellipsoid voronoi
        [ellipsoidInfo.verticesPerCell,ellipsoidInfo.verticesPerCellOutlayers]  = paintVoronoi(finalCentroids(:, 1), finalCentroids(:, 2), finalCentroids(:, 3), ellipsoidInfo.xRadius, ellipsoidInfo.yRadius, ellipsoidInfo.zRadius);
        ellipsoidInfo.finalCentroids = finalCentroids;
        close
        [ ellipsoidInfo ] = refineVerticesOfVoronoi( ellipsoidInfo );

        [ ellipsoidInfo.polygonDistribution, ellipsoidInfo.neighbourhood ] = calculatePolygonDistributionFromVerticesInEllipsoid(finalCentroids, ellipsoidInfo.verticesPerCell);
        savefig(strcat(outputDir, '\ellipsoid_x', num2str(ellipsoidInfo.xRadius), '_y', num2str(ellipsoidInfo.yRadius), '_z', num2str(ellipsoidInfo.zRadius), '.fig'));
        
        %Saving info
        save(strcat(outputDir, '\ellipsoid_x', strrep(num2str(ellipsoidInfo.xRadius), '.', ''), '_y', strrep(num2str(ellipsoidInfo.yRadius), '.', ''), '_z', strrep(num2str(ellipsoidInfo.zRadius), '.', '')), 'ellipsoidInfo', 'minDistanceBetweenCentroids');
        initialEllipsoid = ellipsoidInfo;
        close

        numException = 0;
        for cellHeight = 0.5:0.5:(min(ellipsoidDimensions)-0.1)
            ellipsoidInfo.cellHeight = cellHeight;
            %Creating the reduted centroids form the previous ones and the apical
            %reduction
            % 2nd try
%             xReduction = (sqrt(((ellipsoidInfo.yRadius - cellHeight)^2 + (ellipsoidInfo.zRadius - cellHeight)^2) / 2)) / (sqrt((ellipsoidInfo.yRadius^2 + ellipsoidInfo.zRadius^2) / 2));
%             yReduction = (sqrt(((ellipsoidInfo.xRadius - cellHeight)^2 + (ellipsoidInfo.zRadius - cellHeight)^2) / 2)) / (sqrt((ellipsoidInfo.xRadius^2 + ellipsoidInfo.zRadius^2) / 2));
%             zReduction = (sqrt(((ellipsoidInfo.yRadius - cellHeight)^2 + (ellipsoidInfo.xRadius - cellHeight)^2) / 2)) / (sqrt((ellipsoidInfo.yRadius^2 + ellipsoidInfo.xRadius^2) / 2));
%             xReducted = finalCentroids(:, 1) * xReduction;
%             yReducted = finalCentroids(:, 2) * yReduction;
%             zReducted = finalCentroids(:, 3) * zReduction;
            % 1st try
%             xReducted = finalCentroids(:, 1) * (ellipsoidInfo.xRadius - cellHeight) / ellipsoidInfo.xRadius;
%             yReducted = finalCentroids(:, 2) * (ellipsoidInfo.yRadius - cellHeight) / ellipsoidInfo.yRadius;
%             zReducted = finalCentroids(:, 3) * (ellipsoidInfo.zRadius - cellHeight) / ellipsoidInfo.zRadius;
            upSide = (ellipsoidInfo.xRadius - cellHeight)^2 * (ellipsoidInfo.yRadius - cellHeight)^2 * (ellipsoidInfo.zRadius - cellHeight)^2;
            downSide = ((ellipsoidInfo.yRadius - cellHeight)^2 * (ellipsoidInfo.zRadius - cellHeight)^2 * finalCentroids(:, 1).^2) + ((ellipsoidInfo.xRadius - cellHeight)^2 * (ellipsoidInfo.zRadius - cellHeight)^2 * finalCentroids(:, 2).^2) + ((ellipsoidInfo.yRadius - cellHeight)^2 * (ellipsoidInfo.xRadius - cellHeight)^2 * finalCentroids(:, 3).^2);
            conversorFactor = sqrt(upSide./downSide);
            
            finalCentroidsReducted = arrayfun(@(x, y) x * y, finalCentroids, repmat(conversorFactor, 1, 3));
            %indicesOutsideEllipsoid = (finalCentroidsReducted(:, 1).^2 / (ellipsoidInfo.xRadius - cellHeight)^2) + (finalCentroidsReducted(:, 2).^ 2 / (ellipsoidInfo.yRadius - cellHeight)^2) + (finalCentroidsReducted(:, 3).^2 / (ellipsoidInfo.zRadius - cellHeight)^2);
            try
                [ellipsoidInfo.verticesPerCell, ellipsoidInfo.verticesPerCellOutlayers] = paintVoronoi(finalCentroidsReducted(:, 1), finalCentroidsReducted(:, 2), finalCentroidsReducted(:, 3), ellipsoidInfo.xRadius - cellHeight, ellipsoidInfo.yRadius - cellHeight, ellipsoidInfo.zRadius - cellHeight);
                close
                ellipsoidInfo.finalCentroids = finalCentroidsReducted;
                [ ellipsoidInfo ] = refineVerticesOfVoronoi( ellipsoidInfo );

                [ ellipsoidInfo.polygonDistribution, ellipsoidInfo.neighbourhood ] = calculatePolygonDistributionFromVerticesInEllipsoid(ellipsoidInfo.finalCentroids, ellipsoidInfo.verticesPerCell);
                savefig(strcat(outputDir, '\ellipsoidReducted_x', num2str(ellipsoidInfo.xRadius), '_y', num2str(ellipsoidInfo.yRadius), '_z', num2str(ellipsoidInfo.zRadius), '_cellHeight', num2str(cellHeight), '.fig'));
                
                close
                %Creating heatmap
                newRowTable = paintHeatmapOfTransitions( ellipsoidInfo, initialEllipsoid, outputDir);
                close
                
                cellsTransition = find(cellfun(@(x, y) size(setxor(x, y), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood)>0);
                if ~isempty(cellsTransition)
                    [tableDataAngles, anglesPerRegion] = getAnglesOfEdgeTransition( initialEllipsoid, ellipsoidInfo, outputDir,cellsTransition );
                    close
                else
                    tableDataAngles=NaN;
                    anglesPerRegion=array2table(NaN(15,1)');
                    anglesPerRegion.Properties.VariableNames = {'averLess30EndRight','averBetw30_60EndRight','averMore60EndRight','averLess30EndLeft','averBetw30_60EndLeft','averMore60EndLeft','averLess30EndGlobal','averBetw30_60EndGlobal','averMore60EndGlobal','averLess30CentralRegion','averBetw30_60CentralRegion','averMore60CentralRegion','numAnglesEndLeft','numAnglesCentralRegion','numAnglesEndRight'};
                    anglesPerRegion=table2struct(anglesPerRegion);
                end
                %Saving info
                save(strcat(outputDir, '\ellipsoidReducted_x', strrep(num2str(ellipsoidInfo.xRadius), '.', ''), '_y', strrep(num2str(ellipsoidInfo.yRadius), '.', ''), '_z', strrep(num2str(ellipsoidInfo.zRadius), '.', ''), '_cellHeight', strrep(num2str(cellHeight), '.', '')), 'ellipsoidInfo', 'minDistanceBetweenCentroids', 'tableDataAngles');
                               
                transitionsCSVInfo(end+1) = {horzcat(struct2table(newRowTable), struct2table(anglesPerRegion))};
            catch mexception
                disp(strcat('Error in creating ellipsoid xRadius=', num2str(ellipsoidInfo.xRadius), ', yRadius=', num2str(ellipsoidInfo.yRadius), ', zRadius=', num2str(ellipsoidInfo.zRadius), ' and cell height=', num2str(cellHeight)));
                disp(mexception.getReport);
                disp('--------------------------');
                numException = numException + 1;
                if numException > 1
                    break
                end
            end
        end
    catch mexception
        disp(strcat('Error in creating initial ellipsoid xRadius=', num2str(ellipsoidInfo.xRadius), ', yRadius=', num2str(ellipsoidInfo.yRadius), ', zRadius=', num2str(ellipsoidInfo.zRadius)));
        disp(strcat('Number of centroids = ', num2str(size(finalCentroids, 1))));
        disp(mexception.getReport);
        disp('--------------------------');
    end
        %You can see the figures:
        %set(get(0,'children'),'visible','on')
end

