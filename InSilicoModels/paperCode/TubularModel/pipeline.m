addpath(genpath('src'))

%% Defining initial parameters
N_images=20;%total number of different initial images
N_frames=20;%number of Lloyds iterations
H=1024;W=512;%height and width of image
%number of seeds for generation of voronoi cells
n_seeds=[20 50 100 200 400];
distanceBetwSeeds=5;%minimum distances between seeds, avoiding overlaping
%type of surface projections in proportion with the initial image
apicalReductions=1:-0.1:0.1;
basalExpansions= 1./apicalReductions;

%% 1 - Generation of tubular CVT from random seeds
mainTubularCVTGenerator(N_images,N_frames,H,W,n_seeds,distanceBetwSeeds)

%% 2 - Projection of Voronoi seeds to another cylindrical surface and generation of Voronoi cells
%the next main, also carry out the edge length, angles and scutoids
%measurements
mainTubularVoronoiModelProjectionSurface(n_seeds,basalExpansions,apicalReductions,H,W)

%% 3 - Generation of all frusta cylinder (control tubular model) by projection of cell vertices
mainTubularControlModelProjectionSurface(n_seeds,basalExpansions,apicalReductions,N_images,H,W)


%% 4 - Calculation of energies in the developed Voronoi cylider





