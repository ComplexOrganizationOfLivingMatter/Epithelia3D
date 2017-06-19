
addpath(genpath('VoronoiEllipsoid'));
addpath(genpath('lib'));
close all
mkdir('..\resultsVoronoiEllipsoid');
maxRadiusY = 20;
maxRadiusZ = 20;
transitionByRadius = cell(maxRadiusY, maxRadiusZ);
parfor radiusY = 0:maxRadiusY
    for radiusZ = 0:maxRadiusZ
        a = voronoiOnEllipsoidSurface( [0 0 0], [10 10+radiusY 10+radiusZ], 500, 1);
        if isempty(a)
            transitionByRadius(radiusY, radiusZ) = a;
        else
            transitionByRadius(radiusY, radiusZ) = vertcat(a{:});
        end
    end
end
transitionByRadius
