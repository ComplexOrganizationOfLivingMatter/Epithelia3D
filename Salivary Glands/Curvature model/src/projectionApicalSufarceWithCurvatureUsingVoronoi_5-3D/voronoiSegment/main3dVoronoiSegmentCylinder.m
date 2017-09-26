H_apical=1024;
W_apical=512;
numSeeds=20;
numImage=1;
surfaceRatio=2;
load(['..\..\..\data\expansion\512x1024_' num2str(numSeeds) 'seeds\Image_' num2str(numImage) '_Diagram_5\Image_' num2str(numImage) '_Diagram_5.mat'],'listSeedsProjected')
initialSeeds=listSeedsProjected.seedsApical{1};
name2save= ['Image_' num2str(numSeeds) '_' num2str(numSeeds) 'seeds'];
rebuilding3dVoronoiCylinderFromSeedsExpansion( initialSeeds, H_apical, W_apical, surfaceRatio,name2save)