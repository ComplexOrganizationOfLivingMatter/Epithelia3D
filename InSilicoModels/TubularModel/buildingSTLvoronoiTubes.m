%%Stl tube building
H_apical = 512;
W_apical = 1024;
numSeeds = 40;
numTotalImages = 1;
reductionFactor = 5;
% surfaceRatio = 5;
intermediateSurfaceRatios = [];
initialDiagram = 8;
typeProjection = 'expansion';
colors = winter(numSeeds);
colors = colors(randperm(numSeeds),:);

for surfaceRatio = [10/8,2,10/3,5]
    
    path2save = ['data\tubularVoronoiModel\expansion\' num2str(H_apical) 'x' num2str(W_apical) '_' num2str(numSeeds) 'seeds\stlInfo\SR' num2str(surfaceRatio) '\'];

%     addpath(genpath('beforePaperCode\srcBeforePaperCode\projectionSurfaceVoronoi5\'));
    addpath(genpath('src'))
    % tic
%     main3dVoronoiSegmentCylinder(H_apical,W_apical,numSeeds,numTotalImages,surfaceRatio,intermediateSurfaceRatios,reductionFactor,initialDiagram,typeProjection,path2save);
    paint3DVoronoiTubes(path2save,numSeeds,colors)
    
    % toc

end