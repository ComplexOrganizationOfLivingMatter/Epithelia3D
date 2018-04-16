addpath(genpath('polarHistograms'))
addpath(genpath('ScatterPolar'))
addpath(genpath('src'))

relativePathTubularModel='..\InSilicoModels\paperCode\TubularModel\data\tubularVoronoiModel\expansion\512x4096_800seeds\';

transitionsFile='summaryAverageTransitionsMeasuredInBasal_Transitions';
noTransitionsFile='summaryAverageTransitionsMeasuredInBasal_NoTransitions';

edgeLengthThreshold=4;

%Loading 800 seeds data
% load([relativePathTubularModel transitionsFile],'acumAngles','acumEdges')
% 
% acumAnglesTransition800seeds=acumAngles;
% acumEdgesTransition800seeds=acumEdges;
% load([relativePathTubularModel noTransitionsFile],'acumAngles','acumEdges')
% acumAnglesNoTransition800seeds=acumAngles;
% acumEdgesNoTransition800seeds=acumEdges;
% 
% %transitios angles and length 800 seeds SR 1.25
% surfaceRatio125_800seeds.anglesTransition=acumAnglesTransition800seeds{3}(acumEdgesTransition800seeds{3} > edgeLengthThreshold);
% surfaceRatio125_800seeds.anglesNoTransition=acumAnglesNoTransition800seeds{3} (acumEdgesNoTransition800seeds{3} > edgeLengthThreshold);
% surfaceRatio125_800seeds.edgesTransition=acumEdgesTransition800seeds{3} (acumEdgesTransition800seeds{3} > edgeLengthThreshold);
% surfaceRatio125_800seeds.edgesNoTransition=acumEdgesNoTransition800seeds{3} (acumEdgesNoTransition800seeds{3} > edgeLengthThreshold);
% 
% p = randperm(length(surfaceRatio125_800seeds.anglesTransition),200);
% surfaceRatio125_800seeds.anglesTransitionFilter=surfaceRatio125_800seeds.anglesTransition(p);
% surfaceRatio125_800seeds.edgesTransitionFilter=surfaceRatio125_800seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio125_800seeds.anglesNoTransition),200);
% surfaceRatio125_800seeds.anglesNoTransitionFilter=surfaceRatio125_800seeds.anglesNoTransition(p);
% surfaceRatio125_800seeds.edgesNoTransitionFilter=surfaceRatio125_800seeds.edgesNoTransition(p);
% 
% %transitios angles and length 800 seeds SR 1.667
% surfaceRatio1667_800seeds.anglesTransition=acumAnglesTransition800seeds{5} (acumEdgesTransition800seeds{5} > edgeLengthThreshold);
% surfaceRatio1667_800seeds.anglesNoTransition=acumAnglesNoTransition800seeds{5} (acumEdgesNoTransition800seeds{5} > edgeLengthThreshold);
% surfaceRatio1667_800seeds.edgesTransition=acumEdgesTransition800seeds{5} (acumEdgesTransition800seeds{5} > edgeLengthThreshold);
% surfaceRatio1667_800seeds.edgesNoTransition=acumEdgesNoTransition800seeds{5} (acumEdgesNoTransition800seeds{5} > edgeLengthThreshold);
% 
% p = randperm(length(surfaceRatio1667_800seeds.anglesTransition),200);
% surfaceRatio1667_800seeds.anglesTransitionFilter=surfaceRatio1667_800seeds.anglesTransition(p);
% surfaceRatio1667_800seeds.edgesTransitionFilter=surfaceRatio1667_800seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio1667_800seeds.anglesNoTransition),200);
% surfaceRatio1667_800seeds.anglesNoTransitionFilter=surfaceRatio1667_800seeds.anglesNoTransition(p);
% surfaceRatio1667_800seeds.edgesNoTransitionFilter=surfaceRatio1667_800seeds.edgesNoTransition(p);
% 
% %transitios angles and length 800 seeds SR 2
% surfaceRatio2_800seeds.anglesTransition=acumAnglesTransition800seeds{6} (acumEdgesTransition800seeds{6} > edgeLengthThreshold);
% surfaceRatio2_800seeds.anglesNoTransition=acumAnglesNoTransition800seeds{6} (acumEdgesNoTransition800seeds{6} > edgeLengthThreshold);
% surfaceRatio2_800seeds.edgesTransition=acumEdgesTransition800seeds{6} (acumEdgesTransition800seeds{6} > edgeLengthThreshold);
% surfaceRatio2_800seeds.edgesNoTransition=acumEdgesNoTransition800seeds{6} (acumEdgesNoTransition800seeds{6} > edgeLengthThreshold);
% 
% p = randperm(length(surfaceRatio2_800seeds.anglesTransition),200);
% surfaceRatio2_800seeds.anglesTransitionFilter=surfaceRatio2_800seeds.anglesTransition(p);
% surfaceRatio2_800seeds.edgesTransitionFilter=surfaceRatio2_800seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio2_800seeds.anglesNoTransition),200);
% surfaceRatio2_800seeds.anglesNoTransitionFilter=surfaceRatio2_800seeds.anglesNoTransition(p);
% surfaceRatio2_800seeds.edgesNoTransitionFilter=surfaceRatio2_800seeds.edgesNoTransition(p);
% 
% %transitios angles and length 800 seeds SR 5
% surfaceRatio5_800seeds.anglesTransition=acumAnglesTransition800seeds{9} (acumEdgesTransition800seeds{9} > edgeLengthThreshold);
% surfaceRatio5_800seeds.anglesNoTransition=acumAnglesNoTransition800seeds{9} (acumEdgesNoTransition800seeds{9} > edgeLengthThreshold);
% surfaceRatio5_800seeds.edgesTransition=acumEdgesTransition800seeds{9} (acumEdgesTransition800seeds{9} > edgeLengthThreshold);
% surfaceRatio5_800seeds.edgesNoTransition=acumEdgesNoTransition800seeds{9} (acumEdgesNoTransition800seeds{9} > edgeLengthThreshold);
% 
% p = randperm(length(surfaceRatio5_800seeds.anglesTransition),200);
% surfaceRatio5_800seeds.anglesTransitionFilter=surfaceRatio5_800seeds.anglesTransition(p);
% surfaceRatio5_800seeds.edgesTransitionFilter=surfaceRatio5_800seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio5_800seeds.anglesNoTransition),200);
% surfaceRatio5_800seeds.anglesNoTransitionFilter=surfaceRatio5_800seeds.anglesNoTransition(p);
% surfaceRatio5_800seeds.edgesNoTransitionFilter=surfaceRatio5_800seeds.edgesNoTransition(p);
% 
% %transitios angles and length 800 seeds SR 10
% surfaceRatio10_800seeds.anglesTransition=acumAnglesTransition800seeds{10} (acumEdgesTransition800seeds{10} > edgeLengthThreshold);
% surfaceRatio10_800seeds.anglesNoTransition=acumAnglesNoTransition800seeds{10} (acumEdgesNoTransition800seeds{10} > edgeLengthThreshold);
% surfaceRatio10_800seeds.edgesTransition=acumEdgesTransition800seeds{10} (acumEdgesTransition800seeds{10} > edgeLengthThreshold);
% surfaceRatio10_800seeds.edgesNoTransition=acumEdgesNoTransition800seeds{10} (acumEdgesNoTransition800seeds{10} > edgeLengthThreshold);
% 
% p = randperm(length(surfaceRatio10_800seeds.anglesTransition),200);
% surfaceRatio10_800seeds.anglesTransitionFilter=surfaceRatio10_800seeds.anglesTransition(p);
% surfaceRatio10_800seeds.edgesTransitionFilter=surfaceRatio10_800seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio10_800seeds.anglesNoTransition),200);
% surfaceRatio10_800seeds.anglesNoTransitionFilter=surfaceRatio10_800seeds.anglesNoTransition(p);
% surfaceRatio10_800seeds.edgesNoTransitionFilter=surfaceRatio10_800seeds.edgesNoTransition(p);
% 
% 
% %Loading 60 seeds data
% load([strrep(relativePathTubularModel,'512x4096_800','512x4096_60') transitionsFile],'acumAngles','acumEdges')
% acumAnglesTransition60seeds=acumAngles;
% acumEdgesTransition60seeds=acumEdges;
% load([strrep(relativePathTubularModel,'512x4096_800','512x4096_60') noTransitionsFile],'acumAngles','acumEdges')
% acumAnglesNoTransition60seeds=acumAngles;
% acumEdgesNoTransition60seeds=acumEdges;
% 
% %transitios angles and length 60 seeds SR 6.6667
% surfaceRatio6667_60seeds.anglesTransition=acumAnglesTransition60seeds{2} (acumEdgesTransition60seeds{2} > edgeLengthThreshold);
% surfaceRatio6667_60seeds.anglesNoTransition=acumAnglesNoTransition60seeds{2} (acumEdgesNoTransition60seeds{2} > edgeLengthThreshold);
% surfaceRatio6667_60seeds.edgesTransition=acumEdgesTransition60seeds{2} (acumEdgesTransition60seeds{2} > edgeLengthThreshold);
% surfaceRatio6667_60seeds.edgesNoTransition=acumEdgesNoTransition60seeds{2} (acumEdgesNoTransition60seeds{2} > edgeLengthThreshold);
% 
% p = randperm(length(surfaceRatio6667_60seeds.anglesTransition),200);
% surfaceRatio6667_60seeds.anglesTransitionFilter=surfaceRatio6667_60seeds.anglesTransition(p);
% surfaceRatio6667_60seeds.edgesTransitionFilter=surfaceRatio6667_60seeds.edgesTransition(p);
% p = randperm(length(surfaceRatio6667_60seeds.anglesNoTransition),200);
% surfaceRatio6667_60seeds.anglesNoTransitionFilter=surfaceRatio6667_60seeds.anglesNoTransition(p);
% surfaceRatio6667_60seeds.edgesNoTransitionFilter=surfaceRatio6667_60seeds.edgesNoTransition(p);
% 
% save('lengthAnglesEdges_Transition_NoTransition_voronoiTubularModels800seeds.mat','surfaceRatio125_800seeds','surfaceRatio1667_800seeds','surfaceRatio2_800seeds','surfaceRatio5_800seeds','surfaceRatio10_800seeds')
% save('lengthAnglesEdges_Transition_NoTransition_voronoiTubularModels60seeds.mat','surfaceRatio6667_60seeds');
% 
% %load and save ellipsoids measurements
% relativePathEllipsoidModel='..\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\';
% load([relativePathEllipsoidModel 'stage 4\resolutionThreshold4\dataAngleLengthEdges_12-Apr-2018.mat'],'totalLengthTransition','totalLengthNoTransition','totalAnglesTransition','totalAnglesNoTransition')
% p1 = randperm(length(totalAnglesTransition > edgeLengthThreshold),200);
% p2 = randperm(length(totalAnglesNoTransition > edgeLengthThreshold),200);
% ellipsoidStage4.anglesTransition=totalAnglesTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidStage4.edgeTransition=totalLengthTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidStage4.anglesNoTransition=totalAnglesNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidStage4.edgeNoTransition=totalLengthNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidStage4.anglesTransitionFilter=totalAnglesTransition(p1);
% ellipsoidStage4.edgeTransitionFilter=totalLengthTransition(p1);
% ellipsoidStage4.anglesNoTransitionFilter=totalAnglesNoTransition(p2);
% ellipsoidStage4.edgeNoTransitionFilter=totalLengthNoTransition(p2);
% 
% load([relativePathEllipsoidModel 'stage 8\resolutionThreshold4\dataAngleLengthEdges_09-Apr-2018.mat'],'totalLengthTransition','totalLengthNoTransition','totalAnglesTransition','totalAnglesNoTransition')
% nRandoms1=min([200,length(totalAnglesTransition(totalAnglesTransition > edgeLengthThreshold))]);
% nRandoms2=min([200,length(totalAnglesNoTransition(totalAnglesNoTransition > edgeLengthThreshold))]);
% p1 = randperm(length(totalAnglesTransition(totalAnglesTransition > edgeLengthThreshold)),nRandoms1);
% p2 = randperm(length(totalAnglesNoTransition(totalAnglesNoTransition > edgeLengthThreshold)),nRandoms2);
% ellipsoidStage8.anglesTransition=totalAnglesTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidStage8.edgeTransition=totalLengthTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidStage8.anglesNoTransition=totalAnglesNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidStage8.edgeNoTransition=totalLengthNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidStage8.anglesTransitionFilter=totalAnglesTransition(p1);
% ellipsoidStage8.edgeTransitionFilter=totalLengthTransition(p1);
% ellipsoidStage8.anglesNoTransitionFilter=totalAnglesNoTransition(p2);
% ellipsoidStage8.edgeNoTransitionFilter=totalLengthNoTransition(p2);
% 
% load([relativePathEllipsoidModel 'Globe\resolutionThreshold4\dataAngleLengthEdges_cellHeight2_10-Apr-2018.mat'],'totalLengthTransition','totalLengthNoTransition','totalAnglesTransition','totalAnglesNoTransition')
% nRandoms1=min([200,length(totalAnglesTransition(totalAnglesTransition > edgeLengthThreshold))]);
% nRandoms2=min([200,length(totalAnglesNoTransition(totalAnglesNoTransition > edgeLengthThreshold))]);
% p1 = randperm(length(totalAnglesTransition(totalAnglesTransition > edgeLengthThreshold)),nRandoms1);
% p2 = randperm(length(totalAnglesNoTransition(totalAnglesNoTransition > edgeLengthThreshold)),nRandoms2);
% ellipsoidGlobe2.anglesTransition=totalAnglesTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidGlobe2.edgeTransition=totalLengthTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidGlobe2.anglesNoTransition=totalAnglesNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidGlobe2.edgeNoTransition=totalLengthNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidGlobe2.anglesTransitionFilter=totalAnglesTransition(p1);
% ellipsoidGlobe2.edgeTransitionFilter=totalLengthTransition(p1);
% ellipsoidGlobe2.anglesNoTransitionFilter=totalAnglesNoTransition(p2);
% ellipsoidGlobe2.edgeNoTransitionFilter=totalLengthNoTransition(p2);
% 
% load([relativePathEllipsoidModel 'Globe\resolutionThreshold4\dataAngleLengthEdges_cellHeight1_11-Apr-2018.mat'],'totalLengthTransition','totalLengthNoTransition','totalAnglesTransition','totalAnglesNoTransition')
% nRandoms1=min([200,length(totalAnglesTransition(totalAnglesTransition > edgeLengthThreshold))]);
% nRandoms2=min([200,length(totalAnglesNoTransition(totalAnglesNoTransition > edgeLengthThreshold))]);
% p1 = randperm(length(totalAnglesTransition(totalAnglesTransition > edgeLengthThreshold)),nRandoms1);
% p2 = randperm(length(totalAnglesNoTransition(totalAnglesNoTransition > edgeLengthThreshold)),nRandoms2);
% ellipsoidGlobe1.anglesTransition=totalAnglesTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidGlobe1.edgeTransition=totalLengthTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidGlobe1.anglesNoTransition=totalAnglesNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidGlobe1.edgeNoTransition=totalLengthNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidGlobe1.anglesTransitionFilter=totalAnglesTransition(p1);
% ellipsoidGlobe1.edgeTransitionFilter=totalLengthTransition(p1);
% ellipsoidGlobe1.anglesNoTransitionFilter=totalAnglesNoTransition(p2);
% ellipsoidGlobe1.edgeNoTransitionFilter=totalLengthNoTransition(p2);
% 
% load([relativePathEllipsoidModel 'Globe\resolutionThreshold4\dataAngleLengthEdges_cellHeight0.5_11-Apr-2018.mat'],'totalLengthTransition','totalLengthNoTransition','totalAnglesTransition','totalAnglesNoTransition')
% nRandoms1=min([200,length(totalAnglesTransition(totalAnglesTransition > edgeLengthThreshold))]);
% nRandoms2=min([200,length(totalAnglesNoTransition(totalAnglesNoTransition > edgeLengthThreshold))]);
% p1 = randperm(length(totalAnglesTransition(totalAnglesTransition > edgeLengthThreshold)),nRandoms1);
% p2 = randperm(length(totalAnglesNoTransition(totalAnglesNoTransition > edgeLengthThreshold)),nRandoms2);
% ellipsoidGlobe05.anglesTransition=totalAnglesTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidGlobe05.edgeTransition=totalLengthTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidGlobe05.anglesNoTransition=totalAnglesNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidGlobe05.edgeNoTransition=totalLengthNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidGlobe05.anglesTransitionFilter=totalAnglesTransition(p1);
% ellipsoidGlobe05.edgeTransitionFilter=totalLengthTransition(p1);
% ellipsoidGlobe05.anglesNoTransitionFilter=totalAnglesNoTransition(p2);
% ellipsoidGlobe05.edgeNoTransitionFilter=totalLengthNoTransition(p2);
% 
% load([relativePathEllipsoidModel 'Rugby\resolutionThreshold4\dataAngleLengthEdges_cellHeight2_10-Apr-2018.mat'],'totalLengthTransition','totalLengthNoTransition','totalAnglesTransition','totalAnglesNoTransition')
% nRandoms1=min([200,length(totalAnglesTransition(totalAnglesTransition > edgeLengthThreshold))]);
% nRandoms2=min([200,length(totalAnglesNoTransition(totalAnglesNoTransition > edgeLengthThreshold))]);
% p1 = randperm(length(totalAnglesTransition(totalAnglesTransition > edgeLengthThreshold)),nRandoms1);
% p2 = randperm(length(totalAnglesNoTransition(totalAnglesNoTransition > edgeLengthThreshold)),nRandoms2);
% ellipsoidRugby2.anglesTransition=totalAnglesTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidRugby2.edgeTransition=totalLengthTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidRugby2.anglesNoTransition=totalAnglesNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidRugby2.edgeNoTransition=totalLengthNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidRugby2.anglesTransitionFilter=totalAnglesTransition(p1);
% ellipsoidRugby2.edgeTransitionFilter=totalLengthTransition(p1);
% ellipsoidRugby2.anglesNoTransitionFilter=totalAnglesNoTransition(p2);
% ellipsoidRugby2.edgeNoTransitionFilter=totalLengthNoTransition(p2);
% 
% load([relativePathEllipsoidModel 'Rugby\resolutionThreshold4\dataAngleLengthEdges_cellHeight1_10-Apr-2018.mat'],'totalLengthTransition','totalLengthNoTransition','totalAnglesTransition','totalAnglesNoTransition')
% nRandoms1=min([200,length(totalAnglesTransition(totalAnglesTransition > edgeLengthThreshold))]);
% nRandoms2=min([200,length(totalAnglesNoTransition(totalAnglesNoTransition > edgeLengthThreshold))]);
% p1 = randperm(length(totalAnglesTransition(totalAnglesTransition > edgeLengthThreshold)),nRandoms1);
% p2 = randperm(length(totalAnglesNoTransition(totalAnglesNoTransition > edgeLengthThreshold)),nRandoms2);
% ellipsoidRugby1.anglesTransition=totalAnglesTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidRugby1.edgeTransition=totalLengthTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidRugby1.anglesNoTransition=totalAnglesNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidRugby1.edgeNoTransition=totalLengthNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidRugby1.anglesTransitionFilter=totalAnglesTransition(p1);
% ellipsoidRugby1.edgeTransitionFilter=totalLengthTransition(p1);
% ellipsoidRugby1.anglesNoTransitionFilter=totalAnglesNoTransition(p2);
% ellipsoidRugby1.edgeNoTransitionFilter=totalLengthNoTransition(p2);
% 
% load([relativePathEllipsoidModel 'Rugby\resolutionThreshold4\dataAngleLengthEdges_cellHeight0.5_10-Apr-2018.mat'],'totalLengthTransition','totalLengthNoTransition','totalAnglesTransition','totalAnglesNoTransition')
% nRandoms1=min([200,length(totalAnglesTransition(totalAnglesTransition > edgeLengthThreshold))]);
% nRandoms2=min([200,length(totalAnglesNoTransition(totalAnglesNoTransition > edgeLengthThreshold))]);
% p1 = randperm(length(totalAnglesTransition(totalAnglesTransition > edgeLengthThreshold)),nRandoms1);
% p2 = randperm(length(totalAnglesNoTransition(totalAnglesNoTransition > edgeLengthThreshold)),nRandoms2);
% ellipsoidRugby05.anglesTransition=totalAnglesTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidRugby05.edgeTransition=totalLengthTransition(totalLengthTransition > edgeLengthThreshold);
% ellipsoidRugby05.anglesNoTransition=totalAnglesNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidRugby05.edgeNoTransition=totalLengthNoTransition(totalLengthNoTransition > edgeLengthThreshold);
% ellipsoidRugby05.anglesTransitionFilter=totalAnglesTransition(p1);
% ellipsoidRugby05.edgeTransitionFilter=totalLengthTransition(p1);
% ellipsoidRugby05.anglesNoTransitionFilter=totalAnglesNoTransition(p2);
% ellipsoidRugby05.edgeNoTransitionFilter=totalLengthNoTransition(p2);
% 
% 
% save('lengthAnglesEdges_Transition_NoTransition_voronoiEllipsoidModels.mat','ellipsoidStage8','ellipsoidStage4','ellipsoidGlobe05','ellipsoidGlobe1','ellipsoidGlobe2','ellipsoidRugby05','ellipsoidRugby1','ellipsoidRugby2');

load('lengthAnglesEdges_Transition_NoTransition_voronoiEllipsoidModels.mat','ellipsoidStage8','ellipsoidStage4','ellipsoidGlobe05','ellipsoidGlobe1','ellipsoidGlobe2','ellipsoidRugby05','ellipsoidRugby1','ellipsoidRugby2');
load('lengthAnglesEdges_Transition_NoTransition_voronoiTubularModels800seeds.mat','surfaceRatio125_800seeds','surfaceRatio1667_800seeds','surfaceRatio2_800seeds','surfaceRatio5_800seeds','surfaceRatio10_800seeds')
load('lengthAnglesEdges_Transition_NoTransition_voronoiTubularModels60seeds.mat','surfaceRatio6667_60seeds')

setOfDistributions={surfaceRatio125_800seeds,surfaceRatio1667_800seeds,surfaceRatio2_800seeds,surfaceRatio5_800seeds,surfaceRatio10_800seeds,surfaceRatio6667_60seeds,ellipsoidStage4,ellipsoidStage8,ellipsoidGlobe05,ellipsoidGlobe1,ellipsoidGlobe2,ellipsoidRugby05,ellipsoidRugby1,ellipsoidRugby2};
titles={'Tubular Model 1.25','Tubular Model 1.667','Tubular Model 2', 'Tubular Model 5','Tubular Model 10', 'Tubular Model like Salivary Gland','Spheroid model stage 4','Spheroid model stage 8','Spheroid model Globe 0.5','Spheroid model Globe 1','Spheroid model Globe 2','Spheroid model zepellin 0.5','Spheroid model zepellin 1','Spheroid model zepellin 2'};

colourTrans = [102 204 204]/255;
colourNoTrans = [1 102/255 0];

statsTubularModel=zeros(length(setOfDistributions),4);
statsTubularModelFilter=zeros(length(setOfDistributions),4);
for i = 1 : length(setOfDistributions)
   
%     createPolarHistogram(setOfDistributions{i}.anglesTransitionFilter, colourTrans, [titles{i} '- Transition']);
%     createPolarHistogram(setOfDistributions{i}.anglesNoTransitionFilter, colourNoTrans, [titles{i} '- No transition']);
%     close
%     createScatterPolar( setOfDistributions{i}.anglesTransitionFilter,setOfDistributions{i}.edgesTransitionFilter,setOfDistributions{i}.anglesNoTransitionFilter,setOfDistributions{i}.edgesNoTransitionFilter,titles{i})
%     close

    [H_angles, pValue_angles]=kstest2(setOfDistributions{i}.anglesTransition,setOfDistributions{i}.anglesNoTransition);
    [H_edges, pValue_edges]=kstest2(setOfDistributions{i}.edgesTransition,setOfDistributions{i}.edgesNoTransition);
    statsTubularModel(i,:)=[H_angles, pValue_angles,H_edges, pValue_edges];

    [H_anglesFilter, pValue_anglesFilter]=kstest2(setOfDistributions{i}.anglesTransitionFilter,setOfDistributions{i}.anglesNoTransitionFilter);
    [H_edgesFilter, pValue_edgesFilter]=kstest2(setOfDistributions{i}.edgesTransitionFilter,setOfDistributions{i}.edgesNoTransitionFilter);
    statsTubularModelFilter(i,:)=[H_anglesFilter, pValue_anglesFilter,H_edgesFilter, pValue_edgesFilter];     
end
