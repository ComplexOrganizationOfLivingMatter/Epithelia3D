function energyCalculationVoronoiTubularModel(directory2save,nameOfFolder,numSurfaces,numRandoms,typeProjection,nSeeds,basalExpansions,apicalReductions,diagramNumber)
%ENERGYCALCULATIONVORONOITUBULARMODEL calculate all the parameters
%neccesary for the line-tension minimization model in different tables:
% TableTransitionEnergy: all motifs with transitions
% TableNoTransitionEnergy: all motifs with no transitions       
% TableTransitionEnergy100filter: 100 samples of TableTransitionEnergy
% TableNoTransitionEnergy100filter: 100 samples of TableNoTransitionEnergy
% TableAllMotifs:all motifs without discriminate between transition or not
% and another set applying a filter depending of the angle in H and W. 
% Angle threshold H ~ (0-30º) and W ~ (60-90º)

%THIS PROGRAM CAN PROVIDE YOU SOME OUTLAYERS DUE TO FAKE EDGES BECAUSE THE
%UNION OF TWO VERTICES IN DIFFERENT EXTREMES OF THE UNFOLDED CYLINDER. The
%number of outlayer is minimum (0.5% of motifs aproximately). This motifs
%should be deleted by hand
    for nSurf=1:numSurfaces
        tableNoTransitionEnergy=table();
        tableNoTransitionEnergyFiltering100data=table();
        tableTransitionEnergy=table();
        tableTransitionEnergyFiltering100data=table();
        tableEnergyAllMotifs=table();
%         tableNoTransitionEnergyFilterByAngle=table();
%         tableNoTransitionEnergyFiltering100dataFilterByAngle=table();
%         tableTransitionEnergyFilterByAngle=table();
%         tableTransitionEnergyFiltering100dataFilterByAngle=table();
%         tableEnergyAllMotifsFilterByAngle=table();

        for nRand=1:numRandoms
            
            name2load=['Image_' num2str(nRand) '_Diagram_' num2str(diagramNumber)];
            load([directory2save typeProjection '\' nameOfFolder name2load '\'  name2load '.mat'],'listLOriginalProjection')
            
            
            if ~isempty(strfind(typeProjection,'expansion'))
                L_apical=listLOriginalProjection.L_originalProjection{listLOriginalProjection.surfaceRatio==1};
                surfaceRatio=basalExpansions(nSurf);
                L_basal=listLOriginalProjection.L_originalProjection{round(listLOriginalProjection.surfaceRatio,1)==round(surfaceRatio,1)};
                disp(['Measuring Energy in voronoi tubular model: surface ratio(expansion) ' num2str(surfaceRatio) ' number of seeds ' num2str(nSeeds) ' random ' num2str(nRand) ])
                
            else
                L_basal=listLOriginalProjection.L_originalProjection{listLOriginalProjection.surfaceRatio==1};
                surfaceRatio=apicalReductions(nSurf);
                L_apical=listLOriginalProjection.L_originalProjection{round(listLOriginalProjection.surfaceRatio,1)==round(surfaceRatio,1)};
                disp(['Measuring Energy in voronoi tubular model: surface ratio(reduction)' num2str(surfaceRatio)  ' number of seeds ' num2str(nSeeds) ' random ' num2str(nRand) ])
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
            
            totalPairsApical=cellfun(@(x, y) [y*ones(length(x),1),x],neighsApical',num2cell(1:size(neighsApical,2))','UniformOutput',false);
            totalPairsApical=unique(vertcat(totalPairsApical{:}),'rows');
            totalPairsApical=unique([min(totalPairsApical,[],2),max(totalPairsApical,[],2)],'rows');   
            
            totalEdgesBasal={pairsTransition;pairsNoTransition};
            nTransitions=vertcat(pairsTransition{:});
            
            labelEdges={'transition','noTransition'};
            for nLab=1:2
                %% Matching motifs energy both surfaces
                if nLab == 1 && isempty(nTransitions)
                    disp(['No transitions found: surface ratio' num2str(surfaceRatio) ' number of seeds ' num2str(nSeeds) ' random ' num2str(nRand)])
                else
                    %Calculate the energy data for matching motifs between apical and basal layers.
                    dataEnergyMatchingMotifs = getEnergyFromEdgesMatchingMotifsBasalApical(L_basal,L_apical,neighsBasal,neighsApical,noValidCells,totalEdgesBasal{nLab},labelEdges{nLab},borderCellsBasal,arrayValidVerticesBorderLeftBasal,arrayValidVerticesBorderRightBasal,borderCellsApical,arrayValidVerticesBorderLeftApical,arrayValidVerticesBorderRightApical);
%                     dataEnergyMatchingMotifsFilterByAngle = getEnergyFromEdgesMatchingMotifsBasalApicalFilteringByAngle(L_basal,L_apical,neighsBasal,neighsApical,noValidCells,totalEdgesBasal{nLab},labelEdges{nLab},borderCellsBasal,arrayValidVerticesBorderLeftBasal,arrayValidVerticesBorderRightBasal,borderCellsApical,arrayValidVerticesBorderLeftApical,arrayValidVerticesBorderRightApical);
                    
                    %Acum and filter energy in edges (transition and no transition)
                    [tableTransitionEnergy,tableTransitionEnergyFiltering100data,tableNoTransitionEnergy,tableNoTransitionEnergyFiltering100data ] = acumAndFilterEnergyData( dataEnergyMatchingMotifs, labelEdges{nLab},tableTransitionEnergy,tableTransitionEnergyFiltering100data,tableNoTransitionEnergy,tableNoTransitionEnergyFiltering100data,nRand,nSeeds,surfaceRatio);
%                     [tableTransitionEnergyFilterByAngle,tableTransitionEnergyFiltering100dataFilterByAngle,tableNoTransitionEnergyFilterByAngle,tableNoTransitionEnergyFiltering100dataFilterByAngle ] = acumAndFilterEnergyData( dataEnergyMatchingMotifsFilterByAngle, labelEdges{nLab},tableTransitionEnergyFilterByAngle,tableTransitionEnergyFiltering100dataFilterByAngle,tableNoTransitionEnergyFilterByAngle,tableNoTransitionEnergyFiltering100dataFilterByAngle,nRand,nSeeds,surfaceRatio);
                
                end
                %% All motifs energy in basal, without taking into account if the motifs match between basal and apical...
                if nLab == 1
                    
                    if surfaceRatio>=1
                        [dataEnergyAllMotifs,~] = getEnergyFromAllMotifs(L_basal,noValidCells,totalPairsBasal,verticesBasal,borderCellsBasal,arrayValidVerticesBorderLeftBasal,arrayValidVerticesBorderRightBasal);
                    else
                        [dataEnergyAllMotifs,~] = getEnergyFromAllMotifs(L_apical,noValidCells,totalPairsApical,verticesApical,borderCellsApical,arrayValidVerticesBorderLeftApical,arrayValidVerticesBorderRightApical);
                    end
                    
                    dataEnergyAllMotifs.nRand=nRand*ones(size(dataEnergyAllMotifs.H1,1),1);
                    dataEnergyAllMotifs.numSeeds=nSeeds*ones(size(dataEnergyAllMotifs.H1,1),1);
                    dataEnergyAllMotifs.surfaceRatio=surfaceRatio*ones(size(dataEnergyAllMotifs.H1,1),1);
                    sumTableEnergyAllMotifs=struct2table(dataEnergyAllMotifs);
                    nanIndex=(isnan(sumTableEnergyAllMotifs.H1));
                    sumTableEnergyAllMotifs=sumTableEnergyAllMotifs(~nanIndex,:);
                    tableEnergyAllMotifs=[tableEnergyAllMotifs;sumTableEnergyAllMotifs];
                    
%                     %angle threshold H ~ (0-30º) and W ~ (60-90º)
%                     dataEnergyAllMotifsFilterByAngle.nRand=nRand*ones(size(dataEnergyAllMotifsFilterByAngle.H1,1),1);
%                     dataEnergyAllMotifsFilterByAngle.numSeeds=nSeeds*ones(size(dataEnergyAllMotifsFilterByAngle.H1,1),1);
%                     dataEnergyAllMotifsFilterByAngle.surfaceRatio=surfaceRatio*ones(size(dataEnergyAllMotifsFilterByAngle.H1,1),1);
%                     sumTableEnergyAllMotifsFilterByAngle=struct2table(dataEnergyAllMotifsFilterByAngle);
%                     nanIndex=(isnan(sumTableEnergyAllMotifsFilterByAngle.H1));
%                     sumTableEnergyAllMotifsFilterByAngle=sumTableEnergyAllMotifsFilterByAngle(~nanIndex,:);
%                     tableEnergyAllMotifsFilterByAngle=[tableEnergyAllMotifsFilterByAngle;sumTableEnergyAllMotifsFilterByAngle];
                end
            end
            
        end
            
       
        %directory to save (be careful with the directory length, an error could appear due to the long filename)
        energyDirectory=[directory2save typeProjection '\' nameOfFolder 'energy\'];
%         energyDirectory=strrep(energyDirectory,directory2save,'C:\Users\USERNAME\Desktop\');
        mkdir(energyDirectory);
        
        %energy measured matching motifs between basal and apical; filtered
        %as a max of 100 measurements and finally a table with all the
        %valid motifs by layer.
        if ~isempty(tableTransitionEnergy)
            writetable(tableTransitionEnergy,[energyDirectory 'voronoiModelEnergy_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_Transitions_' date  '.xls'])
        end
        writetable(tableNoTransitionEnergy,[energyDirectory 'voronoiModelEnergy_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_NoTransitions_' date  '.xls'])
%         writetable(tableTransitionEnergyFiltering100data,[energyDirectory 'voronoiModelEnergy_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_Transitions_filtered_' date '.xls'])
%         writetable(tableNoTransitionEnergyFiltering100data,[energyDirectory 'voronoiModelEnergy_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_NoTransitions_filtered_' date '.xls'])
        writetable(tableEnergyAllMotifs,[energyDirectory 'allMotifsEnergy_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_' date '.xls'])
        
%         %Same order than before, but in this case it were measured the energy in motifs with an angle treshold
%         writetable(tableTransitionEnergyFilterByAngle,[energyDirectory 'voronoiModelEnergy_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_Transitions_AngleThreshold_' date  '.xls'])
%         writetable(tableNoTransitionEnergyFilterByAngle,[energyDirectory 'voronoiModelEnergy_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_NoTransitions_AngleThreshold_' date  '.xls'])
%         writetable(tableTransitionEnergyFiltering100dataFilterByAngle,[energyDirectory 'voronoiModelEnergy_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_Transitions_filtered_AngleThreshold_' date '.xls'])
%         writetable(tableNoTransitionEnergyFiltering100dataFilterByAngle,[energyDirectory 'voronoiModelEnergy_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_NoTransitions_filtered_AngleThreshold_' date '.xls'])
%         writetable(tableEnergyAllMotifsFilterByAngle,[energyDirectory 'allMotifsEnergy_' num2str(nSeeds) 'seeds_surfaceRatio' num2str(surfaceRatio) '_AngleThreshold_' date '.xls'])
        
                
    end


end