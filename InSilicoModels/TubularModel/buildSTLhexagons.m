addpath(genpath('src'))

%%STL Voronoi hexagons
intermediateSurfaceRatios = [];
surfaceRatio = 2.6667;
W_apical = 1024;
H_apical = 154;
numSeeds = 132;
reductionFactor = 0.5;
numImage = 1;


%dir 2 save
name2save = 'hexagons';
fullPath = 'data\tubularVoronoiModel\reduction\cylinderOfHexagons\512x1024_132seeds\';

%load source info
load([fullPath 'Image_1_Diagram_5.mat'],'listLOriginalProjection','listSeedsProjected');

%%get STL voronoi tube full of hexagons
initialSeeds = listSeedsProjected.seedsApical{3,1};
initialSeeds = initialSeeds(:,2:3);
initialSeeds(:,2) = initialSeeds(:,2)+1;
[~,~,~,~,~]=rebuilding3dVoronoiCylinderFromSeedsExpansion( initialSeeds, W_apical, H_apical, surfaceRatio,reductionFactor,intermediateSurfaceRatios,name2save,[fullPath 'stlInfo\Voronoi\reductionFactor_' num2str(reductionFactor) '\']);

%%STL frusta tube full of hexagons
imgApical = listLOriginalProjection.L_originalProjection{3,1};
createFrustaCylinderStl(H_apical,W_apical,imgApical, surfaceRatio,reductionFactor,intermediateSurfaceRatios,name2save,[fullPath 'stlInfo\Frusta\reductionFactor_' num2str(reductionFactor) '\'])

%%Calculate vertices connectivities
initialSurfaceRatio = 0.3;
intermediateSurfaceRatio=0.5;
basalSurfaceRatio=0.9;
% VoronoiOutput = 1 -> Voronoi
% VoronoiOutput = 2 -> Frusta
VoronoiOutput = 0;
calculateVerticesConnectionHexagons(fullPath,listLOriginalProjection,initialSurfaceRatio,intermediateSurfaceRatio,basalSurfaceRatio,VoronoiOutput)
