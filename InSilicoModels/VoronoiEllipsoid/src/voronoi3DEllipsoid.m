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

    ellipsoidInfo.minDistanceBetweenCentroids = (ellipsoidInfo.areaOfEllipsoid*2.3 / maxNumberOfCellsInVoronoi);
    minDistanceBetweenCentroids = ellipsoidInfo.minDistanceBetweenCentroids;
    %(resolutionEllipse + 1) * (resolutionEllipse + 1) number of points
    %generated at the surface of the ellipsoid
    ellipsoidInfo.resolutionEllipse = 300; %300 seems to be a good number
    [x, y, z] = ellipsoid(ellipsoidInfo.xCenter, ellipsoidInfo.yCenter, ellipsoidInfo.zCenter, ellipsoidInfo.xRadius, ellipsoidInfo.yRadius, ellipsoidInfo.zRadius, ellipsoidInfo.resolutionEllipse);

    totalNumberOfPossibleCentroids = size(x, 1) * size(x, 1);

    %% Generate Random Centroids
    disp('Init Random centroids')
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
    
    clearvars randomCentroid indexRandomCentroid x y z
    
    disp('End Random centroids')
    
%     try
        transitionsCSVInfo = {};
        transitionsAngleCSV = {};
        ellipsoidInfo.centroids = finalCentroids;
        initialEllipsoid = ellipsoidInfo;
        [ ellipsoidInfo.centroids ] = getAugmentedCentroids( ellipsoidInfo, finalCentroids, max(hCellsPredefined));
        
        %Paint the ellipsoid voronoi
        disp('Creating Random voronoi')
        [ img3DLabelled, ellipsoidInfo, newOrderOfCentroids ] = create3DVoronoiFromCentroids(initialEllipsoid.centroids, ellipsoidInfo.centroids, max(hCellsPredefined), ellipsoidInfo, outputDir);
        initialEllipsoid.centroids = initialEllipsoid.centroids(newOrderOfCentroids, :);
        close
        disp('Random voronoi created')
        
        initialEllipsoid.neighbourhood = [];
        
        % Get all the pixels of the image
        [allXs, allYs, allZs] = findND(img3DLabelled > 0);
        numException = 0;
        
        for cellHeight = hCellsPredefined
            cellHeight
            ellipsoidInfo.cellHeight = cellHeight;
            
            [ validPxs, innerLayerPxs, outterLayerPxs ] = getValidPixels(allXs, allYs, allZs, ellipsoidInfo, cellHeight);
            img3DLabelledActual = img3DLabelled;
            novalidIndices = sub2ind(size(img3DLabelled), allXs(validPxs == 0), allYs(validPxs == 0), allZs(validPxs == 0));
            img3DLabelledActual(novalidIndices) = 0;
            img3DOutterLayer = zeros(size(img3DLabelled));
            outterLayerIndices = sub2ind(size(img3DLabelled), allXs(outterLayerPxs), allYs(outterLayerPxs), allZs(outterLayerPxs));
            img3DOutterLayer(outterLayerIndices) = img3DLabelledActual(outterLayerIndices);
            
            disp('Getting info of vertices and neighbours: outter layer');
            ellipsoidInfo.img3DLayer = img3DOutterLayer;
            [ellipsoidInfo.neighbourhood] = calculate_neighbours3D(img3DOutterLayer);
            [ellipsoidInfo.verticesPerCell, ellipsoidInfo.verticesConnectCells] = getVertices3D(img3DOutterLayer, ellipsoidInfo.neighbourhood, ellipsoidInfo);
            ellipsoidInfo.cellArea = calculate_volumeOrArea(img3DOutterLayer);
            ellipsoidInfo.cellVolume = calculate_volumeOrArea(img3DLabelled);
            if isempty(initialEllipsoid.neighbourhood)
                disp('Getting info of vertices and neighbours: inner layer');
                
                img3DInnerLayer = zeros(size(img3DLabelled));
                innerLayerIndices = sub2ind(size(img3DLabelled), allXs(innerLayerPxs), allYs(innerLayerPxs), allZs(innerLayerPxs));
                img3DInnerLayer(innerLayerIndices) = img3DLabelledActual(innerLayerIndices);
                initialEllipsoid.img3DLayer = img3DInnerLayer;
                [initialEllipsoid.neighbourhood] = calculate_neighbours3D(img3DInnerLayer);
                initialEllipsoid.cellArea = calculate_volumeOrArea(img3DInnerLayer);
                [initialEllipsoid.verticesPerCell, initialEllipsoid.verticesConnectCells] = getVertices3D(img3DInnerLayer, initialEllipsoid.neighbourhood, initialEllipsoid);
            end
            %     figure;
            %     for i = 1:500
            %         i
            %         [x,y,z] = findND(img3DOutterLayer == i);
            %         colours = colorcube(500);
            %         plot3(x, y, z,'*', 'MarkerFaceColor', colours(i, :))
            %         hold on;
            %     end
            
            exchangeNeighboursPerCell = cellfun(@(x, y) size(setxor(x, y), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood);
            
            newRowTable = createExcel( ellipsoidInfo, initialEllipsoid, exchangeNeighboursPerCell);
            
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
            save(strcat(outputDir, '\ellipsoid_x', strrep(num2str(ellipsoidInfo.xRadius), '.', ''), '_y', strrep(num2str(ellipsoidInfo.yRadius), '.', ''), '_z', strrep(num2str(ellipsoidInfo.zRadius), '.', ''), '_cellHeight', strrep(num2str(cellHeight), '.', '')), 'ellipsoidInfo', 'initialEllipsoid', 'tableDataAngles');
            
            transitionsCSVInfo(end+1) = {horzcat(struct2table(newRowTable), struct2table(anglesPerRegion))};
        end
        %You can see the figures:
        %set(get(0,'children'),'visible','on')
end

