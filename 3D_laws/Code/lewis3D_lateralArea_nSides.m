clear all
%1. Load final segmented glands
pathKindPhenotype = uigetdir(fullfile('E:','Pedro','SalivaryGlands'));
[~,name,~]=fileparts(pathKindPhenotype);
pathGlands = dir(fullfile(pathKindPhenotype,'**','Features_vx4_0.1','morphological3dFeatures.mat'));


kind3DSides=4:10;
meanNormLatAreaPerNsides=nan(size(pathGlands,1),length(kind3DSides));

h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   

for nGland = 1:size(pathGlands,1)

    load(fullfile(pathGlands(nGland).folder,pathGlands(nGland).name),'cellularFeaturesValidCells')
    lateralSides = cellularFeaturesValidCells.Apicobasal_neighbours;  
       
    lateralArea = cellularFeaturesValidCells.Lateral_area;
    maxLatArea = max(lateralArea);
    minLatArea = min(lateralArea);
    
    normalizedLatArea = (lateralArea-minLatArea)/(maxLatArea-minLatArea)+0.5;

    meanNormLatAreaPerNsides(nGland,:)= arrayfun(@(x) mean(normalizedLatArea(ismember(lateralSides,x))),kind3DSides);

    
    plot(kind3DSides,meanNormLatAreaPerNsides,'.k','MarkerSize',20)
    hold on
end

meanOfMeanLatArea3dSides = mean(meanNormLatAreaPerNsides,'omitnan');
nanIds = isnan(meanOfMeanLatArea3dSides);
meanOfMeanLatArea3dSides(nanIds)=[];
kind3DSides(nanIds)=[];
plot(kind3DSides,meanOfMeanLatArea3dSides,'-','LineWidth',2)

title(name)
 
xlabel('kind of 3d polyhedra')
ylabel('lateral area normalized [0.5 - 1.5]')
xlim([min(kind3DSides)-1 max(kind3DSides)+1])
ylim([0.4 1.6])
% save(fullfile(pathGlands(nGland).folder,'..','..','..',['poorGetRicher_' date '.mat']),'kindPolyApical','kindPolyBasal','netGainApicalToBasal','meanNetGainApicalToBasal','netGainBasalToApical','meanNetGainBasalToApical','netIntercalationApicalToBasal','meanNetIntercalationsApicalToBasal','netIntercalationBasalToApical','meanNetIntercalationsBasalToApical');