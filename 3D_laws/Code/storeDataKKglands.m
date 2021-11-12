clear all
close all
%1. Load final segmented glands
pathKindPhenotype = uigetdir(fullfile('E:','Pedro','SalivaryGlands','data'));

pathGlands = dir(fullfile(pathKindPhenotype,'**','layersTissue.mat'));

pathSectionsSRs = dir(fullfile(pathGlands(1).folder,'dividedGlandBySr','*mat'));
nSRsteps = size(pathSectionsSRs,1);

maxSR = 1+0.5*nSRsteps;
sr = 1:0.5:maxSR;

[~,kindGland,~] = fileparts(pathKindPhenotype);

dataNeighsTotal = [];
for nSr = 1:length(sr)
    dataNeighsGlandsPerSr=[];
    for nGland = 1:size(pathGlands,1)        
        if nSr==1
            load(fullfile(pathGlands(nGland).folder,'dividedGlandBySr','Features_vx4_0.1_sr1.5', 'morphological3dFeatures.mat'),'cellularFeaturesValidCells')
            dataNeighsTotal = [dataNeighsTotal;[cellularFeaturesValidCells.ID_Cell(:),cellularFeaturesValidCells.Apical_sides(:),cellularFeaturesValidCells.Apical_area(:)]];
        else
            load(fullfile(pathGlands(nGland).folder,'dividedGlandBySr',['Features_vx4_0.1_sr' num2str(sr(nSr))],'morphological3dFeatures.mat'),'cellularFeaturesValidCells')
            dataNeighsGlandsPerSr = [dataNeighsGlandsPerSr;[cellularFeaturesValidCells.Apicobasal_neighbours(:),cellularFeaturesValidCells.Basal_area(:)]];
        end
    end
    dataNeighsTotal = [dataNeighsTotal,dataNeighsGlandsPerSr];
end

writetable(array2table(dataNeighsTotal),fullfile('D:','Pedro','Epithelia3D','3D_laws','salivaryGlandsData',[kindGland,'_data_Kolmogorov_' date '.xls']))
