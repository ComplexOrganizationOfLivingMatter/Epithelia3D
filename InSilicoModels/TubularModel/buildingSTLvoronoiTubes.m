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

addpath(genpath('beforePaperCode\srcBeforePaperCode\projectionSurfaceVoronoi5\'));
tic
main3dVoronoiSegmentCylinder(H_apical,W_apical,numSeeds,numTotalImages,surfaceRatio,intermediateSurfaceRatios,reductionFactor,initialDiagram,typeProjection,path2save);

toc