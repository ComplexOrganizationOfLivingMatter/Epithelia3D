addpath(genpath('src'));
addpath(genpath('lib'));

%On this order:
% - Zeppelin
% - Filled donut
% - Sphere
% - Stage 8
% - Stage 4
allCombinations = {
    15 10 10 [0.5, 1, 2] 'Zepellin'
    10 15 15 [0.5, 1, 2] 'FilledDonnut'
    10 10 10 [0.5, 1, 2] 'Sphere'
    97.46 50.75 50.75 6.25 'Stage 8'
    38.57277778	31.61605556 31.61605556	5.506047536 'Stage 4'
    };

for numRandomization = 1:20
    outputDir = strcat('results\random_', num2str(numRandomization));
    transitionByRadius = cell(size(allCombinations, 1), 1);
    for numCombination = 1:size(allCombinations, 1)
        radiusX = allCombinations{numCombination, 1};
        radiusY = allCombinations{numCombination, 2};
        radiusZ = allCombinations{numCombination, 3};
        hCell = allCombinations{numCombination, 4};
        fileName = allCombinations{numCombination, 5};
        
        outputDirActual = strcat(outputDir, '\', fileName);
        mkdir(outputDirActual);
        
        if min([radiusX, radiusY, radiusZ]) ~= 10
            radiusInModelY = 10;
            radiusZ = (radiusZ * radiusInModelY)/radiusY;
            radiusX = (radiusX * radiusInModelY)/radiusY;
            hCell = (hCell * radiusInModelY)/radiusY;
            radiusY = radiusInModelY;
        end
        
        a = voronoi3DEllipsoid([0 0 0], [radiusX radiusY radiusZ], 500, outputDirActual, hCell);
        if isempty(a)
            transitionByRadius(numCombination) = {[]};
        else
            transitionByRadius(numCombination) = {vertcat(a{:})};
        end
    end
    writetable(vertcat(transitionByRadius{:}), strcat(outputDir, '\transitionsInfo_', date, '.csv'), 'Delimiter', ';');
    transitionByRadiusAll{numRandomization} = vertcat(transitionByRadius{:});
    close all
end
writetable(vertcat(transitionByRadiusAll{:}), strcat('results\transitionsInfoAllRandomizations_', date, '.xls'))
%Calculate mean of all the transitions
calculateMeanOfXls(strcat('results\transitionsInfoAllRandomizations_', date, '.xls'));

