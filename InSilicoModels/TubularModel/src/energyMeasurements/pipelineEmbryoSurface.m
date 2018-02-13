%main
%we analyse the energy measurements from the expanded cylindrical voronoi
%images

addpath lib
addpath libEnergy

inputDir = 'D:\Pablo\Epithelia3D\Gastrulation\Embryo_Sol\results\NoFolds\';

get

% INITIAL = APICAL
% END = BASAL

trackingInfoOnlyValid = trackingInfo(logical(trackingInfo.validCell), :);

%calculate neighbourings in apical and basal layers
neighs_basal = trackingInfo.neighboursEnd';
neighs_apical = trackingInfo.neighboursInitial';

%no valid cells. No valid in apical or basal
noValidCells = find(trackingInfo.validCell);

L_basal = imgEndNewLabels;
L_apical = imgInitialNewLabels;

%get edges of transitions
transitionEdges=cellfun(@(x,y) setdiff(x,y),neighs_basal,neighs_apical,'UniformOutput',false);
noTransitionEdges=cellfun(@(x,y) intersect(x,y),neighs_basal,neighs_apical,'UniformOutput',false);

totalEdges={transitionEdges,noTransitionEdges};
labelEdges={'transition','noTransition'};

tableTransitionEnergy=table();
tableNoTransitionEnergy=table();
tableTransitionEnergyFiltering200data=table();
tableNoTransitionEnergyFiltering200data=table();

for k=1:2
    
    %energy in edges (transition and no transition)
    dataEnergy = getEnergyFromEdges(L_basal,L_apical,neighs_basal,neighs_apical,noValidCells,totalEdges{k},labelEdges{k});
    %dataEnergy.nRand=nRand*ones(size(dataEnergy.basalH1,1),1);
    %dataEnergy.numSeeds=nSeeds*ones(size(dataEnergy.basalH1,1),1);
    %dataEnergy.surfaceRatio=surfaceRatio*ones(size(dataEnergy.basalH1,1),1);
    
    %filtering 10 data for each realization
    sumTableEnergy=struct2table(dataEnergy);
    nanIndex=(isnan(sumTableEnergy.apicalH1) |  isnan(sumTableEnergy.basalH1));
    sumTableEnergy=sumTableEnergy(~nanIndex,:);
    pos = randperm(size(sumTableEnergy,1));
    if length(pos)>=10
        pos = pos(1:10);
    end
    
    %storing all data and filtered 10 data per realization (IF there are more than 10)
    if strcmp(labelEdges{k},'transition');
        tableTransitionEnergy=[tableTransitionEnergy;sumTableEnergy];
        tableTransitionEnergyFiltering200data=[tableTransitionEnergyFiltering200data;sumTableEnergy(pos,:)];
    else
        tableNoTransitionEnergy=[tableNoTransitionEnergy;sumTableEnergy];
        tableNoTransitionEnergyFiltering200data=[tableNoTransitionEnergyFiltering200data;sumTableEnergy(pos,:)];
    end
    
end


directory2save=['..\..\data\energyMeasurements\' typeProjection '\' num2str(nSeeds) 'seeds\' date '\'];
mkdir(directory2save);

writetable(tableTransitionEnergy,[directory2save 'transitionEdges_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_' date  '.xls'])
writetable(tableNoTransitionEnergy,[directory2save 'noTransitionEdges_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_' date '.xls'])

writetable(tableTransitionEnergyFiltering200data,[directory2save 'transitionEdges_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_filter200measurements_' date '.xls'])
writetable(tableNoTransitionEnergyFiltering200data,[directory2save 'noTransitionEdges_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_filter200measurements_' date '.xls'])
