function energyCalculationVoronoiTubularModel(directory2save,nameOfFolder,numSurfaces,numRandoms,typeProjection,nSeeds,basalExpansions,apicalReductions)

        


    for i=1:numSurfaces
        tableNoTransitionEnergy=table();
        tableNoTransitionEnergyFiltering100data=table();
        tableTransitionEnergy=table();
        tableTransitionEnergyFiltering100data=table();
        tableEnergyAllMotifs=table();
        

        for nRand=1:numRandoms
            
            name2load=['Image_' num2str(nRand) '_Diagram_5'];
            load([directory2save typeProjection '\' nameOfFolder name2load '\'  name2load '.mat'],'listLOriginalProjection')
            
            
            if ~isempty(strfind(typeProjection,'expansion'))
                L_apical=listLOriginalProjection.L_originalProjection{listLOriginalProjection.surfaceRatio==1};
                surfaceRatio=basalExpansions(i);
                L_basal=listLOriginalProjection.L_originalProjection{listLOriginalProjection.surfaceRatio==surfaceRatio};
                ['Measuring Energy in voronoi tubular model: surface ratio(expansion) ' num2str(surfaceRatio) ' random ' num2str(nRand) ]
                
            else
                L_basal=listLOriginalApical.L_originalApical{listLOriginalProjection.surfaceRatio==1};
                surfaceRatio=1/(1-apicalReductions(i));
                L_apical=listLOriginalApical.L_originalApical{listLOriginalProjection.surfaceRatio==surfaceRatio};
                ['Measuring Energy in voronoi tubular model: surface ratio(reduction)' num2str(surfaceRatio)  ' random ' num2str(nRand) ]
            end
            
            neighsBasal=calculateNeighbours(L_basal);
            neighsApical=calculateNeighbours(L_apical);
            verticesBasal=calculateVertices(L_basal,neighsBasal);
            verticesApical=calculateVertices(L_apical,neighsApical);
                        
            %it is necessary testing the vertices and cells at borders, for next steps
            [borderCellsBasal,arrayValidVerticesBorderLeftBasal,arrayValidVerticesBorderRightBasal]=checkingVerticesAndCellsInBorders(L_basal,verticesBasal);
            [borderCellsApical,arrayValidVerticesBorderLeftApical,arrayValidVerticesBorderRightApical]=checkingVerticesAndCellsInBorders(L_apical,verticesApical);

            %no valid cells. No valid in apical or basal
            noValidCells=unique([L_basal(1,:),L_basal(size(L_basal,1),:),L_apical(1,:),L_apical(size(L_apical,1),:)]);
            
            %get edges of transitions
            pairsTransition=cellfun(@(x,y) setdiff(x,y),neighsBasal,neighsApical,'UniformOutput',false);
            pairsNoTransition=cellfun(@(x,y) intersect(x,y),neighsBasal,neighsApical,'UniformOutput',false);          
            totalPairsBasal=cellfun(@(x, y) [y*ones(length(x),1),x],neighsBasal',num2cell(1:size(neighsBasal,2))','UniformOutput',false);
            totalPairsBasal=unique(vertcat(totalPairsBasal{:}),'rows');
            totalPairsBasal=unique([min(totalPairsBasal,[],2),max(totalPairsBasal,[],2)],'rows');   
            
            totalEdgesBasal={pairsTransition;pairsNoTransition};
            nTransitions=vertcat(pairsTransition{:});
            
            labelEdges={'transition','noTransition'};
            for k=1:2
                %% Matching motifs energy both surfaces
                if k == 1 && isempty(nTransitions)
                    disp(['No transitions found: surface ratio' num2str(surfaceRatio) ' random ' num2str(nRand)])
                else
                    %Calculate the energy data for matching motifs between apical and basal layers.
                    dataEnergyMatchingMotifs = getEnergyFromEdgesMatchingMotifsBasalApical(L_basal,L_apical,neighsBasal,neighsApical,noValidCells,totalEdgesBasal{k},labelEdges{k},borderCellsBasal,arrayValidVerticesBorderLeftBasal,arrayValidVerticesBorderRightBasal,borderCellsApical,arrayValidVerticesBorderLeftApical,arrayValidVerticesBorderRightApical);

                    %energy in edges (transition and no transition)
                    if ~isempty(dataEnergyMatchingMotifs.basalH1)
                        dataEnergyMatchingMotifs.nRand=nRand*ones(size(dataEnergyMatchingMotifs.basalH1,1),1);
                        dataEnergyMatchingMotifs.numSeeds=nSeeds*ones(size(dataEnergyMatchingMotifs.basalH1,1),1);
                        dataEnergyMatchingMotifs.surfaceRatio=surfaceRatio*ones(size(dataEnergyMatchingMotifs.basalH1,1),1);
                        
                        %filtering 5 data for each realization  
                        sumTableEnergyMatchingMotifs=struct2table(dataEnergyMatchingMotifs);
                        nanIndex=(isnan(sumTableEnergyMatchingMotifs.apicalH1) |  isnan(sumTableEnergyMatchingMotifs.basalH1));
                        sumTableEnergyMatchingMotifs=sumTableEnergyMatchingMotifs(~nanIndex,:);
                        pos = randperm(size(sumTableEnergyMatchingMotifs,1));
                        if length(pos)>=5
                            pos = pos(1:5);
                        end

                        %storing all data and filtered 5 data per realization (IF there are more than 5)
                        if strcmp(labelEdges{k},'transition');
                            tableTransitionEnergy=[tableTransitionEnergy;sumTableEnergyMatchingMotifs];
                            tableTransitionEnergyFiltering100data=[tableTransitionEnergyFiltering100data;sumTableEnergyMatchingMotifs(pos,:)];
                        else
                            tableNoTransitionEnergy=[tableNoTransitionEnergy;sumTableEnergyMatchingMotifs];
                            tableNoTransitionEnergyFiltering100data=[tableNoTransitionEnergyFiltering100data;sumTableEnergyMatchingMotifs(pos,:)];
                        end
                        
                    else
                        dataEnergyMatchingMotifs.nRand=nRand;
                        dataEnergyMatchingMotifs.numSeeds=nSeeds;
                        dataEnergyMatchingMotifs.surfaceRatio=surfaceRatio;
                    end

                    
                
                end
                %% All motifs energy in basal, without taking into account if the motifs match between basal and apical...
                if k == 1
                    dataEnergyAllMotifs = getEnergyFromAllMotifs(L_basal,noValidCells,totalPairsBasal,verticesBasal,borderCellsBasal,arrayValidVerticesBorderLeftBasal,arrayValidVerticesBorderRightBasal);
                
                    dataEnergyAllMotifs.nRand=nRand*ones(size(dataEnergyAllMotifs.H1,1),1);
                    dataEnergyAllMotifs.numSeeds=nSeeds*ones(size(dataEnergyAllMotifs.H1,1),1);
                    dataEnergyAllMotifs.surfaceRatio=surfaceRatio*ones(size(dataEnergyAllMotifs.H1,1),1);

                    sumTableEnergyAllMotifs=struct2table(dataEnergyAllMotifs);
                    nanIndex=(isnan(sumTableEnergyAllMotifs.H1));
                    sumTableEnergyAllMotifs=sumTableEnergyAllMotifs(~nanIndex,:);

                    tableEnergyAllMotifs=[tableEnergyAllMotifs;sumTableEnergyAllMotifs];
                end
            end
            
        end
            
       
        
        energyDirectory=[directory2save typeProjection '\' nameOfFolder 'energy\'];

        mkdir(energyDirectory);
        
        writetable(tableTransitionEnergy,[energyDirectory 'transitionsMatching_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_' date  '.xls'])
        writetable(tableNoTransitionEnergy,[energyDirectory 'noTransitionEdgesMatching_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_' date '.xls'])
        writetable(tableTransitionEnergyFiltering100data,[energyDirectory 'transitionEdgesMatching_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_filter100measurements_' date '.xls'])
        writetable(tableNoTransitionEnergyFiltering100data,[energyDirectory 'noTransitionEdgesMatching_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_filter100measurements_' date '.xls'])
        writetable(tableEnergyAllMotifs,[energyDirectory 'allMotifsEnergy_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_' date '.xls'])
        
                
    end


end