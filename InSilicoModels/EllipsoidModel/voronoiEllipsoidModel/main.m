addpath(genpath('src'));
addpath(genpath('lib'));

% X should be the greater number. Z should be the axis with the greater
% curvature.
allCombinations = {
	1.5 1 1 [0.5, 1, 2] 'Ball' 200
    2 1 1 [0.5, 1, 2] 'Rugby' 200
    1 1 1 [0.5, 1, 2] 'Sphere' 200
%    36-5.369186755	29.59784615-5.369186755 29.59784615-5.369186755	5.369186755 'Stage 4' 200
%    97.46-6.145760671 48.32738462-6.145760671 48.32738462-6.145760671 6.145760671 'Stage 8' 450
    };

maxRandoms = 1:3;
delete(gcp);
parpool(3);

for numCombination = 1:size(allCombinations, 1)
    
    
    fileName = allCombinations{numCombination, 5};
    outputDirGlobal= ['results\' fileName];
    
    
    randomizationsInfo = cell(max(maxRandoms), 1);
    
    parfor numRandomization = maxRandoms %%parfor
        
        radiusX = allCombinations{numCombination, 1};
        radiusY = allCombinations{numCombination, 2};
        radiusZ = allCombinations{numCombination, 3};
        hCell = allCombinations{numCombination, 4};
        numCells = allCombinations{numCombination, 6};
        
        outputDirActual = [outputDirGlobal '\random_', num2str(numRandomization)];
        mkdir(outputDirActual);
        
        if min([radiusX, radiusY, radiusZ]) ~= 1
            radiusInModelY = 1;
            radiusZ = (radiusZ * radiusInModelY)/radiusY;
            radiusX = (radiusX * radiusInModelY)/radiusY;
            hCell = (hCell * radiusInModelY)/radiusY;
            radiusY = radiusInModelY;
        end
        
        %randomEllipsoidInfo = voronoi3DEllipsoid([radiusX+max(hCell)+0.5 radiusY+max(hCell)+0.5 radiusZ+max(hCell)+0.5], [radiusX radiusY radiusZ], numCells, outputDirActual, hCell);
        randomEllipsoidInfo = voronoi3DEllipsoid([radiusX+max(hCell)+0.001 radiusY+max(hCell)+0.001 radiusZ+max(hCell)+0.001], [radiusX radiusY radiusZ], numCells, outputDirActual, hCell);
        
        randomizationsInfo(numRandomization) = {randomEllipsoidInfo};
        
        ['randomization ' num2str(numRandomization) ' - finished']
    end
    
    
    rowTransitionOuter=cell(max(maxRandoms)*length(allCombinations{numCombination, 4}),2);
    rowNoTransitionOuter=cell(max(maxRandoms)*length(allCombinations{numCombination, 4}),2);
    rowTransitionInner=cell(max(maxRandoms)*length(allCombinations{numCombination, 4}),2);
    rowNoTransitionInner=cell(max(maxRandoms)*length(allCombinations{numCombination, 4}),2);
    
    for numEllipsoid = maxRandoms
        randomEllipsoidInfo = randomizationsInfo{numEllipsoid};
        for numHeight = 1:length(allCombinations{numCombination, 4})
            for numBorders=1:length(randomEllipsoidInfo.edgeTransitionMeasuredOuter)
                numRow = (length(allCombinations{numCombination, 4}) * (numEllipsoid - 1)) + numHeight;
                rowTransitionOuter{numRow,numBorders}=randomEllipsoidInfo.edgeTransitionMeasuredOuter{numHeight, numBorders};
                rowNoTransitionOuter{numRow,numBorders}=randomEllipsoidInfo.edgeNoTransitionMeasuredOuter{numHeight, numBorders};
                rowTransitionInner{numRow,numBorders}=randomEllipsoidInfo.edgeTransitionMeasuredInner{numHeight, numBorders};
                rowNoTransitionInner{numRow,numBorders}=randomEllipsoidInfo.edgeNoTransitionMeasuredInner{numHeight, numBorders};
            end
        end
    end
    
    for numBorders=1:size(rowTransitionOuter,2)
        borderLimit=rowTransitionOuter{maxRandoms(1),numBorders}.bordersSituatedAt(1);
        writetable(vertcat(rowTransitionOuter{:,numBorders}), [outputDirGlobal '\transitionsOuterBorder' num2str(borderLimit) '_' fileName '_' date '.xls']);
        writetable(vertcat(rowNoTransitionOuter{:,numBorders}), [outputDirGlobal '\noTransitionsOuterBorder' num2str(borderLimit) '_' fileName '_' date '.xls']);
        writetable(vertcat(rowTransitionInner{:,numBorders}), [outputDirGlobal  '\transitionsInnerBorder' num2str(borderLimit) '_' fileName '_' date '.xls']);
        writetable(vertcat(rowNoTransitionInner{:,numBorders}), [outputDirGlobal '\noTransitionsInnerBorder' num2str(borderLimit) '_' fileName '_' date '.xls']);
    end
    save(strcat(outputDirGlobal, '\randomizationsInfo_', date), 'randomizationsInfo');
    close all
end
%writetable(vertcat(transitionByRadiusAll{:}), strcat('results\transitionsInfoAllRandomizations_', date, '.xls'))
%Calculate mean of all the transitions
%calculateMeanOfXls(strcat('results\transitionsInfoAllRandomizations_', date, '.xls'));

