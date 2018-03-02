
addpath('src')

stage8TransitionPath= 'results/stage 8/energy/energyTransitionEdges_01-Mar-2018.xls';
stage4TransitionPath= 'results/stage 4/energy/energyTransitionEdges_01-Mar-2018.xls';
globeTransition05Path= 'results/globe/energy/energyTransitionEdges_cellHeight05_02-Mar-2018';
globeTransition1Path= 'results/globe/energy/energyTransitionEdges_cellHeight1_02-Mar-2018';
globeTransition2Path= 'results/globe/energy/energyTransitionEdges_cellHeight2_02-Mar-2018';
rugbyTransition05Path= 'results/rugby/energy/energyTransitionEdges_cellHeight05_02-Mar-2018';
rugbyTransition1Path= 'results/rugby/energy/energyTransitionEdges_cellHeight1_02-Mar-2018';
rugbyTransition2Path= 'results/rugby/energy/energyTransitionEdges_cellHeight2_02-Mar-2018';
% sphereTransitionPath= ;

stage8NoTransitionPath= 'results/stage 8/energy/energyNoTransitionEdges_01-Mar-2018.xls';
stage4NoTransitionPath= 'results/stage 4/energy/energyNoTransitionEdges_01-Mar-2018.xls';
globeNoTransition05Path= 'results/globe/energy/energyNoTransitionEdges_cellHeight05_02-Mar-2018';
globeNoTransition1Path= 'results/globe/energy/energyNoTransitionEdges_cellHeight1_02-Mar-2018';
globeNoTransition2Path= 'results/globe/energy/energyNoTransitionEdges_cellHeight2_02-Mar-2018';
rugbyNoTransition05Path= 'results/rugby/energy/energyNoTransitionEdges_cellHeight05_02-Mar-2018';
rugbyNoTransition1Path= 'results/rugby/energy/energyNoTransitionEdges_cellHeight1_02-Mar-2018';
rugbyNoTransition2Path= 'results/rugby/energy/energyNoTransitionEdges_cellHeight2_02-Mar-2018';
% sphereNoTransitionPath= ;

transitionPaths={stage8TransitionPath,stage4TransitionPath,globeTransition05Path,globeTransition1Path,...
    globeTransition2Path,rugbyTransition05Path,rugbyTransition1Path,rugbyTransition2Path};
noTransitionPaths={stage8NoTransitionPath,stage4NoTransitionPath,globeNoTransition05Path,...
    globeNoTransition1Path,globeNoTransition2Path,rugbyNoTransition05Path,rugbyNoTransition1Path,rugbyNoTransition2Path};

meanScutoids=zeros(length(transitionPaths),1);
stdScutoids=zeros(length(transitionPaths),1);
for i=1:length(transitionPaths)
    [meanScutoids(i),stdScutoids(i)]=extractionOfScutoidsFromExcel(noTransitionPaths{i}, transitionPaths{i});
end