load('..\..\docs\LayersCentroids7.mat')

addpath(genpath('findND'));

pxWidth = 0.6165279;
pxDepth = 1.2098982;

seeds = [];

%seedsWrongCoordinates = vertcat(LayerCentroid{:});
seedsWrongCoordinates = LayerCentroid{1};

seeds(:, 1) = seedsWrongCoordinates(:, 2) * pxWidth;
seeds(:, 2) = seedsWrongCoordinates(:, 3) * pxWidth;
seeds(:, 3) = seedsWrongCoordinates(:, 1) * pxDepth;

seeds(:, 1) = seeds(:, 1) - min(seeds(:, 1)) + 1;
seeds(:, 2) = seeds(:, 2) - min(seeds(:, 2)) + 1;
seeds(:, 3) = seeds(:, 3) - min(seeds(:, 3)) + 1;

seeds = round(seeds);

img3D = zeros(max(seeds) + 1);

for numSeed = 1:size(seeds, 1)
    actualSeed = seeds(numSeed, :);
    img3D(actualSeed(1), actualSeed(2), actualSeed(3)) = 1;
end

regionOfCell = {};
imgDist = bwdist(img3D);

img3DActual = zeros(max(seeds) + 1);

img3DLabelled = zeros(max(seeds) + 1);
colours = colorcube(size(seeds, 1));
figure;
seedsInfo 
for numSeed = 1:size(seeds, 1)
    numSeed
    actualSeed = seeds(numSeed, :);
    img3DActual(actualSeed(1), actualSeed(2), actualSeed(3)) = 1;
    imgDistPerSeed = bwdist(img3DActual);
    regionActual = imgDistPerSeed == imgDist;
    img3DLabelled(regionActual) = numSeed;
    img3DActual(actualSeed(1), actualSeed(2), actualSeed(3)) = 0;
    
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

save(strcat('..\..\results\layerAnalysisVoronoi_', date, '.mat'), 'img3DLabelled', 'seedsInfo');
% figure;
% isosurface(imgDist, 10)
