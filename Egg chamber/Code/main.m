
addpath(genpath('VoronoiEllipsoid'));
addpath(genpath('lib'));
close all
mkdir('..\resultsVoronoiEllipsoid');
parfor radiusY = 0:30
    for radiusZ = 0:30
        voronoiOnEllipsoidSurface( [0 0 0], [10 10+radiusY 10+radiusZ], 500, 1 + (radiusY + radiusZ - radiusX)/10);
    end
end