%main
%we analyse the energy measurements from the expanded cylindrical voronoi
%images

addpath lib
addpath libEnergy

surfaceRatios= [1/0.9 1/0.8 1/0.7 1/0.6 1/0.5 1/0.4 1/0.3 1/0.2 1/0.1];

numSeeds=200;%[50,100,200,400];
numRandoms=20;


relativePath= '..\..\data\expansion\512x1024_';
numSurfaces=length(surfaceRatios);

for nSeeds=numSeeds
        
    for i=1:numSurfaces
        tableTransitionEnergy=table();
        tableNoTransitionEnergy=table();
        tableTransitionEnergyFiltering200data=table();
        tableNoTransitionEnergyFiltering200data=table();
    
        for nRand=1:numRandoms
            
                load([relativePath num2str(nSeeds) 'seeds\Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listLOriginalProjection')            
                L_apical=listLOriginalProjection.L_originalProjection{1};
                surfaceRatio=surfaceRatios(i);
                
                
            ['surface ratio - expansion: ' num2str(surfaceRatio) ]
                
            
            
            ['number of randomization: ' num2str(nRand)]
            
            
            %calculate neighbourings in apical layers
            [neighs_apical,~]=calculateNeighbours(L_apical);
            %no valid cells. No valid in apical or basal
            noValidCells=unique([L_apical(1,:),L_apical(size(L_apical,1),:)]);
            
            %get vertices apical
            [verticesApical]=calculateVertices(L_apical,neighs_apical);

            %get vertices in new basal
            verticesBasal.verticesPerCel=cellfun(@(x) [x(1,1),round(x(1,2)*surfaceRatio)],verticesApical.verticesPerCell,'UniformOutput',false);
            verticesBasal.verticesConnectCells=verticesApical.verticesConnectCells;

            %get edges of transitions               
            %energy in edges (transition and no transition)
            dataEnergy = getEnergyFromEdges( L_apical,neighs_apical,noValidCells,verticesApical,verticesBasal,surfaceRatio);
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
            tableNoTransitionEnergy=[tableNoTransitionEnergy;sumTableEnergy];
            tableNoTransitionEnergyFiltering200data=[tableNoTransitionEnergyFiltering200data;sumTableEnergy(pos,:)];
            
                                            
        end
            
       
        directory2save=['..\..\data\vertexModel\energyMeasurements\expansion\' num2str(nSeeds) 'seeds\' date '\'];
        mkdir(directory2save);
        
        writetable(tableNoTransitionEnergy,[directory2save 'noTransitionEdges_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_' date '.xls'])
        writetable(tableNoTransitionEnergyFiltering200data,[directory2save 'noTransitionEdges_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_filter200measurements_' date '.xls'])
        
        
    end
end