clear all
close all

addpath(genpath('src'))

%% Defining initial parameters
N_images=20;%total number of different initial images
N_CVT_frames=20;%number of Lloyds iterations
H=4096;W=512;%height and width of image
%number of seeds for generation of voronoi cells
distanceBetwSeeds=5;%minimum distances between seeds, avoiding overlaping
%type of surface projections in proportion with the initial image

%the edge shared between 2 cells should have as minimum this distance to be
%analize as frusta or scutoids.
thresholdPixelsScutoid=4;

%The paper (G�mez-G�lvez et al. 2018) didn't explore deeply the 'reduction', only was analysed in a
%preliminar case. So if you decide execute the reduction alternative, 
%you should give value to the variable below. (maybe you should review 
%possible code bugs for this alternative, but our first intention is that
%this code work with accuracy)
setOfSeeds=200;
apicalReductions=[];
basalExpansions = 1:0.25:10;
initialVoronoiDiagramNumber = 8;


%if your RAM memory is quite high (96 gb or more), you could execute this loop with a parfor    
for i=1:length(setOfSeeds) 
        
        n_seeds=setOfSeeds(i);

         try 
            %% 1 - Generation of tubular CVT from random seeds
            mainTubularCVTGenerator(N_images,N_CVT_frames,H,W,n_seeds,distanceBetwSeeds)

            %% 2 - Projection of Voronoi seeds to another cylindrical surface and generation of Voronoi cells
            %the next main, also carry out the measurements of edge length, edge angles and scutoids
            %presence
            mainTubularVoronoiModelProjectionSurface(n_seeds,basalExpansions,apicalReductions,N_images,H,W,thresholdPixelsScutoid,initialVoronoiDiagramNumber)

            %% 3- Control model (all frusta) and its line-tension energy
%             mainTubularControlModelProjectionSurface(n_seeds,basalExpansions,apicalReductions,N_images,H,W)
            
            
        catch ME
            disp(['error in number of seeds: ' num2str(n_seeds)])
            for j =length(ME.stack):-1:1
                disp([ME.stack(j).name, ' - ' num2str(ME.stack(j).line)])
            end
        end


end




