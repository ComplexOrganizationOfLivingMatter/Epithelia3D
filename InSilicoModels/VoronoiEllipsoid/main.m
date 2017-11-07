addpath(genpath('src'));
addpath(genpath('lib'));

%On this order:
% - Zeppelin
% - Filled donut
% - Sphere
% - Stage 8
% - Stage 4
allCombinations = {
    15 10 10 [1] 'Zepellin' %%[30] pero lo he puesto en 10 para que salga mas rapido y que a la vez haya transiciones
    10 15 15 [50] 'FilledDonnut'
    10 10 10 [30] 'Sphere'
    97.46-6.25 50.75-6.25 50.75-6.25 6.25 'Stage 8'
    38.57277778-5.506047536	31.61605556-5.506047536 31.61605556-5.506047536	5.506047536 'Stage 4'
 };

for numCombination = 1:size(allCombinations, 1)
    
    
    fileName = allCombinations{numCombination, 5};
    outputDirGlobal= ['results\' fileName];
%     rowTransitionOuter=cell(4,2);
%     rowNoTransitionOuter=cell(4,2);
%     rowTransitionInner=cell(4,2);
%     rowNoTransitionInner=cell(4,2); INSERT HERE THE NUMBER OF BORDERS
    
    for numRandomization = 1:20 %%parfor
        
        radiusX = allCombinations{numCombination, 1};
        radiusY = allCombinations{numCombination, 2};
        radiusZ = allCombinations{numCombination, 3};
        hCell = allCombinations{numCombination, 4};
        
        outputDirActual = [outputDirGlobal '\random_', num2str(numRandomization)];
        mkdir(outputDirActual);
        
        if min([radiusX, radiusY, radiusZ]) ~= 1
            radiusInModelY = 1;
            radiusZ = (radiusZ * radiusInModelY)/radiusY;
            radiusX = (radiusX * radiusInModelY)/radiusY;
            hCell = (hCell * radiusInModelY)/radiusY;
            radiusY = radiusInModelY;
        end
        
        a = voronoi3DEllipsoid([radiusX+hCell+0.5 radiusY+hCell+0.5 radiusZ+hCell+0.5], [radiusX radiusY radiusZ], 200, outputDirActual, hCell);
        
        for numBorders=1:length(a.edgeTransitionMeasuredOuter)
                rowTransitionOuter{numRandomization,numBorders}=a.edgeTransitionMeasuredOuter{numBorders};
                rowNoTransitionOuter{numRandomization,numBorders}=a.edgeNoTransitionMeasuredOuter{numBorders};
                rowTransitionInner{numRandomization,numBorders}=a.edgeTransitionMeasuredInner{numBorders};
                rowNoTransitionInner{numRandomization,numBorders}=a.edgeNoTransitionMeasuredInner{numBorders};
        end
        ['randomization ' num2str(numRandomization) ' - finished']
    end
    
    for numBorders=1:size(rowTransitionOuter,2)
        borderLimit=rowTransitionOuter{numBorders}.bordersSituatedAt(1);
        writetable(vertcat(rowTransitionOuter{:,numBorders}), [outputDirGlobal '\transitionsOuterBorder' num2str(borderLimit) '_' fileName '_' date '.xls']);
        writetable(vertcat(rowNoTransitionOuter{:,numBorders}), [outputDirGlobal '\noTransitionsOuterBorder' num2str(borderLimit) '_' fileName '_' date '.xls']);
        writetable(vertcat(rowTransitionInner{:,numBorders}), [outputDirGlobal  '\transitionsInnerBorder' num2str(borderLimit) '_' fileName '_' date '.xls']);
        writetable(vertcat(rowNoTransitionInner{:,numBorders}), [outputDirGlobal '\noTransitionsInnerBorder' num2str(borderLimit) '_' fileName '_' date '.xls']);
    end
    close all
end
%writetable(vertcat(transitionByRadiusAll{:}), strcat('results\transitionsInfoAllRandomizations_', date, '.xls'))
%Calculate mean of all the transitions
%calculateMeanOfXls(strcat('results\transitionsInfoAllRandomizations_', date, '.xls'));

