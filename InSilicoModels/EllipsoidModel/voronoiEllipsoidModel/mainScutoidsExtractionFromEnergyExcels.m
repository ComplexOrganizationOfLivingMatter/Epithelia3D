
addpath('src')

stage8TransitionPath= 'results\Stage 8\energy\spheroidVoronoiModelEnergy_Stage 8_Transition_NonPreservedMotifs_03-Apr-2018.xls';
stage4TransitionPath= 'results\Stage 4\energy\spheroidVoronoiModelEnergy_Stage 4_Transition_NonPreservedMotifs_12-Apr-2018.xls';
globeTransition05Path= 'results\Globe\energy\energyTransitionEdgesNonPreservedMotifs_cellHeight05_20-Mar-2018.xls';
globeTransition1Path= 'results\Globe\energy\energyTransitionEdgesNonPreservedMotifs_cellHeight1_20-Mar-2018.xls';
globeTransition2Path= 'results\Globe\energy\energyTransitionEdgesNonPreservedMotifs_cellHeight2_20-Mar-2018.xls';
rugbyTransition05Path= 'results\Rugby\energy\energyTransitionEdgesNonPreservedMotifs_cellHeight05_20-Mar-2018.xls';
rugbyTransition1Path= 'results\Rugby\energy\energyTransitionEdgesNonPreservedMotifs_cellHeight1_20-Mar-2018.xls';
rugbyTransition2Path= 'results\Rugby\energy\energyTransitionEdgesNonPreservedMotifs_cellHeight2_20-Mar-2018.xls';
% sphereTransitionPath= ;

stage8NoTransitionPath= 'results\Stage 8\energy\spheroidVoronoiModelEnergy_Stage 8_NoTransition_NonPreservedMotifs_03-Apr-2018.xls';
stage4NoTransitionPath= 'results\Stage 4\energy\spheroidVoronoiModelEnergy_Stage 4_NoTransition_NonPreservedMotifs_12-Apr-2018.xls';
globeNoTransition05Path= 'results\Globe\energy\energyNoTransitionEdgesNonPreservedMotifs_cellHeight05_20-Mar-2018.xls';
globeNoTransition1Path= 'results\Globe\energy\energyNoTransitionEdgesNonPreservedMotifs_cellHeight1_20-Mar-2018.xls';
globeNoTransition2Path= 'results\Globe\energy\energyNoTransitionEdgesNonPreservedMotifs_cellHeight2_20-Mar-2018.xls';
rugbyNoTransition05Path= 'results\Rugby\energy\energyNoTransitionEdgesNonPreservedMotifs_cellHeight05_20-Mar-2018.xls';
rugbyNoTransition1Path= 'results\Rugby\energy\energyNoTransitionEdgesNonPreservedMotifs_cellHeight1_20-Mar-2018.xls';
rugbyNoTransition2Path= 'results\Rugby\energy\energyNoTransitionEdgesNonPreservedMotifs_cellHeight2_20-Mar-2018.xls';
sphereNoTransition05Path= 'results\Sphere\energy\energyNoTransitionEdges_cellHeight05_02-Mar-2018.xls';
sphereNoTransition1Path= 'results\Sphere\energy\energyNoTransitionEdges_cellHeight1_02-Mar-2018.xls';
sphereNoTransition2Path= 'results\Sphere\energy\energyNoTransitionEdges_cellHeight2_02-Mar-2018.xls';


transitionPaths={stage8TransitionPath,stage4TransitionPath,globeTransition05Path,globeTransition1Path,...
    globeTransition2Path,rugbyTransition05Path,rugbyTransition1Path,rugbyTransition2Path,...
    sphereNoTransition05Path,sphereNoTransition1Path,sphereNoTransition2Path};
noTransitionPaths={stage8NoTransitionPath,stage4NoTransitionPath,globeNoTransition05Path,...
    globeNoTransition1Path,globeNoTransition2Path,rugbyNoTransition05Path,...
    rugbyNoTransition1Path,rugbyNoTransition2Path,...
    sphereNoTransition05Path,sphereNoTransition1Path,sphereNoTransition2Path};

meanScutoids=zeros(length(transitionPaths),1);
stdScutoids=zeros(length(transitionPaths),1);
meanTotalCells=zeros(length(transitionPaths),1);
stdTotalCells=zeros(length(transitionPaths),1);
for i=1:length(transitionPaths)%1:length(transitionPaths)
    [meanScutoids(i),stdScutoids(i),meanTotalCells(i),stdTotalCells(i)]=extractionOfScutoidsFromExcel(noTransitionPaths{i}, transitionPaths{i});
end
res = [meanScutoids, stdScutoids, meanTotalCells, stdTotalCells];