addpath(genpath('..'))

relativePathTubularModel='..\..\InSilicoModels\paperCode\TubularModel\data\tubularVoronoiModel\expansion\512x4096_800seeds\';

transitionsFile='summaryAverageTransitionsMeasuredInBasal_Transitions';
noTransitionsFile='summaryAverageTransitionsMeasuredInBasal_NoTransitions';

%% Loading 800 seeds data
% load([relativePathTubularModel transitionsFile],'acumAngles','acumEdges')
% acumAnglesTransition800seeds=acumAngles;
% acumEdgesTransition800seeds=acumEdges;
% load([relativePathTubularModel noTransitionsFile],'acumAngles','acumEdges')
% acumAnglesNoTransition800seeds=acumAngles;
% acumEdgesNoTransition800seeds=acumEdges;

% %transitios angles and length 800 seeds SR 1.25
% surfaceRatio125_800seeds.anglesTransition=acumAnglesTransition800seeds{3};
% surfaceRatio125_800seeds.anglesNoTransition=acumAnglesNoTransition800seeds{3};
% surfaceRatio125_800seeds.edgesTransition=acumEdgesTransition800seeds{3};
% surfaceRatio125_800seeds.edgesNoTransition=acumEdgesNoTransition800seeds{3};
% 
% p = randperm(length(surfaceRatio125_800seeds.anglesTransition),200);
% surfaceRatio125_800seeds.anglesTransitionFilter=surfaceRatio125_800seeds.anglesTransition(p);
% surfaceRatio125_800seeds.edgesTransitionFilter=surfaceRatio125_800seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio125_800seeds.anglesNoTransition),200);
% surfaceRatio125_800seeds.anglesNoTransitionFilter=surfaceRatio125_800seeds.anglesNoTransition(p);
% surfaceRatio125_800seeds.edgesNoTransitionFilter=surfaceRatio125_800seeds.edgesNoTransition(p);
% 
% 
% %transitios angles and length 800 seeds SR 1.667
% surfaceRatio1667_800seeds.anglesTransition=acumAnglesTransition800seeds{5};
% surfaceRatio1667_800seeds.anglesNoTransition=acumAnglesNoTransition800seeds{5};
% surfaceRatio1667_800seeds.edgesTransition=acumEdgesTransition800seeds{5};
% surfaceRatio1667_800seeds.edgesNoTransition=acumEdgesNoTransition800seeds{5};
% 
% p = randperm(length(surfaceRatio1667_800seeds.anglesTransition),200);
% surfaceRatio1667_800seeds.anglesTransitionFilter=surfaceRatio1667_800seeds.anglesTransition(p);
% surfaceRatio1667_800seeds.edgesTransitionFilter=surfaceRatio1667_800seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio1667_800seeds.anglesNoTransition),200);
% surfaceRatio1667_800seeds.anglesNoTransitionFilter=surfaceRatio1667_800seeds.anglesNoTransition(p);
% surfaceRatio1667_800seeds.edgesNoTransitionFilter=surfaceRatio1667_800seeds.edgesNoTransition(p);
% 
% %transitios angles and length 800 seeds SR 2
% surfaceRatio2_800seeds.anglesTransition=acumAnglesTransition800seeds{6};
% surfaceRatio2_800seeds.anglesNoTransition=acumAnglesNoTransition800seeds{6};
% surfaceRatio2_800seeds.edgesTransition=acumEdgesTransition800seeds{6};
% surfaceRatio2_800seeds.edgesNoTransition=acumEdgesNoTransition800seeds{6};
% 
% p = randperm(length(surfaceRatio2_800seeds.anglesTransition),200);
% surfaceRatio2_800seeds.anglesTransitionFilter=surfaceRatio2_800seeds.anglesTransition(p);
% surfaceRatio2_800seeds.edgesTransitionFilter=surfaceRatio2_800seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio2_800seeds.anglesNoTransition),200);
% surfaceRatio2_800seeds.anglesNoTransitionFilter=surfaceRatio2_800seeds.anglesNoTransition(p);
% surfaceRatio2_800seeds.edgesNoTransitionFilter=surfaceRatio2_800seeds.edgesNoTransition(p);
% 
% %transitios angles and length 800 seeds SR 5
% surfaceRatio5_800seeds.anglesTransition=acumAnglesTransition800seeds{9};
% surfaceRatio5_800seeds.anglesNoTransition=acumAnglesNoTransition800seeds{9};
% surfaceRatio5_800seeds.edgesTransition=acumEdgesTransition800seeds{9};
% surfaceRatio5_800seeds.edgesNoTransition=acumEdgesNoTransition800seeds{9};
% 
% p = randperm(length(surfaceRatio5_800seeds.anglesTransition),200);
% surfaceRatio5_800seeds.anglesTransitionFilter=surfaceRatio5_800seeds.anglesTransition(p);
% surfaceRatio5_800seeds.edgesTransitionFilter=surfaceRatio5_800seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio5_800seeds.anglesNoTransition),200);
% surfaceRatio5_800seeds.anglesNoTransitionFilter=surfaceRatio5_800seeds.anglesNoTransition(p);
% surfaceRatio5_800seeds.edgesNoTransitionFilter=surfaceRatio5_800seeds.edgesNoTransition(p);

% %transitios angles and length 800 seeds SR 10
% surfaceRatio10_800seeds.anglesTransition=acumAnglesTransition800seeds{10};
% surfaceRatio10_800seeds.anglesNoTransition=acumAnglesNoTransition800seeds{10};
% surfaceRatio10_800seeds.edgesTransition=acumEdgesTransition800seeds{10};
% surfaceRatio10_800seeds.edgesNoTransition=acumEdgesNoTransition800seeds{10};
% 
% p = randperm(length(surfaceRatio10_800seeds.anglesTransition),200);
% surfaceRatio10_800seeds.anglesTransitionFilter=surfaceRatio10_800seeds.anglesTransition(p);
% surfaceRatio10_800seeds.edgesTransitionFilter=surfaceRatio10_800seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio10_800seeds.anglesNoTransition),200);
% surfaceRatio10_800seeds.anglesNoTransitionFilter=surfaceRatio10_800seeds.anglesNoTransition(p);
% surfaceRatio10_800seeds.edgesNoTransitionFilter=surfaceRatio10_800seeds.edgesNoTransition(p);

% 
% %% Loading 60 seeds data
% load([strrep(relativePathTubularModel,'512x4096_800','512x4096_60') transitionsFile],'acumAngles','acumEdges')
% acumAnglesTransition60seeds=acumAngles;
% acumEdgesTransition60seeds=acumEdges;
% load([strrep(relativePathTubularModel,'512x4096_800','512x4096_60') noTransitionsFile],'acumAngles','acumEdges')
% acumAnglesNoTransition60seeds=acumAngles;
% acumEdgesNoTransition60seeds=acumEdges;
% 
% %transitios angles and length 60 seeds SR 6.6667
% surfaceRatio6667_60seeds.anglesTransition=acumAnglesTransition60seeds{2};
% surfaceRatio6667_60seeds.anglesNoTransition=acumAnglesNoTransition60seeds{2};
% surfaceRatio6667_60seeds.edgesTransition=acumEdgesTransition60seeds{2};
% surfaceRatio6667_60seeds.edgesNoTransition=acumEdgesNoTransition60seeds{2};
% 
% p = randperm(length(surfaceRatio6667_60seeds.anglesTransition),200);
% surfaceRatio6667_60seeds.anglesTransitionFilter=surfaceRatio6667_60seeds.anglesTransition(p);
% surfaceRatio6667_60seeds.edgesTransitionFilter=surfaceRatio6667_60seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio6667_60seeds.anglesNoTransition),200);
% surfaceRatio6667_60seeds.anglesNoTransitionFilter=surfaceRatio6667_60seeds.anglesNoTransition(p);
% surfaceRatio6667_60seeds.edgesNoTransitionFilter=surfaceRatio6667_60seeds.edgesNoTransition(p);
% 
% 
% 
% save('..\lengthAnglesEdges_Transition_NoTransition_voronoiTubularModels800seeds.mat','surfaceRatio125_800seeds','surfaceRatio1667_800seeds','surfaceRatio2_800seeds','surfaceRatio5_800seeds','surfaceRatio10_800seeds')
% save('..\lengthAnglesEdges_Transition_NoTransition_voronoiTubularModels60seeds.mat','surfaceRatio6667_60seeds');
% 
% relativePathEllipsoidModel='..\..\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\';
% load([relativePathEllipsoidModel 'stage 4\dataAngleLengthEdges.mat'],'totalLengthTransition','totalLengthNoTransition','totalAnglesTransition','totalAnglesNoTransition')
% p = randperm(length(totalAnglesTransition),200);
% ellipsoidStage4.anglesTransition=totalAnglesTransition;
% ellipsoidStage4.edgeTransition=totalLengthTransition;
% ellipsoidStage4.anglesNoTransition=totalAnglesNoTransition;
% ellipsoidStage4.edgeNoTransition=totalLengthNoTransition;
% ellipsoidStage4.anglesTransitionFilter=totalAnglesTransition(p);
% ellipsoidStage4.edgeTransitionFilter=totalLengthTransition(p);
% ellipsoidStage4.anglesNoTransitionFilter=totalAnglesNoTransition(p);
% ellipsoidStage4.edgeNoTransitionFilter=totalLengthNoTransition(p);
% 
% load([relativePathEllipsoidModel 'stage 8\dataAngleLengthEdges.mat'],'totalLengthTransition','totalLengthNoTransition','totalAnglesTransition','totalAnglesNoTransition')
% p = randperm(length(totalAnglesTransition),200);
% ellipsoidStage8.anglesTransition=totalAnglesTransition;
% ellipsoidStage8.edgeTransition=totalLengthTransition;
% ellipsoidStage8.anglesNoTransition=totalAnglesNoTransition;
% ellipsoidStage8.edgeNoTransition=totalLengthNoTransition;
% ellipsoidStage8.anglesTransitionFilter=totalAnglesTransition(p);
% ellipsoidStage8.edgeTransitionFilter=totalLengthTransition(p);
% ellipsoidStage8.anglesNoTransitionFilter=totalAnglesNoTransition(p);
% ellipsoidStage8.edgeNoTransitionFilter=totalLengthNoTransition(p);
% 
% save('..\lengthAnglesEdges_Transition_NoTransition_voronoiEllipsoidModels.mat','ellipsoidStage8','ellipsoidStage4');

load('..\lengthAnglesEdges_Transition_NoTransition_voronoiEllipsoidModels.mat','ellipsoidStage8','ellipsoidStage4');
load('..\lengthAnglesEdges_Transition_NoTransition_voronoiTubularModels800seeds.mat','surfaceRatio125_800seeds','surfaceRatio1667_800seeds','surfaceRatio2_800seeds','surfaceRatio5_800seeds','surfaceRatio10_800seeds')
load('..\lengthAnglesEdges_Transition_NoTransition_voronoiTubularModels60seeds.mat','surfaceRatio6667_60seeds')

setOfDistributions={surfaceRatio125_800seeds,surfaceRatio1667_800seeds,surfaceRatio2_800seeds,surfaceRatio5_800seeds,surfaceRatio10_800seeds,surfaceRatio6667_60seeds,ellipsoidStage4,ellipsoidStage8};
titles={'Tubular Model 1.25','Tubular Model 1.667','Tubular Model 2', 'Tubular Model 5','Tubular Model 10', 'Tubular Model like Salivary Gland','Ellipsoid model stage 4','Ellipsoid model stage 8'};

colourTrans = [102 204 204]/255;
colourNoTrans = [1 102/255 0];

statsTubularModel=zeros(length(setOfDistributions),4);

for i = 1 : length(setOfDistributions)
   
%     createPolarHistogram(setOfDistributions{i}.anglesTransitionFilter, colourTrans, [titles{i} '- Transition']);
%     createPolarHistogram(setOfDistributions{i}.anglesNoTransitionFilter, colourNoTrans, [titles{i} '- No transition']);
%     close
%     createScatterPolar( setOfDistributions{i}.anglesTransitionFilter,setOfDistributions{i}.edgesTransitionFilter,setOfDistributions{i}.anglesNoTransitionFilter,setOfDistributions{i}.edgesNoTransitionFilter,titles{i})
    [H_angles, pValue_angles]=kstest2(setOfDistributions{i}.anglesTransition,setOfDistributions{i}.anglesNoTransition);
    [H_edges, pValue_edges]=kstest2(setOfDistributions{i}.lengthTransition,setOfDistributions{i}.lengthNoTransition);
    statsTubularModel(i,:)=[H_angles, pValue_angles,H_edges, pValue_edges];

    [H_anglesFilter, pValue_anglesFilter]=kstest2(setOfDistributions{i}.anglesTransitionFilter,setOfDistributions{i}.anglesNoTransitionFilter);
    [H_edgesFilter, pValue_edgesFilter]=kstest2(setOfDistributions{i}.lengthTransitionFilter,setOfDistributions{i}.lengthNoTransitionFilter);
    statsTubularModelFilter(i,:)=[H_anglesFilter, pValue_anglesFilter,H_edgesFilter, pValue_edgesFilter];     
end
