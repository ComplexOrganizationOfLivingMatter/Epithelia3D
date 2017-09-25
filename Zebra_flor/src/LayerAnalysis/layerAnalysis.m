load('..\..\docs\LayersCentroids7.mat')

addpath(genpath('findND'));

seedsWrongCoordinates = vertcat(LayerCentroid{:});
%seedsWrongCoordinates = LayerCentroid{1};

layerVoronoi( seedsWrongCoordinates )
