load('..\..\data\LayersCentroids7.mat')

addpath(genpath('findND'));



for numLayer = 2:size(LayerCentroid, 1)
    seedsWrongCoordinates = vertcat(LayerCentroid{numLayer-1 : numLayer});
    if isempty(seedsWrongCoordinates) == 0
        layerVoronoi( seedsWrongCoordinates, strcat(num2str(numLayer), '_', num2str(numLayer - 1)))
    end
end
