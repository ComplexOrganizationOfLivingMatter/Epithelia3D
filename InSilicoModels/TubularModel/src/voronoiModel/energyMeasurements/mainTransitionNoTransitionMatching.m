%main
%we analyse the energy measurements from the expanded cylindrical voronoi
%images

addpath lib
addpath libEnergy

surfaceRatios= [1/0.9 1/0.8 1/0.7 1/0.6 1/0.5 1/0.4 1/0.3 1/0.2 1/0.1];


apicalReductions=[0.1,0.2,0.3,0.4,0.5,0.8];

numSeeds=200;%[50,100,200,400];
numRandoms=20;

typeProjection= 'expansion';

relativePath= ['..\..\..\data\voronoiModel\' typeProjection  '\512x1024_'];

if strcmp(typeProjection,'reduction');
    numSurfaces=length(apicalReductions);
else
    numSurfaces=length(surfaceRatios);
end

for nSeeds=numSeeds
        
    for i=1:numSurfaces
        tableTransitionEnergy=table();
        tableNoTransitionEnergy=table();
        tableTransitionEnergyFiltering200data=table();
        tableNoTransitionEnergyFiltering200data=table();
    
        for nRand=1:numRandoms
            
            if ~isempty(strfind(typeProjection,'expansion'))
                load([relativePath num2str(nSeeds) 'seeds\Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listLOriginalProjection')            
                L_apical=listLOriginalProjection.L_originalProjection{1};
                surfaceRatio=surfaceRatios(i);
                indexImage=10-(1/(surfaceRatio)*10)+1;
                L_basal=listLOriginalProjection.L_originalProjection{indexImage};
                ['surface ratio - expansion: ' num2str(surfaceRatio) ]
                
            else
                load([relativePath num2str(nSeeds) 'seeds\Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listLOriginalApical')            
                L_basal=listLOriginalApical.L_originalApical{end};
                indexImage=10-10*apicalReductions(i);
                surfaceRatio=1/(1-apicalReductions(i));
                L_apical=listLOriginalApical.L_originalApical{indexImage};
                ['surface ratio - reduction: ' num2str(surfaceRatio) ]
            end
            
            ['number of randomization: ' num2str(nRand)]
            
            
            %calculate neighbourings in apical and basal layers
            [neighs_basal,~]=calculateNeighbours(L_basal);
            [neighs_apical,~]=calculateNeighbours(L_apical);

            %no valid cells. No valid in apical or basal
            noValidCells=unique([L_basal(1,:),L_basal(size(L_basal,1),:),L_apical(1,:),L_apical(size(L_apical,1),:)]);

            %get edges of transitions
            transitionEdges=cellfun(@(x,y) setdiff(x,y),neighs_basal,neighs_apical,'UniformOutput',false);
            noTransitionEdges=cellfun(@(x,y) intersect(x,y),neighs_basal,neighs_apical,'UniformOutput',false);

            totalEdges={transitionEdges,noTransitionEdges};
            labelEdges={'transition','noTransition'};
            for k=1:2
                
                %energy in edges (transition and no transition)
                dataEnergy = getEnergyFromEdgesMatchingMotifsBasalApical(L_basal,L_apical,neighs_basal,neighs_apical,noValidCells,totalEdges{k},labelEdges{k});
                dataEnergy.nRand=nRand*ones(size(dataEnergy.basalH1,1),1);
                dataEnergy.numSeeds=nSeeds*ones(size(dataEnergy.basalH1,1),1);
                dataEnergy.surfaceRatio=surfaceRatio*ones(size(dataEnergy.basalH1,1),1);
                
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
            
        end
            
       
        directory2save=['..\..\..\data\voronoiModel\energyMeasurements\' typeProjection '\' num2str(nSeeds) 'seeds\' date '\'];
        mkdir(directory2save);
        
        writetable(tableTransitionEnergy,[directory2save 'transitionEdges_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_' date  '.xls'])
        writetable(tableNoTransitionEnergy,[directory2save 'noTransitionEdges_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_' date '.xls'])
        
        writetable(tableTransitionEnergyFiltering200data,[directory2save 'transitionEdges_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_filter200measurements_' date '.xls'])
        writetable(tableNoTransitionEnergyFiltering200data,[directory2save 'noTransitionEdges_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_filter200measurements_' date '.xls'])
        
        
    end
end