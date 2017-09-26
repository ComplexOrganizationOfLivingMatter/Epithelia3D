function [ transitionsCSVInfo ] = voronoi3DEllipsoid( centerOfEllipsoid, ellipsoidDimensions, maxNumberOfCellsInVoronoi, outputDir, hCellsPredefined )
%VORONOIONELLIPSOIDSURFACE Summary of this function goes here
%   Detailed explanation goes here
%

    %In case you want to debug
%    s = RandStream('mcg16807','Seed',0);
%    RandStream.setGlobalStream(s);

    if hCellsPredefined == -1
        hCellsPredefined = 0.5:0.5:(min(ellipsoidDimensions)-0.1);
    end

    %Init all the info for creating the voronoi
    ellipsoidInfo.xCenter = centerOfEllipsoid(1);
    ellipsoidInfo.yCenter = centerOfEllipsoid(2);
    ellipsoidInfo.zCenter = centerOfEllipsoid(3);

    ellipsoidInfo.xRadius = ellipsoidDimensions(1);
    ellipsoidInfo.yRadius = ellipsoidDimensions(2);
    ellipsoidInfo.zRadius = ellipsoidDimensions(3);
    
    ellipsoidInfo.bordersSituatedAt = [2/3, 1/2];

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

    %% Generate Random Centroids
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
    
    try
        transitionsCSVInfo = {};
        transitionsAngleCSV = {};
        initialCentroids = finalCentroids;
        [ finalCentroids] = getAugmentedCentroids( ellipsoidInfo, initialCentroids, max(hCellsPredefined));
        
        %Paint the ellipsoid voronoi
        create3DVoronoiFromCentroids(initialCentroids, finalCentroids, max(hCellsPredefined), ellipsoidInfo);

        numException = 0;
        for cellHeight = hCellsPredefined
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


            
%             [D] = pdist2([1 0 0],[xGridReducedEllip, yGridReducedEllip, zGridReducedEllip],'euclidean','Smallest',K)
%             find(D==min(D))
            
            [ finalCentroids] = getAugmentedCentroids( ellipsoidInfo, initialCentroids, cellHeight);
            
%             upSide = (ellipsoidInfo.xRadius - cellHeight)^2 * (ellipsoidInfo.yRadius - cellHeight)^2 * (ellipsoidInfo.zRadius - cellHeight)^2;
%             downSide = ((ellipsoidInfo.yRadius - cellHeight)^2 * (ellipsoidInfo.zRadius - cellHeight)^2 * finalCentroids(:, 1).^2) + ((ellipsoidInfo.xRadius - cellHeight)^2 * (ellipsoidInfo.zRadius - cellHeight)^2 * finalCentroids(:, 2).^2) + ((ellipsoidInfo.yRadius - cellHeight)^2 * (ellipsoidInfo.xRadius - cellHeight)^2 * finalCentroids(:, 3).^2);
%             conversorFactor = sqrt(upSide./downSide);
%             
%             finalCentroidsReducted = arrayfun(@(x, y) x * y, finalCentroids, repmat(conversorFactor, 1, 3));
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
                
                cellsTransition = find(cellfun(@(x, y) size(setxor(x, y), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood)>0, 1);
                tableDataAngles=[];
                if ~isempty(cellsTransition)
                    [tableDataAngles, anglesPerRegion, ellipsoidInfo] = getAnglesOfEdgeTransition( initialEllipsoid, ellipsoidInfo, outputDir);
                    close
                end
                
                if isempty(tableDataAngles)
                        tableDataAngles=NaN;
                        preffixName = {'averageAnglesLess15EndRight','averageAnglesBetw15_30EndRight', 'averageAnglesBetw30_45EndRight', 'averageAnglesBetw45_60EndRight', 'averageAnglesBetw60_75EndRight', 'averageAnglesMore75EndRight' ...
                        'averageAnglesLess15EndLeft','averageAnglesBetw15_30EndLeft', 'averageAnglesBetw30_45EndLeft', 'averageAnglesBetw45_60EndLeft', 'averageAnglesBetw60_75EndLeft', 'averageAnglesMore75EndLeft' ...
                        'averageAnglesLess15EndGlobal','averageAnglesBetw15_30EndGlobal', 'averageAnglesBetw30_45EndGlobal', 'averageAnglesBetw45_60EndGlobal', 'averageAnglesBetw60_75EndGlobal', 'averageAnglesMore75EndGlobal' ...
                        'averageAnglesLess15CentralRegion','averageAnglesBetw15_30CentralRegion', 'averageAnglesBetw30_45CentralRegion', 'averageAnglesBetw45_60CentralRegion', 'averageAnglesBetw60_75CentralRegion', 'averageAnglesMore75CentralRegion' ...
                        'percentageTransitionsEndLeft','percentageTransitionsEndRight','percentageTransitionsEndGlobal','percentageTransitionsCentralRegion', 'meanEdgeLengthEndLeft', 'meanEdgeLengthEndRight', 'meanEdgeLengthEndGlobal', 'meanEdgeLengthCentralRegion', 'stdEdgeLengthEndLeft', 'stdEdgeLengthEndRight', 'stdEdgeLengthEndGlobal', 'stdEdgeLengthCentralRegion'};
                        
                        totalVariables = {'averageAnglesLess15Total','averageAnglesBetw15_30Total', 'averageAnglesBetw30_45Total', 'averageAnglesBetw45_60Total', 'averageAnglesBetw60_75Total', 'averageAnglesMore75Total', 'percentageTransitionsPerCell', 'meanEdgeLength', 'stdEdgeLength'};
                        anglesPerRegion=array2table(NaN(size(totalVariables, 2) + (size(preffixName, 2))*size(initialEllipsoid.bordersSituatedAt, 2),1)');
                        
                        newVariableNames = cell(size(initialEllipsoid.bordersSituatedAt, 2), 1);
                        for numBorders = 1:size(initialEllipsoid.bordersSituatedAt, 2)
                            newVariableNames{numBorders} = cellfun(@(x) strcat(x, '_', num2str(round(ellipsoidInfo.bordersSituatedAt(numBorders)*100)), '_'), preffixName, 'UniformOutput', false);
                        end
                        anglesPerRegion.Properties.VariableNames = [totalVariables{:}, newVariableNames{:}];
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

