function [ img3DLabelled ] = create3DVoronoiFromCentroids( centroids,  augmentedCentroids, cellHeight, ellipsoidInfo, outputDir)
%CREATE3DVORONOIFROMCENTROIDS Summary of this function goes here
%   Detailed explanation goes here
    
    resolutionFactor = 20;

    xOffset = abs(min(augmentedCentroids(:, 1)));
    centroids(:, 1) = centroids(:, 1) + xOffset;
    augmentedCentroids(:, 1) = augmentedCentroids(:, 1) + xOffset;
    
    yOffset = abs(min(augmentedCentroids(:, 2)));
    centroids(:, 2) = centroids(:, 2) + yOffset;
    augmentedCentroids(:, 2) = augmentedCentroids(:, 2) + yOffset;
    
    zOffset = abs(min(augmentedCentroids(:, 3)));
    centroids(:, 3) = centroids(:, 3) + zOffset;
    augmentedCentroids(:, 3) = augmentedCentroids(:, 3) + zOffset;

    centroids = round(centroids * resolutionFactor) + 1;
    augmentedCentroids = round(augmentedCentroids * resolutionFactor) + 1;
    
    img3D = zeros(max(augmentedCentroids));

    for numCentroid = 1:size(centroids, 1)
        img3D = Drawline3D(img3D, centroids(numCentroid, 1), centroids(numCentroid, 2), centroids(numCentroid, 3), augmentedCentroids(numCentroid, 1), augmentedCentroids(numCentroid, 2), augmentedCentroids(numCentroid, 3), numCentroid);
    end
    
    imgWithDistances = bwdist(img3D);
    
    [allXs, allYs, allZs] = findND(img3D == 0);
    
    %Removing invalid areas
    disp('Removing invalid areas')
    outsideFactorAugmented = ((((allXs / resolutionFactor) - xOffset).^2) / (ellipsoidInfo.xRadius + cellHeight)^2) + ((((allYs / resolutionFactor) - yOffset).^2) / (ellipsoidInfo.yRadius + cellHeight)^2) + ((((allZs / resolutionFactor) - zOffset).^2) / (ellipsoidInfo.zRadius + cellHeight)^2);
    
    outsideFactorNormal = ((((allXs / resolutionFactor) - xOffset).^2) / ellipsoidInfo.xRadius^2) + ((((allYs / resolutionFactor) - yOffset).^2) / ellipsoidInfo.yRadius^2) + ((((allZs / resolutionFactor) - zOffset).^2) / ellipsoidInfo.zRadius^2);

    goodPxs = outsideFactorNormal > 0.99 & outsideFactorAugmented < 1.01;
    
    badXs = allXs(goodPxs == 0);
    badYs = allYs(goodPxs == 0);
    badZs = allZs(goodPxs == 0);
    for numPoint = 1:size(badXs)
        imgWithDistances(badXs(numPoint), badYs(numPoint), badZs(numPoint)) = 0;
    end
    
    %Reconstruct voronoiCells
    disp('Reconstruct voronoi cells')
    img3DLabelled = zeros(max(augmentedCentroids));
    img3DActual = zeros(max(augmentedCentroids));
    colours = colorcube(size(centroids, 1));
%     figure;
    seedsInfo = [];
    for numSeed = 1:size(centroids, 1)
        numSeed
        img3DActual(img3D == numSeed) = 1;
        imgDistPerSeed = bwdist(img3DActual);
        regionActual = imgDistPerSeed == imgWithDistances;
        img3DLabelled(regionActual) = numSeed;
        img3DActual(img3D == numSeed) = 0;

        perimRegionActual = bwperim(regionActual);
        [x, y, z] = findND(perimRegionActual);
        cellFigure = alphaShape(x, y, z);
        plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
        hold on;

%         seedsInfo(numSeed).ID = numSeed;
%         seedsInfo(numSeed).region = regionActual;
%         %seedsInfo(numSeed).volume = cellFigure.volume;
%         seedsInfo(numSeed).colour = colours(numSeed, :);
%         seedsInfo(numSeed).pxCoordinates = [x, y, z];
%         seedsInfo(numSeed).cellHeight = max(z) - min(z);
    end
    
    save(strcat(outputDir, '\voronoi', date, '.mat'), 'img3DLabelled', 'seedsInfo', '-v7.3');
    savefig(strcat(outputDir, '\voronoi_', date, '.fig'));
end

