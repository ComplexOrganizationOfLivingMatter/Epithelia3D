
addpath(genpath('VoronoiEllipsoid'));
addpath(genpath('lib'));
close all
mkdir('..\resultsVoronoiEllipsoid');
maxRadiusY = 5;
maxRadiusZ = 20;
transitionByRadius = cell(maxRadiusY+1, maxRadiusZ+1);
for radiusY = 1:maxRadiusY+1
    for radiusZ = 1:maxRadiusZ+1
        a = voronoiOnEllipsoidSurface( [0 0 0], [10 10+radiusY-1 10+radiusZ-1], 500, 1);
        if isempty(a)
            transitionByRadius(radiusY, radiusZ) = {[]};
        else
            transitionByRadius(radiusY, radiusZ) = {vertcat(a{:})};
        end
    end
end
writetable(vertcat(transitionByRadius{:}), strcat('..\resultsVoronoiEllipsoid\transitionsInfo_', date, '.csv'), 'Delimiter', ';')
