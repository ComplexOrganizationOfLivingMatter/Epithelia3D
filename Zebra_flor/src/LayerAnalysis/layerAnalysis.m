load('..\..\docs\LayersCentroids7.mat')

addpath(genpath('findND'));

seeds = round(vertcat(LayerCentroid{:}));

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
for numSeed = 1:size(seeds, 1)
    numSeed
    actualSeed = seeds(numSeed, :);
    img3DActual(actualSeed(1), actualSeed(2), actualSeed(3)) = 1;
    imgDistPerSeed = bwdist(img3DActual);
    regionActual = imgDistPerSeed == imgDist;
    regionOfCell(numSeed) = {(regionActual) * numSeed};
    img3DLabelled(regionActual) = numSeed;
    img3DActual(actualSeed(1), actualSeed(2), actualSeed(3)) = 0;
    
    [x, y, z] = findND(img3DLabelled == numSeed);
    cellFigure = alphaShape(x, y , z);
    plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
    hold on;
end

save(strcat('..\..\results\layerAnalysisVoronoi_', date, '.mat'), 'img3DLabelled', 'regionOfCell');
% figure;
% isosurface(imgDist, 10)
