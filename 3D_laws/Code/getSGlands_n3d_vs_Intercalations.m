clear all
close all
%1. Load final segmented glands
pathKindPhenotype = uigetdir(fullfile('E:','Pedro','SalivaryGlands','data'));

pathGlands = dir(fullfile(pathKindPhenotype,'**','layersTissue.mat'));

pathSectionsSRs = dir(fullfile(pathGlands(1).folder,'dividedGlandBySr','*mat'));
nSRsteps = size(pathSectionsSRs,1);

maxSR = 1+0.5*nSRsteps;
sr = 1:0.5:maxSR;

nOfSrs = length(sr);

%Init arrays to store data
tableMeanIntercalations = zeros(size(pathGlands,1),nOfSrs);
tableMeanN3D = zeros(size(pathGlands,1),nOfSrs);
%%get kind of gland
[~,kindGland,~] = fileparts(pathKindPhenotype);


for nGland = 1:size(pathGlands,1) 
        for nSr = 1:nOfSrs 

            if nSr==1
                features = load(fullfile(pathGlands(nGland).folder,'dividedGlandBySr',['Features_vx4_0.1_sr' num2str(sr(2))],'morphological3dFeatures.mat'),'cellularFeaturesValidCells');
                cellularFeaturesValidCells = features.cellularFeaturesValidCells;
                meanIntercalations = 0;
                n3d = mean(cellularFeaturesValidCells.Apical_sides);

            else
                features = load(fullfile(pathGlands(nGland).folder,'dividedGlandBySr',['Features_vx4_0.1_sr' num2str(sr(nSr))],'morphological3dFeatures.mat'),'cellularFeaturesValidCells');
                cellularFeaturesValidCells = features.cellularFeaturesValidCells;               

                %% Get average intercalations
                meanIntercalations = mean(cellularFeaturesValidCells.apicoBasalTransitions);
                n3d = mean(cellularFeaturesValidCells.Apicobasal_neighbours);
            end


            tableMeanIntercalations(nGland,nSr) = meanIntercalations;
            tableMeanN3D(nGland,nSr)=n3d;
            
        end
end
save(fullfile('..','salivaryGlandsData', [kindGland '_intercalationsN3d_' date '.mat']),'tableMeanIntercalations','tableMeanN3D')