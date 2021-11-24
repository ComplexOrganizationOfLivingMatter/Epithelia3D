clear all

addpath(genpath('lib'))
%1. Load final segmented glands
pathKindPhenotype = uigetdir(fullfile('E:','Pedro','SalivaryGlands'));
pathGlands = dir(fullfile(pathKindPhenotype,'**','Features_vx4_0.1','morphological3dFeatures.mat'));

apicalSidesAccum=[];
basalSidesAccum=[];
lateralSidesAccum=[];
apicoBasalTransitionsAccum=[];
polyDist = zeros(size(pathGlands,1),8);
for nGland = 1:size(pathGlands,1)

    load(fullfile(pathGlands(nGland).folder,pathGlands(nGland).name))%,'cellularFeaturesValidCells')
    
    apicalSidesAccum = [apicalSidesAccum;cellularFeaturesValidCells.Apical_sides];
    basalSidesAccum = [basalSidesAccum;cellularFeaturesValidCells.Basal_sides];
    lateralSidesAccum = [lateralSidesAccum;cellularFeaturesValidCells.Apicobasal_neighbours];  
    
    cellPolDist = calculatePolygonDistribution(lateralSidesAccum,1:length(lateralSidesAccum));
    polyDist(nGland,:)=horzcat(cellPolDist{2,:});
    apicoBasalTransitionsAccum = [apicoBasalTransitionsAccum;cellularFeaturesValidCells.apicoBasalTransitions];
end

meanPolDist3d = mean(polyDist);
stdPolDist3d = std(polyDist);

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

path2save=fullfile('D:','Pedro','Epithelia3D','3D_laws','salivaryGlandsData','heatMaps');
poorGetRicherWithBalls(path2save,netGainApicalToBasal{kindPolyApical==4},netGainApicalToBasal{kindPolyApical==5},netGainApicalToBasal{kindPolyApical==6},netGainApicalToBasal{kindPolyApical==7},netGainApicalToBasal{kindPolyApical==8})

save(fullfile(pathGlands(nGland).folder,'..','..','..',['poorGetRicher_' date '.mat']),'kindPolyApical','kindPolyBasal','meanPolDist3d','stdPolDist3d','netGainApicalToBasal','meanNetGainApicalToBasal','netGainBasalToApical','meanNetGainBasalToApical','netIntercalationApicalToBasal','meanNetIntercalationsApicalToBasal','netIntercalationBasalToApical','meanNetIntercalationsBasalToApical');