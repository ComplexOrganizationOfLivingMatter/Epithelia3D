%main
%we analyse the energy measurements from the expanded cylindrical voronoi
%images

addpath lib
addpath libEnergy

surfaceExpansion= [1/0.6, 1/0.2];
numSeeds=[50,100,200,400];
numRandoms=20;
relativePath= '..\..\data\expansion\512x1024_';

for nSeeds=numSeeds
        
    tableTransitionEnergy=table();
    tableNoTransitionEnergy=table();
    
    for i=1:length(surfaceExpansion)
    
        for nRand=1:numRandoms
            
            load([relativePath num2str(nSeeds) 'seeds\Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listLOriginalProjection')            
            L_apical=listLOriginalProjection.L_originalProjection{1};
            
            indexImage=(listLOriginalProjection.surfaceRatio(:)'==surfaceExpansion(i));
            L_basal=listLOriginalProjection.L_originalProjection{indexImage};
            
            
            
            %calculate neighbourings in apical and basal layers
            [neighs_basal,~]=calculateNeighbours(L_basal);
            [neighs_apical,~]=calculateNeighbours(L_apical);

            %no valid cells. No valid in apical or basal
            noValidCells=unique([L_basal(1,:),L_basal(size(L_basal,1),:),L_apical(1,:),L_apical(size(L_apical,1),:)]);

            %get edges of transitions
            transitionEdges=cellfun(@(x,y) setdiff(x,y),neighs_basal,neighs_apical,'UniformOutput',false);
            noTransitionEdges=cellfun(@(x,y) intersect(x,y),neighs_basal,neighs_apical,'UniformOutput',false);

            %energy in transition edges
            dataEnergyTransition = getEnergyFromEdges(L_basal,L_apical,neighs_basal,neighs_apical,noValidCells,transitionEdges,'transition');
            dataEnergyTransition.nRand=nRand*ones(size(dataEnergyTransition.basalH1,1),1);
            dataEnergyTransition.numSeeds=nSeeds*ones(size(dataEnergyTransition.basalH1,1),1);
            dataEnergyTransition.surfaceRatio=surfaceExpansion(i)*ones(size(dataEnergyTransition.basalH1,1),1);
            
            tableTransitionEnergy=[tableTransitionEnergy;struct2table(dataEnergyTransition)];
            
            %energy in no transition edges
            dataEnergyNoTransition = getEnergyFromEdges(L_basal,L_apical,neighs_basal,neighs_apical,noValidCells,noTransitionEdges,'noTransition');
            dataEnergyNoTransition.nRand=nRand*ones(size(dataEnergyNoTransition.basalH1,1),1);
            dataEnergyNoTransition.numSeeds=nSeeds*ones(size(dataEnergyNoTransition.basalH1,1),1);
            dataEnergyNoTransition.surfaceRatio=surfaceExpansion(i)*ones(size(dataEnergyNoTransition.basalH1,1),1);
            
            tableNoTransitionEnergy=[tableNoTransitionEnergy;struct2table(dataEnergyNoTransition)];
            
        end

    end
    
end