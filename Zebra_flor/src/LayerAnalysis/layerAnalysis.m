load('..\..\docs\LayersCentroids7.mat')

seeds = round(vertcat(LayerCentroid{:}));

img3D = zeros(max(seeds) + 1);

for numSeed = 1:size(seeds, 1)
    actualSeed = seeds(numSeed, :);
    img3D(actualSeed(1), actualSeed(2), actualSeed(3)) = 1;
end

imgDist = bwdist(img3D);
% figure;
% isosurface(imgDist, 10)

seed1 = seeds(1, :);
imgDist(seed1(1), seed1(2), seed1(3))

imgWatersheded = watershed3D(imgDist, seeds);

imgLabelled = bwlabeln(imgWatersheded);
