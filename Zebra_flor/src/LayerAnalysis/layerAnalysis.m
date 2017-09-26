load('..\..\data\LayersCentroids7.mat')

addpath(genpath('findND'));



for numLayer = 2:size(LayerCentroid, 1)
    seedsWrongCoordinates = LayerCentroid{numLayer};
    if isempty(seedsWrongCoordinates) == 0
        layerVoronoi( seedsWrongCoordinates, numLayer )
    end
end
