
addpath(genpath('VoronoiEllipsoid'));
addpath(genpath('lib'));
close all
mkdir('..\resultsVoronoiEllipsoid');
for radius = 5:9
    voronoiOnEllipsoidSurface( [0 0 0], [10 radius radius], 400, 1 );
end