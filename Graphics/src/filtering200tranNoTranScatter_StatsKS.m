addpath(genpath('..'))

% relativePathTubularModel='..\..\InSilicoModels\TubularModel\data\voronoiModel\expansion\512x1024_200seeds\';
% 
% transitionsFile='summaryAverageTransitionsMeasuredInBasal_Transitions';
% noTransitionsFile='summaryAverageTransitionsMeasuredInBasal_NoTransitions';
% 
% %% Loading 200 seeds data
% load([relativePathTubularModel transitionsFile],'acumAngles','acumEdges')
% acumAnglesTransition200seeds=acumAngles;
% acumEdgesTransition200seeds=acumEdges;
% load([relativePathTubularModel noTransitionsFile],'acumAngles','acumEdges')
% acumAnglesNoTransition200seeds=acumAngles;
% acumEdgesNoTransition200seeds=acumEdges;
% 
% %transitios angles and length 200 seeds SR 1.25
% surfaceRatio125_200seeds.anglesTransition=acumAnglesTransition200seeds{3};
% surfaceRatio125_200seeds.anglesNoTransition=acumAnglesNoTransition200seeds{3};
% surfaceRatio125_200seeds.edgesTransition=acumEdgesTransition200seeds{3};
% surfaceRatio125_200seeds.edgesNoTransition=acumEdgesNoTransition200seeds{3};
% 
% p = randperm(length(surfaceRatio125_200seeds.anglesTransition),200);
% surfaceRatio125_200seeds.anglesTransitionFilter=surfaceRatio125_200seeds.anglesTransition(p);
% surfaceRatio125_200seeds.edgesTransitionFilter=surfaceRatio125_200seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio125_200seeds.anglesNoTransition),200);
% surfaceRatio125_200seeds.anglesNoTransitionFilter=surfaceRatio125_200seeds.anglesNoTransition(p);
% surfaceRatio125_200seeds.edgesNoTransitionFilter=surfaceRatio125_200seeds.edgesNoTransition(p);
% 
% 
% %transitios angles and length 200 seeds SR 1.667
% surfaceRatio1667_200seeds.anglesTransition=acumAnglesTransition200seeds{5};
% surfaceRatio1667_200seeds.anglesNoTransition=acumAnglesNoTransition200seeds{5};
% surfaceRatio1667_200seeds.edgesTransition=acumEdgesTransition200seeds{5};
% surfaceRatio1667_200seeds.edgesNoTransition=acumEdgesNoTransition200seeds{5};
% 
% p = randperm(length(surfaceRatio1667_200seeds.anglesTransition),200);
% surfaceRatio1667_200seeds.anglesTransitionFilter=surfaceRatio1667_200seeds.anglesTransition(p);
% surfaceRatio1667_200seeds.edgesTransitionFilter=surfaceRatio1667_200seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio1667_200seeds.anglesNoTransition),200);
% surfaceRatio1667_200seeds.anglesNoTransitionFilter=surfaceRatio1667_200seeds.anglesNoTransition(p);
% surfaceRatio1667_200seeds.edgesNoTransitionFilter=surfaceRatio1667_200seeds.edgesNoTransition(p);
% 
% %transitios angles and length 200 seeds SR 2
% surfaceRatio2_200seeds.anglesTransition=acumAnglesTransition200seeds{6};
% surfaceRatio2_200seeds.anglesNoTransition=acumAnglesNoTransition200seeds{6};
% surfaceRatio2_200seeds.edgesTransition=acumEdgesTransition200seeds{6};
% surfaceRatio2_200seeds.edgesNoTransition=acumEdgesNoTransition200seeds{6};
% 
% p = randperm(length(surfaceRatio2_200seeds.anglesTransition),200);
% surfaceRatio2_200seeds.anglesTransitionFilter=surfaceRatio2_200seeds.anglesTransition(p);
% surfaceRatio2_200seeds.edgesTransitionFilter=surfaceRatio2_200seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio2_200seeds.anglesNoTransition),200);
% surfaceRatio2_200seeds.anglesNoTransitionFilter=surfaceRatio2_200seeds.anglesNoTransition(p);
% surfaceRatio2_200seeds.edgesNoTransitionFilter=surfaceRatio2_200seeds.edgesNoTransition(p);
% 
% %transitios angles and length 200 seeds SR 5
% surfaceRatio5_200seeds.anglesTransition=acumAnglesTransition200seeds{9};
% surfaceRatio5_200seeds.anglesNoTransition=acumAnglesNoTransition200seeds{9};
% surfaceRatio5_200seeds.edgesTransition=acumEdgesTransition200seeds{9};
% surfaceRatio5_200seeds.edgesNoTransition=acumEdgesNoTransition200seeds{9};
% 
% p = randperm(length(surfaceRatio5_200seeds.anglesTransition),200);
% surfaceRatio5_200seeds.anglesTransitionFilter=surfaceRatio5_200seeds.anglesTransition(p);
% surfaceRatio5_200seeds.edgesTransitionFilter=surfaceRatio5_200seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio5_200seeds.anglesNoTransition),200);
% surfaceRatio5_200seeds.anglesNoTransitionFilter=surfaceRatio5_200seeds.anglesNoTransition(p);
% surfaceRatio5_200seeds.edgesNoTransitionFilter=surfaceRatio5_200seeds.edgesNoTransition(p);
% 
% %% Loading 60 seeds data
% load([strrep(relativePathTubularModel,'512x1024_200','512x4096_60') transitionsFile],'acumAngles','acumEdges')
% acumAnglesTransition60seeds=acumAngles;
% acumEdgesTransition60seeds=acumEdges;
% load([strrep(relativePathTubularModel,'512x1024_200','512x4096_60') noTransitionsFile],'acumAngles','acumEdges')
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
% 
% save('..\lengthAnglesEdges_Transition_NoTransition_voronoiTubularModels.mat','surfaceRatio125_200seeds','surfaceRatio1667_200seeds','surfaceRatio2_200seeds','surfaceRatio5_200seeds','surfaceRatio6667_60seeds')
% 
% relativePathEllipsoidModel='..\..\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\';
% load([relativePathEllipsoidModel 'stage 4\dataAngleLengthEdges.mat'],'totalLengthTransition','totalLengthNoTransition','totalAnglesTransition','totalAnglesNoTransition')
% p = randperm(length(totalAnglesTransition),200);
% ellipsoidStage4.anglesTransition=totalAnglesTransition;
% ellipsoidStage4.lengthTransition=totalLengthTransition;
% ellipsoidStage4.anglesNoTransition=totalAnglesNoTransition;
% ellipsoidStage4.lengthNoTransition=totalLengthNoTransition;
% ellipsoidStage4.anglesTransitionFilter=totalAnglesTransition(p);
% ellipsoidStage4.lengthTransitionFilter=totalLengthTransition(p);
% ellipsoidStage4.anglesNoTransitionFilter=totalAnglesNoTransition(p);
% ellipsoidStage4.lengthNoTransitionFilter=totalLengthNoTransition(p);
% 
% load([relativePathEllipsoidModel 'stage 8\dataAngleLengthEdges.mat'],'totalLengthTransition','totalLengthNoTransition','totalAnglesTransition','totalAnglesNoTransition')
% p = randperm(length(totalAnglesTransition),200);
% ellipsoidStage8.anglesTransition=totalAnglesTransition;
% ellipsoidStage8.lengthTransition=totalLengthTransition;
% ellipsoidStage8.anglesNoTransition=totalAnglesNoTransition;
% ellipsoidStage8.lengthNoTransition=totalLengthNoTransition;
% ellipsoidStage8.anglesTransitionFilter=totalAnglesTransition(p);
% ellipsoidStage8.lengthTransitionFilter=totalLengthTransition(p);
% ellipsoidStage8.anglesNoTransitionFilter=totalAnglesNoTransition(p);
% ellipsoidStage8.lengthNoTransitionFilter=totalLengthNoTransition(p);
% 
% save('..\lengthAnglesEdges_Transition_NoTransition_voronoiEllipsoidModels.mat','ellipsoidStage8','ellipsoidStage4');

load('..\lengthAnglesEdges_Transition_NoTransition_voronoiEllipsoidModels.mat','ellipsoidStage8','ellipsoidStage4');
load('..\lengthAnglesEdges_Transition_NoTransition_voronoiTubularModels.mat','surfaceRatio125_200seeds','surfaceRatio1667_200seeds','surfaceRatio2_200seeds','surfaceRatio5_200seeds','surfaceRatio6667_60seeds')


setOfDistributions={surfaceRatio125_200seeds,surfaceRatio1667_200seeds,surfaceRatio2_200seeds,surfaceRatio5_200seeds,surfaceRatio6667_60seeds,ellipsoidStage4,ellipsoidStage8};
titles={'Tubular Model 1.25','Tubular Model 1.667','Tubular Model 2', 'Tubular Model 5', 'Tubular Model like Salivary Gland','Ellipsoid model stage 4','Ellipsoid model stage 8'};

colourTrans = [102 204 204]/255;
colourNoTrans = [1 102/255 0];

statsTubularModel=zeros(length(setOfDistributions),4);

for i = 1 : length(setOfDistributions)
   
    createPolarHistogram(setOfDistributions{i}.anglesTransitionFilter, colourTrans, [titles{i} '- Transition']);
    createPolarHistogram(setOfDistributions{i}.anglesNoTransitionFilter, colourNoTrans, [titles{i} '- No transition']);
    close
    createScatterPolar( setOfDistributions{i}.anglesTransitionFilter,setOfDistributions{i}.edgesTransitionFilter,setOfDistributions{i}.anglesNoTransitionFilter,setOfDistributions{i}.edgesNoTransitionFilter,titles{i})
%     [H_angles, pValue_angles]=kstest2(setOfDistributions{i}.anglesTransition,setOfDistributions{i}.anglesNoTransition);
%     [H_edges, pValue_edges]=kstest2(setOfDistributions{i}.edgesTransition,setOfDistributions{i}.edgesNoTransition);
%     statsTubularModel(i,:)=[H_angles, pValue_angles,H_edges, pValue_edges];

%     [H_anglesFilter, pValue_anglesFilter]=kstest2(setOfDistributions{i}.anglesTransition,setOfDistributions{i}.anglesNoTransition);
%     [H_edgesFilter, pValue_edgesFilter]=kstest2(setOfDistributions{i}.edgesTransition,setOfDistributions{i}.edgesNoTransition);
%     statsTubularModelFilter(i,:)=[H_anglesFilter, pValue_anglesFilter,H_edgesFilter, pValue_edgesFilter];     
end
