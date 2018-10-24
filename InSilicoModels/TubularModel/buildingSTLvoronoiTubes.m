%%Stl tube building
H_apical = 512;
W_apical = 1024;
numSeeds = 40;
numTotalImages = 1;
reductionFactor = 1;
surfaceRatio = 5;
intermediateSurfaceRatios = [];
initialDiagram = 8;
typeProjection = 'expansion';
path2save = ['data\tubularVoronoiModel\expansion\' num2str(H_apical) 'x' num2str(W_apical) '_' num2str(numSeeds) 'seeds\stlInfo\'];

% addpath(genpath('beforePaperCode\srcBeforePaperCode\projectionSurfaceVoronoi5\'));
% tic
% main3dVoronoiSegmentCylinder(H_apical,W_apical,numSeeds,numTotalImages,surfaceRatio,intermediateSurfaceRatios,reductionFactor,initialDiagram,typeProjection,path2save);
% 
% toc

%%STL Voronoi hexagons
surfaceRatio = 2.6667;
W_apical = 1024;
H_apical = 154;
numSeeds = 132;
reductionFactor = 1;
numImage = 1;
name2save = 'hexagons';
fullPath = 'data\tubularVoronoiModel\reduction\cylinderOfHexagons\512x1024_132seeds\';
load([fullPath 'Image_1_Diagram_5.mat'],'listLOriginalProjection','listSeedsProjected');
initialSeeds = listSeedsProjected.seedsApical{3,1};
initialSeeds = initialSeeds(:,2:3);
initialSeeds(:,2) = initialSeeds(:,2)+1;
[info3DCell,~,~,~,~]=rebuilding3dVoronoiCylinderFromSeedsExpansion( initialSeeds, W_apical, H_apical, surfaceRatio,reductionFactor,intermediateSurfaceRatios,name2save,[fullPath 'stlInfo\']);
stlReconstruction(info3DCell,[fullPath 'stlInfo\'],numImage)