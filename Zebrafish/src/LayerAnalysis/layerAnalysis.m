load('..\..\data\trackingCentroids1.mat')

addpath(genpath('findND'));

layerVoronoi( finalCentroid, 'all')
close all

layers = vertcat(finalCentroid{:, 3});
for numLayer = 1:max(layers)
    if any((cellfun(@(x) x == numLayer, finalCentroid(:, 3))))
        seedsInfo = finalCentroid((cellfun(@(x) x == numLayer, finalCentroid(:, 3))), :);
        layerVoronoi( seedsInfo, num2str(numLayer));
    end
    close all
end

for numLayer = 2:max(layers)
    if any(cellfun(@(x) x == numLayer | x == (numLayer - 1), finalCentroid(:, 3)))
        seedsInfo = finalCentroid(cellfun(@(x) x == numLayer | x == (numLayer - 1), finalCentroid(:, 3)), :);
        layerVoronoi( seedsInfo, strcat(num2str(numLayer), '_', num2str(numLayer - 1)));
    end
    close all
end

