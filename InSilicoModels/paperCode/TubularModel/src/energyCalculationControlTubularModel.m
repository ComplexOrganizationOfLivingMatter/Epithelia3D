function energyCalculationControlTubularModel(numSurfaces,relativePathVoronoi,numRandoms,typeProjection,nSeeds,basalExpansions,apicalReductions)
 
            relativePathControl=strrep(relativePathVoronoi,'Voronoi','Control');

            for i=1:numSurfaces
                tableNoTransitionEnergy=table();
                tableNoTransitionEnergyFiltering100data=table();

                for nRand=1:numRandoms
                    
                    directory2load=[relativePathControl num2str(nSeeds) 'seeds\randomization' num2str(nRand) '\'];
                    %loading L_img, frustaModel and indexesBorderVertices
                    load([directory2load  'totalVerticesData.mat'])
                    
                    if ~isempty(strfind(typeProjection,'expansion'))
                         surfaceRatio=basalExpansions(i);
                        disp(['Calculation of energy: number of randomization: ' num2str(nRand) '_ surface ratio - expansion: ' num2str(surfaceRatio) ])
                    else
                        surfaceRatio=1/(1-apicalReductions(i));
                        disp(['Calculation of energy: number of randomization: ' num2str(nRand) '_ surface ratio - reduction: ' num2str(surfaceRatio) ])
                    end

                    %calculate neighbourings in apical layers
                    [neighs,~]=calculateNeighbours(L_img);
                    %no valid cells. No valid in apical or basal
                    noValidCells=unique([L_img(1,:),L_img(size(L_img,1),:)]);
                    borderCells=unique(L_img(:,[1 end]));
                    borderCells=borderCells(borderCells~=0);
                    
                    
                    vertices=frustaTable.vertices([frustaTable.surfaceRatio]==1);
                    verticesProjection=frustaTable.vertices([frustaTable.surfaceRatio]==surfaceRatio);
                    
                    
                    %get vertices in new basal
                    dataEnergy = getEnergyFromEdgesInFrusta( L_img,neighs,noValidCells,vertices,verticesProjection,surfaceRatio,borderCells,arrayValidVerticesBorderLeft,arrayValidVerticesBorderRight);
                    

                    dataEnergy.nRand=nRand*ones(size(dataEnergy.H1,1),1);
                    dataEnergy.numSeeds=nSeeds*ones(size(dataEnergy.H1,1),1);
                    dataEnergy.surfaceRatio=surfaceRatio*ones(size(dataEnergy.H1,1),1);

                    %filtering 5 data for each realization  
                    sumTableEnergy=struct2table(dataEnergy);
                    nanIndex=isnan(sumTableEnergy.H1);
                    sumTableEnergy=sumTableEnergy(~nanIndex,:);
                    pos = randperm(size(sumTableEnergy,1));
                    if length(pos)>=5
                        pos = pos(1:5);
                    end

                    %storing all data and filtered 5 data per realization (IF there are more than 5)
                    tableNoTransitionEnergy=[tableNoTransitionEnergy;sumTableEnergy];
                    tableNoTransitionEnergyFiltering100data=[tableNoTransitionEnergyFiltering100data;sumTableEnergy(pos,:)];


                end
            

                directory2save=['data\tubularControlModel\data\' typeProjection '\' num2str(nSeeds) 'seeds\energy\'];
                mkdir(directory2save);

                writetable(tableNoTransitionEnergy,[directory2save 'allFrustaEnergy_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_' date '.xls'])
                writetable(tableNoTransitionEnergyFiltering100data,[directory2save 'allFrustaEnergy_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_filter100measurements_' date '.xls'])


            end
end
    
        

