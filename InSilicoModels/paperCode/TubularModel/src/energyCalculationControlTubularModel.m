function energyCalculationControlTubularModel(numSurfaces,relativePathVoronoi,numRandoms,typeProjection,nSeeds,basalExpansions,apicalReductions)
 
            relativePathControl=strrep(relativePathVoronoi,'Voronoi','Control');
            %number of samples of energy measurements per image, getting a final random
            %file of 100 measurements.
            nOfSamples=5;
            
            for nSurf=1:numSurfaces
                tableEnergy=table();
                tableEnergyFiltering100data=table();
                tableEnergyFilterByAngle=table();
                tableEnergyFiltering100dataFilterByAngle=table();

                for nRand=1:numRandoms
                    
                    directory2load=[relativePathControl num2str(nSeeds) 'seeds\randomization' num2str(nRand) '\'];
                    %loading L_img, frustaModel and indexesBorderVertices
                    load([directory2load  'totalVerticesData.mat'])
                    
                    if ~isempty(strfind(typeProjection,'expansion'))
                         surfaceRatio=basalExpansions(nSurf);
                        disp(['Calculation of energy: number of randomization: ' num2str(nRand) '_ surface ratio - expansion: ' num2str(surfaceRatio) ])
                    else
                        surfaceRatio=1/(1-apicalReductions(nSurf));
                        disp(['Calculation of energy: number of randomization: ' num2str(nRand) '_ surface ratio - reduction: ' num2str(surfaceRatio) ])
                    end

                    %calculate neighbourings in apical layers
                    [neighs,~]=calculateNeighbours(L_img);
                    %no valid cells. No valid in apical or basal
                    noValidCells=unique([L_img(1,:),L_img(size(L_img,1),:)]);
                    borderCells=unique(L_img(:,[1 end]));
                    borderCells=borderCells(borderCells~=0);
                    
                    
                    verticesProjection=frustaTable.vertices([frustaTable.surfaceRatio]==surfaceRatio);
                    
                    
                    %get vertices in new basal
                    [dataEnergy,dataEnergyFilterByAngle] = getEnergyFromEdgesInFrusta( L_img,neighs,noValidCells,verticesProjection,surfaceRatio,borderCells,arrayValidVerticesBorderLeft,arrayValidVerticesBorderRight);
                    
                    
                    dataEnergy.nRand=nRand*ones(size(dataEnergy.H1,1),1);
                    dataEnergy.numSeeds=nSeeds*ones(size(dataEnergy.H1,1),1);
                    dataEnergy.surfaceRatio=surfaceRatio*ones(size(dataEnergy.H1,1),1);
                    %filtering 5 data for each realization  
                    sumTableEnergy=struct2table(dataEnergy);
                    nanIndex=isnan(sumTableEnergy.H1);
                    sumTableEnergy=sumTableEnergy(~nanIndex,:);
                    pos = randperm(size(sumTableEnergy,1));
                    if length(pos)>=nOfSamples
                        pos = pos(1:nOfSamples);
                    end
                    %storing all data and filtered 5 data per realization (IF there are more than 5)
                    tableEnergy=[tableEnergy;sumTableEnergy];
                    tableEnergyFiltering100data=[tableEnergyFiltering100data;sumTableEnergy(pos,:)];
                    
                    
                    %QUANTIFY measurements with angle treshold
                    dataEnergyFilterByAngle.nRand=nRand*ones(size(dataEnergyFilterByAngle.H1,1),1);
                    dataEnergyFilterByAngle.numSeeds=nSeeds*ones(size(dataEnergyFilterByAngle.H1,1),1);
                    dataEnergyFilterByAngle.surfaceRatio=surfaceRatio*ones(size(dataEnergyFilterByAngle.H1,1),1);
                    %filtering 5 data for each realization  
                    sumTableEnergyFilterByAngle=struct2table(dataEnergyFilterByAngle);
                    nanIndex=isnan(sumTableEnergyFilterByAngle.H1);
                    sumTableEnergyFilterByAngle=sumTableEnergyFilterByAngle(~nanIndex,:);
                    pos = randperm(size(sumTableEnergyFilterByAngle,1));
                    if length(pos)>=nOfSamples
                        pos = pos(1:nOfSamples);
                    end
                    %storing all data and filtered 5 data per realization (IF there are more than 5)
                    tableEnergyFilterByAngle=[tableEnergyFilterByAngle;sumTableEnergyFilterByAngle];
                    tableEnergyFiltering100dataFilterByAngle=[tableEnergyFiltering100dataFilterByAngle;sumTableEnergyFilterByAngle(pos,:)];


                end
            

                directory2save=['data\tubularControlModel\' typeProjection '\' num2str(nSeeds) 'seeds\energy\'];
                mkdir(directory2save);

                writetable(tableEnergy,[directory2save 'allFrustaEnergy_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_' date '.xls'])
                writetable(tableEnergyFiltering100data,[directory2save 'allFrustaEnergy_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_filtered_' date '.xls'])

                writetable(tableEnergyFilterByAngle,[directory2save 'allFrustaEnergy_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_AngleTreshold_' date '.xls'])
                writetable(tableEnergyFiltering100dataFilterByAngle,[directory2save 'allFrustaEnergy_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_filtered_AngleTreshold_' date '.xls'])


            end
end
    
        

