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
for nGland = 1:size(pathGlands,1)        
      load(fullfile(pathGlands(nGland).folder,'Features_vx4_0.1', 'morphological3dFeatures.mat'),'cellularFeaturesValidCells')
      dataNeighsTotal = [dataNeighsTotal;[cellularFeaturesValidCells.ID_Cell(:),cellularFeaturesValidCells.Apical_sides(:),cellularFeaturesValidCells.Apical_area(:),cellularFeaturesValidCells.Basal_sides(:),cellularFeaturesValidCells.Basal_area(:)]];

end


writetable(array2table(dataNeighsTotal,'VariableNames',{'Cell_ID','apicalSides','apicalArea','basalSides','basalArea'}),fullfile('D:','Pedro','Epithelia3D','3D_laws','salivaryGlandsData',[kindGland,'_data_KolmogorovApicalBasal_Spreading_' date '.xls']))
