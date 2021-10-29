clear all
close all
%1. Load final segmented glands
pathKindPhenotype = uigetdir();

pathGlands = dir(fullfile(pathKindPhenotype,'**','layersTissue.mat'));
sr = 1:0.5:5.5;

kindGland = strsplit(pathKindPhenotype,{'\','/'});

dataNeighsTotal = [];
for nSr = 1:length(sr)
    dataNeighsGlandsPerSr=[];
    for nGland = 1:size(pathGlands,1)        
        if nSr==1
            load(fullfile(pathGlands(nGland).folder,'dividedGlandBySr','Features_vx4_0.1_sr1.5', 'morphological3dFeatures.mat'),'cellularFeaturesValidCells')
            dataNeighsTotal = [dataNeighsTotal;[cellularFeaturesValidCells.ID_Cell(:),cellularFeaturesValidCells.Apical_sides(:),cellularFeaturesValidCells.Apical_area(:)]];
        else
            load(fullfile(pathGlands(nGland).folder,'dividedGlandBySr',['Features_vx4_0.1_sr' num2str(sr(nSr))],'morphological3dFeatures.mat'),'cellularFeaturesValidCells')
            dataNeighsGlandsPerSr = [dataNeighsGlandsPerSr;[cellularFeaturesValidCells.Lateral_sides(:),cellularFeaturesValidCells.Basal_area(:)]];
        end
    end
    dataNeighsTotal = [dataNeighsTotal,dataNeighsGlandsPerSr];
end

writetable(array2table(dataNeighsTotal),fullfile('D:\Pedro\Epithelia3D\3D_laws\salivaryGlandsData',[kindGland{end},'_data_Kolmogorov_' date '.xls']))
