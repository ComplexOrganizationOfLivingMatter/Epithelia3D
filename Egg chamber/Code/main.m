addpath(genpath('VoronoiEllipsoid'));
addpath(genpath('lib'));

%On this order:
% - Zeppelin
% - Filled donut
% - Sphere
% - Stage 8
% - Stage 4
allCombinations = {
    15 10 10 [3, 3.5, 4, 0.5, 1, 2]
    10 15 15 [0.5, 1, 2]
    10 10 10 [0.5, 1, 2]
    97.46 50.75 50.75 6.25
    38.57277778	31.61605556 31.61605556	5.506047536
    };

for numRandomization = 1:20
    outputDir = strcat('..\results\random_', num2str(numRandomization));
    mkdir(outputDir);
    transitionByRadius = cell(size(allCombinations, 1), 1);
    for numCombination = 1:size(allCombinations, 1)
        radiusX = allCombinations{numCombination, 1};
        radiusY = allCombinations{numCombination, 2};
        radiusZ = allCombinations{numCombination, 3};
        hCell = allCombinations{numCombination, 4};
        
        if min([radiusX, radiusY, radiusZ]) ~= 10
            radiusInModelY = 10;
            radiusZ = (radiusZ * radiusInModelY)/radiusY;
            radiusX = (radiusX * radiusInModelY)/radiusY;
            hCell = (hCell * radiusInModelY)/radiusY;
            radiusY = radiusInModelY;
        end
        
        a = voronoiOnEllipsoidSurface([0 0 0], [radiusX radiusY radiusZ], 500, outputDir, hCell);
        if isempty(a)
            transitionByRadius(numCombination) = {[]};
        else
            transitionByRadius(numCombination) = {vertcat(a{:})};
        end
    end
    writetable(vertcat(transitionByRadius{:}), strcat(outputDir, '\transitionsInfo_', date, '.csv'), 'Delimiter', ';');
    transitionByRadiusAll{numRandomization} = vertcat(transitionByRadius{:});
end
writetable(vertcat(transitionByRadiusAll{:}), strcat('..\results\transitionsInfoAllRandomizations_', date, '.xls'))
%Calculate mean of all the transitions
calculateMeanOfXls(strcat('..\results\transitionsInfoAllRandomizations_', date, '.xls'));

