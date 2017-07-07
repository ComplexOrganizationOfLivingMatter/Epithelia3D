
addpath(genpath('VoronoiEllipsoid'));
addpath(genpath('lib'));

for numRandomization = 5:11
    outputDir = strcat('..\resultsVoronoiEllipsoid\random_', num2str(numRandomization));
    mkdir(outputDir);
    maxRadiusY = 10;
    maxRadiusZ = 10;
    transitionByRadius = cell(maxRadiusY+1, maxRadiusZ+1);
    for radiusZ = 1:maxRadiusY+1
        close all
        parfor radiusY = radiusZ+1:maxRadiusZ+1
            a = voronoiOnEllipsoidSurface( [0 0 0], [10+radiusZ-1 10+radiusY-1 10+radiusZ-1], 500, outputDir);
            if isempty(a)
                transitionByRadius(radiusY, radiusZ) = {[]};
            else
                transitionByRadius(radiusY, radiusZ) = {vertcat(a{:})};
            end
        end
        transitionByRadius;
    end
    writetable(vertcat(transitionByRadius{:}), strcat(outputDir, '\transitionsInfo_', date, '.csv'), 'Delimiter', ';');
end
