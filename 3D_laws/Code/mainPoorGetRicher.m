clear all
%1. Load final segmented glands
pathKindPhenotype = uigetdir(fullfile('E:','Pedro','SalivaryGlands'));
pathGlands = dir(fullfile(pathKindPhenotype,'**','Features_vx4_0.1','morphological3dFeatures.mat'));

apicalSidesAccum=[];
basalSidesAccum=[];
lateralSidesAccum=[];
apicoBasalTransitionsAccum=[];
for nGland = 1:size(pathGlands,1)

    load(fullfile(pathGlands(nGland).folder,pathGlands(nGland).name))%,'cellularFeaturesValidCells')
    
    apicalSidesAccum = [apicalSidesAccum;cellularFeaturesValidCells.Apical_sides];
    basalSidesAccum = [basalSidesAccum;cellularFeaturesValidCells.Basal_sides];
    lateralSidesAccum = [lateralSidesAccum;cellularFeaturesValidCells.Apicobasal_neighbours];  
    apicoBasalTransitionsAccum = [apicoBasalTransitionsAccum;cellularFeaturesValidCells.apicoBasalTransitions];
end

kindPolyApical=unique(apicalSidesAccum);
kindPolyBasal=unique(basalSidesAccum);

netGainApicalToBasal = arrayfun(@(x) lateralSidesAccum(ismember(apicalSidesAccum,x))-x,kindPolyApical,'UniformOutput',false);
netIntercalationApicalToBasal = arrayfun(@(x) apicoBasalTransitionsAccum(ismember(apicalSidesAccum,x)),kindPolyApical,'UniformOutput',false);

meanNetGainApicalToBasal = cellfun(@mean, netGainApicalToBasal);
meanNetIntercalationsApicalToBasal = cellfun(@mean, netIntercalationApicalToBasal);

netGainBasalToApical = arrayfun(@(x) lateralSidesAccum(ismember(basalSidesAccum,x))-x,kindPolyBasal,'UniformOutput',false);
netIntercalationBasalToApical = arrayfun(@(x) apicoBasalTransitionsAccum(ismember(basalSidesAccum,x)),kindPolyBasal,'UniformOutput',false);

meanNetGainBasalToApical = cellfun(@mean, netGainBasalToApical);
meanNetIntercalationsBasalToApical = cellfun(@mean, netIntercalationBasalToApical);

save(fullfile(pathGlands(nGland).folder,'..','..','..',['poorGetRicher_' date '.mat']),'kindPolyApical','kindPolyBasal','netGainApicalToBasal','meanNetGainApicalToBasal','netGainBasalToApical','meanNetGainBasalToApical','netIntercalationApicalToBasal','meanNetIntercalationsApicalToBasal','netIntercalationBasalToApical','meanNetIntercalationsBasalToApical');