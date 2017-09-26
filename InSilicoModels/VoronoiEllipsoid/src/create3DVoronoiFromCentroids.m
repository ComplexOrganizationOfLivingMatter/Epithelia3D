function [ img3D ] = create3DVoronoiFromCentroids( centroids,  augmentedCentroids, ellipsoidInfo)
%CREATE3DVORONOIFROMCENTROIDS Summary of this function goes here
%   Detailed explanation goes here

    resolutionFactor = 20;

    centroids(:, 1) = centroids(:, 1) + abs(min(augmentedCentroids(:, 1)));
    augmentedCentroids(:, 1) = augmentedCentroids(:, 1) + abs(min(augmentedCentroids(:, 1)));
    
    centroids(:, 2) = centroids(:, 2) + abs(min(augmentedCentroids(:, 2)));
    augmentedCentroids(:, 2) = augmentedCentroids(:, 2) + abs(min(augmentedCentroids(:, 2)));
    
    centroids(:, 3) = centroids(:, 3) + abs(min(augmentedCentroids(:, 3)));
    augmentedCentroids(:, 3) = augmentedCentroids(:, 3) + abs(min(augmentedCentroids(:, 3)));

    centroids = round(centroids * resolutionFactor) + 1;
    augmentedCentroids = round(augmentedCentroids * resolutionFactor) + 1;
    
    img3D = zeros(max(augmentedCentroids));

    for numCentroid = 1:size(centroids, 1)
        img3D = Drawline3D(img3D, centroids(numCentroid, 1), centroids(numCentroid, 2), centroids(numCentroid, 3), augmentedCentroids(numCentroid, 1), augmentedCentroids(numCentroid, 2), augmentedCentroids(numCentroid, 3), numCentroid);
    end
    
    imgWithDistances = bwdist(img3D);
    
    [allXs, allYs, allZs] = findND(img3D == 0);
    %Removing invalid areas
    upSide = (ellipsoidInfo.xRadius + cellHeight)^2 * (ellipsoidInfo.yRadius + cellHeight)^2 * (ellipsoidInfo.zRadius + cellHeight)^2;
    downSide = ((ellipsoidInfo.yRadius + cellHeight)^2 * (ellipsoidInfo.zRadius + cellHeight)^2 * allXs.^2) + ((ellipsoidInfo.xRadius + cellHeight)^2 * (ellipsoidInfo.zRadius + cellHeight)^2 * allYs.^2) + ((ellipsoidInfo.yRadius + cellHeight)^2 * (ellipsoidInfo.xRadius + cellHeight)^2 * allZs.^2);
    conversorFactorAugmented = sqrt(upSide./downSide);

    upSide = (ellipsoidInfo.xRadius)^2 * (ellipsoidInfo.yRadius)^2 * (ellipsoidInfo.zRadius)^2;
    downSide = ((ellipsoidInfo.yRadius)^2 * (ellipsoidInfo.zRadius)^2 * allXs.^2) + ((ellipsoidInfo.xRadius)^2 * (ellipsoidInfo.zRadius)^2 * allYs.^2) + ((ellipsoidInfo.yRadius)^2 * (ellipsoidInfo.xRadius)^2 * allZs.^2);
    conversorFactorNormal = sqrt(upSide./downSide);

    badPxs = conversorFactorNormal < 1 & conversorFactorAugmented > 1;
    
    %Reconstruct voronoiCells
    img3DLabelled = zeros(max(augmentedCentroids));
    img3DActual = zeros(max(augmentedCentroids));
    colours = colorcube(size(centroids, 1));
    figure;
    seedsInfo = [];
    for numSeed = 1:size(centroids, 1)
        numSeed
        img3DActual(img3D == numSeed) = 1;
        imgDistPerSeed = bwdist(img3DActual);
        regionActual = imgDistPerSeed == imgWithDistances;
        img3DLabelled(regionActual) = numSeed;
        img3DActual(img3D == numSeed) = 0;

        [x, y, z] = findND(img3DLabelled == numSeed);
        cellFigure = alphaShape(x, y, z, 2);
        plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
        hold on;

        seedsInfo(numSeed).ID = numSeed;
        seedsInfo(numSeed).region = regionActual;
        seedsInfo(numSeed).volume = cellFigure.volume;
        seedsInfo(numSeed).colour = colours(numSeed, :);
        seedsInfo(numSeed).pxCoordinates = [x, y, z];
        seedsInfo(numSeed).cellHeight = max(z) - min(z);
    end
end

