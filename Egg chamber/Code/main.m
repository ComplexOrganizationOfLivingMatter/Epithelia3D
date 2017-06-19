
addpath(genpath('VoronoiEllipsoid'));
addpath(genpath('lib'));
close all
mkdir('..\resultsVoronoiEllipsoid');
transitionByRadius = cell(radiusY, radiusZ);
for radiusY = 0:30
    transitionRadiusZ = cell(radiusZ, 1);
    parfor radiusZ = 0:30
        a = voronoiOnEllipsoidSurface( [0 0 0], [10 10+radiusY 10+radiusZ], 500, 2 + ((radiusY + radiusZ - 10)/10));
        transitionByRadius(radiusY, radiusZ) = a;
    end
    transitionByRadius(radiusY, 1:30) = transitionByRadius;
end