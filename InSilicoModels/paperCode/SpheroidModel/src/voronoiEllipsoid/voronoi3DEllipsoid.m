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

    ellipsoidInfo.minDistanceBetweenCentroids = (ellipsoidInfo.areaOfEllipsoid / (maxNumberOfCellsInVoronoi^(1/1.28)));
    minDistanceBetweenCentroids = ellipsoidInfo.minDistanceBetweenCentroids;
    %(resolutionEllipse + 1) * (resolutionEllipse + 1) number of points
    %generated at the surface of the ellipsoid
    ellipsoidInfo.resolutionEllipse = 300; %300 seems to be a good number
    [x, y, z] = ellipsoid(ellipsoidInfo.xCenter, ellipsoidInfo.yCenter, ellipsoidInfo.zCenter, ellipsoidInfo.xRadius, ellipsoidInfo.yRadius, ellipsoidInfo.zRadius, ellipsoidInfo.resolutionEllipse);

%     figure
%     surf(x, y, z)
%     xlabel('x')
%     ylabel('y')
%     zlabel('z')
%     axis equal
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
        transitionsCSVInfo = struct();
        ellipsoidInfo.centroids = finalCentroids;
        initialEllipsoid = ellipsoidInfo;
        [ ellipsoidInfo.centroids ] = getAugmentedCentroids( ellipsoidInfo, finalCentroids, max(hCellsPredefined));
        
        %Paint the ellipsoid voronoi
        disp('Creating Random voronoi')
        [ img3DLabelled, ellipsoidInfo, newOrderOfCentroids ] = create3DVoronoiFromCentroids(initialEllipsoid.centroids, ellipsoidInfo.centroids, max(hCellsPredefined), ellipsoidInfo, outputDir);
        initialEllipsoid.centroids = initialEllipsoid.centroids(newOrderOfCentroids, :);
        close
        disp('Random voronoi created')
        
        initialEllipsoid.surfaceIndices = [];
        
        % Get all the pixels of the image
        [allXs, allYs, allZs] = findND(img3DLabelled > 0);
        allXs = uint16(allXs);
        allYs = uint16(allYs);
        allZs = uint16(allZs);
        numException = 0;
        
        
        %Predefining parameters to save
        transitionsCSVInfoTransitionsMeasuredOuter=cell(length(hCellsPredefined),length(ellipsoidInfo.bordersSituatedAt));
        transitionsCSVInfoTransitionsMeasuredInner=cell(length(hCellsPredefined),length(ellipsoidInfo.bordersSituatedAt));
        transitionsCSVInfoNoTransitionsMeasuredOuter=cell(length(hCellsPredefined),length(ellipsoidInfo.bordersSituatedAt));
        transitionsCSVInfoNoTransitionsMeasuredInner=cell(length(hCellsPredefined),length(ellipsoidInfo.bordersSituatedAt));
        countOfHeights=1;
        
        for cellHeight = hCellsPredefined
            cellHeight
            ellipsoidInfo.xRadius = initialEllipsoid.xRadius;
            ellipsoidInfo.yRadius = initialEllipsoid.yRadius;
            ellipsoidInfo.zRadius = initialEllipsoid.zRadius;
            ellipsoidInfo.cellHeight = cellHeight;
            
            [ validPxs, innerLayerPxs, outerLayerPxs ] = getValidPixels(allXs, allYs, allZs, ellipsoidInfo, cellHeight);
            img3DLabelledActual = img3DLabelled;
            novalidIndices = uint64(sub2ind(size(img3DLabelled), allXs(validPxs == 0), allYs(validPxs == 0), allZs(validPxs == 0)));
            img3DLabelledActual(novalidIndices) = 0;
            img3DOutterLayer = zeros(size(img3DLabelled), 'uint16');
            outterLayerIndices = uint64(sub2ind(size(img3DLabelled), allXs(outerLayerPxs), allYs(outerLayerPxs), allZs(outerLayerPxs)));
            img3DOutterLayer(outterLayerIndices) = img3DLabelledActual(outterLayerIndices);
            
            disp('Getting info of vertices and neighbours: outter layer');
            ellipsoidInfo.img3DLayer = img3DOutterLayer;
            ellipsoidInfo.surfaceIndices = outterLayerIndices;
            [ellipsoidInfo] = calculate_neighbours3D(img3DOutterLayer, ellipsoidInfo);
            ellipsoidInfo.cellArea = calculate_volumeOrArea(img3DOutterLayer);
            ellipsoidInfo.cellVolume = calculate_volumeOrArea(img3DLabelled);
            if isempty(initialEllipsoid.surfaceIndices)
                disp('Getting info of vertices and neighbours: inner layer');
                
                img3DInnerLayer = zeros(size(img3DLabelled), 'uint16');
                innerLayerIndices = uint64(sub2ind(size(img3DLabelled), allXs(innerLayerPxs), allYs(innerLayerPxs), allZs(innerLayerPxs)));
                img3DInnerLayer(innerLayerIndices) = img3DLabelledActual(innerLayerIndices);
                initialEllipsoid.surfaceIndices = innerLayerIndices;
                initialEllipsoid.img3DLayer = img3DInnerLayer;
                [initialEllipsoid] = calculate_neighbours3D(img3DInnerLayer, initialEllipsoid);
                initialEllipsoid.cellArea = calculate_volumeOrArea(img3DInnerLayer);
            end
%                 figure;
%                 for i = [0, 5, 15, 4, 11]
%                     i
%                     [x,y,z] = findND(ellipsoidInfo.img3DLayer(outterLayerIndices) == i);
%                     colours = colorcube(200);
%                     plot3(x, y, z,'*', 'MarkerFaceColor', colours(i, :))
%                     hold on;
%                 end
            
            exchangeNeighboursPerCell = cellfun(@(x, y) size(setxor(y, x), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood);
            %[ellipsoidInfo] = calculate_neighbours3D(img3DOutterLayer, ellipsoidInfo); [initialEllipsoid] = calculate_neighbours3D(img3DInnerLayer, initialEllipsoid);
                
            winnigNeighboursPerCell = cellfun(@(x, y) size(setdiff(y, x), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood);
            losingNeighboursPerCell = cellfun(@(x, y) size(setdiff(x, y), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood);
            
            if sum(winnigNeighboursPerCell - losingNeighboursPerCell) == 0
                %error ('incorrectNeighbours', 'There should be the same number of winning and losing neighbours')
            end
            
            
            ellipsoidInfo.xRadius = initialEllipsoid.xRadius + cellHeight;
            ellipsoidInfo.yRadius = initialEllipsoid.yRadius + cellHeight;
            ellipsoidInfo.zRadius = initialEllipsoid.zRadius + cellHeight;
            
            newRowTableMeasuredOuter = createExcel( ellipsoidInfo, initialEllipsoid, exchangeNeighboursPerCell);
            newRowTableMeasuredInner = createExcel( initialEllipsoid, ellipsoidInfo, exchangeNeighboursPerCell);
            
            cellsTransition = find(cellfun(@(x, y) size(setxor(x, y), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood)>0, 1);
            
            tableDataAnglesTransitionsEdgesOuter=[];
            tableDataAnglesNoTransitionsEdgesOuter=[];
            tableDataAnglesTransitionsEdgesInner=[];
            tableDataAnglesNoTransitionsEdgesInner=[];
            
%             if ~isempty(cellsTransition)
                [tableDataAnglesTransitionsEdgesOuter, tableDataAnglesNoTransitionsEdgesOuter] = getAnglesLengthAndTranstionFromTheEdges( initialEllipsoid, ellipsoidInfo);
                close
                [tableDataAnglesTransitionsEdgesInner, tableDataAnglesNoTransitionsEdgesInner] = getAnglesLengthAndTranstionFromTheEdges( ellipsoidInfo, initialEllipsoid);
                close
%             end
            
           
            %Saving info
            save(strcat(outputDir, '\ellipsoid_x', strrep(num2str(ellipsoidInfo.xRadius), '.', ''), '_y', strrep(num2str(ellipsoidInfo.yRadius), '.', ''), '_z', strrep(num2str(ellipsoidInfo.zRadius), '.', ''), '_cellHeight', strrep(num2str(cellHeight), '.', '')), 'ellipsoidInfo', 'initialEllipsoid', 'tableDataAnglesTransitionsEdgesOuter','tableDataAnglesNoTransitionsEdgesOuter','tableDataAnglesTransitionsEdgesInner','tableDataAnglesNoTransitionsEdgesInner', '-v7.3');
            
            
            fieldsNoSavedInCSV={'edgeLength','edgeAngle','edgeVertices','cellularMotifs'};
            for numBorders=1:length(newRowTableMeasuredOuter)               
                
                
                
                transitionsCSVInfoTransitionsMeasuredOuter(countOfHeights,numBorders) = {horzcat(struct2table(newRowTableMeasuredOuter{numBorders}), struct2table(rmfield(tableDataAnglesTransitionsEdgesOuter.TotalRegion,fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesTransitionsEdgesOuter.LeftRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesTransitionsEdgesOuter.RightRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesTransitionsEdgesOuter.CentralRegion(numBorders),fieldsNoSavedInCSV)))};
                transitionsCSVInfoTransitionsMeasuredInner(countOfHeights,numBorders) = {horzcat(struct2table(newRowTableMeasuredInner{numBorders}), struct2table(rmfield(tableDataAnglesTransitionsEdgesInner.TotalRegion,fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesTransitionsEdgesInner.LeftRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesTransitionsEdgesInner.RightRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesTransitionsEdgesInner.CentralRegion(numBorders),fieldsNoSavedInCSV)))};
                transitionsCSVInfoNoTransitionsMeasuredOuter(countOfHeights,numBorders) = {horzcat(struct2table(newRowTableMeasuredOuter{numBorders}), struct2table(rmfield(tableDataAnglesNoTransitionsEdgesOuter.TotalRegion,fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesNoTransitionsEdgesOuter.LeftRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesNoTransitionsEdgesOuter.RightRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesNoTransitionsEdgesOuter.CentralRegion(numBorders),fieldsNoSavedInCSV)))};
                transitionsCSVInfoNoTransitionsMeasuredInner(countOfHeights,numBorders) = {horzcat(struct2table(newRowTableMeasuredInner{numBorders}), struct2table(rmfield(tableDataAnglesNoTransitionsEdgesInner.TotalRegion,fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesNoTransitionsEdgesInner.LeftRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesNoTransitionsEdgesInner.RightRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesNoTransitionsEdgesInner.CentralRegion(numBorders),fieldsNoSavedInCSV)))};
                
            end
            countOfHeights=countOfHeights+1;
           
        end
        transitionsCSVInfo.edgeTransitionMeasuredOuter=transitionsCSVInfoTransitionsMeasuredOuter;
        transitionsCSVInfo.edgeTransitionMeasuredInner=transitionsCSVInfoTransitionsMeasuredInner;
        transitionsCSVInfo.edgeNoTransitionMeasuredOuter=transitionsCSVInfoNoTransitionsMeasuredOuter;
        transitionsCSVInfo.edgeNoTransitionMeasuredInner=transitionsCSVInfoNoTransitionsMeasuredInner;
        
        %You can see the figures:
        %set(get(0,'children'),'visible','on')
end