%%Generate tubular Voronoi Model for PLANTS.
%%Here we begin with the Voronoi 12 instead of Voronoi 5 due to the polygon
%%distribution of Hypocotyl A - Layer 1 is similar to the cited diagram

N_images=20;
N_frames=20;
H=800;
W=2400;
distanceBetwSeeds=5;%minimum distances between seeds, avoiding overlaping
thresholdPixelsScutoid=4;
setOfSeeds=400;
% apicalReductions=[1, 1/1.15];
apicalReductions=[1, 1/1.33];
basalExpansions=[];
% initialVoronoiDiagramNumber = 5;
initialVoronoiDiagramNumber = 12;

addpath(genpath('D:\Pedro\Epithelia3D\InSilicoModels\TubularModel\src\'))

for i = length(setOfSeeds)
    
    n_seeds=setOfSeeds(i);
    
    %% 1 - Generation of tubular CVT from random seeds
%     mainTubularCVTGenerator(N_images,N_frames,H,W,n_seeds,distanceBetwSeeds)


    %% 2 - Projection of Voronoi seeds to another cylindrical surface and generation of Voronoi cells
    %the next main, also carry out the measurements of edge length, edge angles and scutoids
    %presence
    mainTubularVoronoiModelProjectionSurface(n_seeds,basalExpansions,apicalReductions,N_images,H,W,thresholdPixelsScutoid,initialVoronoiDiagramNumber)


end