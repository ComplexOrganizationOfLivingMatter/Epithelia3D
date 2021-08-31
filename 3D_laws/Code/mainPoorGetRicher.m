
%1. Load final segmented glands
pathKindPhenotype = uigetdir();
pathGlands = dir(fullfile(pathKindPhenotype,'**','Features_vx4_0.1','morphological3dFeatures.mat'));

apicalSidesAccum=[];
basalSidesAccum=[];
lateralSidesAccum=[];
for nGland = 1:size(pathGlands,1)

    load(fullfile(pathGlands(nGland).folder,pathGlands(nGland).name),'cellularFeaturesValidCells')
    
    apicalSidesAccum = [apicalSidesAccum;cellularFeaturesValidCells.Apical_sides];
    basalSidesAccum = [basalSidesAccum;cellularFeaturesValidCells.Basal_sides];
    lateralSidesAccum = [lateralSidesAccum;cellularFeaturesValidCells.Lateral_sides];  
    
end

kindPolyApical=unique(apicalSidesAccum);
kindPolyBasal=unique(basalSidesAccum);

netGainApicalToBasal = arrayfun(@(x) lateralSidesAccum(ismember(apicalSidesAccum,x))-x,kindPolyApical,'UniformOutput',false);
meanNetGainApicalToBasal = cellfun(@mean, netGainApicalToBasal);
netGainBasalToApical = arrayfun(@(x) lateralSidesAccum(ismember(basalSidesAccum,x))-x,kindPolyBasal,'UniformOutput',false);
meanNetGainBasalToApical = cellfun(@mean, netGainBasalToApical);

save(fullfile(pathGlands(nGland).folder,'poorGetRicher.mat'),'kindPolyApical','kindPolyBasal','netGainApicalToBasal','meanNetGainApicalToBasal','netGainBasalToApical','meanNetGainBasalToApical');