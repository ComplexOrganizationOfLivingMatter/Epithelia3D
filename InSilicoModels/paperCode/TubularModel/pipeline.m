addpath(genpath('src'))

%% Defining initial parameters
N_images=20;%total number of different initial images
N_frames=20;%number of Lloyds iterations
H=4096;W=512;%height and width of image
%number of seeds for generation of voronoi cells
distanceBetwSeeds=5;%minimum distances between seeds, avoiding overlaping
%type of surface projections in proportion with the initial image

%the edge shared between 2 cells should have as minimum this distance to be
%analize as frusta or scutoids.
thresholdPixelsScutoid=4;

apicalReductions=1:-0.1:0.1;
% setOfSeeds=[10 20 50 100 200]*4;
setOfSeeds=[80 200 400];

% setOfSeeds=60;
% basalExpansions=[1 20/3];
basalExpansions= 1./apicalReductions;
apicalReductions=[];

    
for i=1:length(setOfSeeds)
        
        n_seeds=setOfSeeds(i);

%          try 
            % 1 - Generation of tubular CVT from random seeds
%           mainTubularCVTGenerator(N_images,N_frames,H,W,n_seeds,distanceBetwSeeds)

            %% 2 - Projection of Voronoi seeds to another cylindrical surface and generation of Voronoi cells
            %the next main, also carry out the measurements of edge length, edge angles and scutoids
            %presence
            mainTubularVoronoiModelProjectionSurface(n_seeds,basalExpansions,apicalReductions,N_images,H,W,thresholdPixelsScutoid)

            %% 3 - Generation of all frusta cylinder (control tubular model) by projection of cell vertices
%            mainTubularControlModelProjectionSurface(n_seeds,basalExpansions,apicalReductions,N_images,H,W)

%         catch ME
%             disp(['error in number of seeds: ' num2str(n_seeds)])
%             disp(ME.stack(1).name)
%             disp(ME.stack(1).line)
% 
%         end


end




