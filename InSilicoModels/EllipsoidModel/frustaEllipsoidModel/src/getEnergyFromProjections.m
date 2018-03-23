function [ tableTransitionEnergy, tableTransitionEnergyNonPreservedMotifsOuter, tableNoTransitionEnergyTotalNonPreservedMotifsInner, tableNoTransitionEnergyFilterRandom] = getEnergyFromProjections( filePaths, nPath, projectionsInnerWater,  projectionsOuterWater,  tableTransitionEnergy, tableTransitionEnergyNonPreservedMotifsOuter, tableNoTransitionEnergyTotalNonPreservedMotifsInner, tableNoTransitionEnergyFilterRandom, nRand, projectionOuterVertices,projectionsCellsConnectedToVertex)
%GETENERGYFROMPROJECTIONS Summary of this function goes here
%   Detailed explanation goes here
%loading mask central cells in projection
    maskImg = imread([filePaths{nPath} 'maskInner.tif']);
    maskRoiInner=1-logical(maskImg(:, :, 1));
    for i=1:length(projectionsInnerWater)
        
        verticesOuter.verticesConnectCells = projectionsCellsConnectedToVertex{i};
        verticesOuter.verticesPerCell = mat2cell(projectionOuterVertices{i},ones(size(projectionOuterVertices{i},1),1),2);

        %function for getting inner roi, edges, neighbours and valid cells
        [innerRoiProjection, outerRoiProjection, neighsOuter,neighsInner,noValidCells,validCells,totalEdges]= checkingParametersFromRoi(maskRoiInner,projectionsInnerWater{i},projectionsOuterWater{i});
        
        totalEdges = {totalEdges{2}};
        labelEdges = {'noTransition'};

        % Calculate energy if there is any transition
        for j=1:length(labelEdges)
            if ~isempty(totalEdges{j});

                [dataEnergy,dataEnergyOuterNonPreservedMotifs,numberOfValidMotifs] = getEnergyFromEdgesAtFrusta(outerRoiProjection,innerRoiProjection,neighsOuter,neighsInner,noValidCells,validCells,totalEdges{j},labelEdges{j}, verticesOuter);
                [~,dataEnergyInnerNonPreservedMotifs,~] = getEnergyFromEdges( innerRoiProjection,innerRoiProjection,neighsInner,neighsInner,noValidCells,validCells,totalEdges{j},labelEdges{j});
                
                if ~isempty(dataEnergy)

                    if strcmp(labelEdges{j},'transition')
                        numberOfValidMotifsTransition=numberOfValidMotifs;
                    end

                    dataEnergy.nRand=nRand*ones(size(dataEnergy.outerH1,1),1);
                    dataEnergyOuterNonPreservedMotifs.nRand=nRand*ones(size(dataEnergyOuterNonPreservedMotifs.outerH1,1),1);
                    dataEnergyInnerNonPreservedMotifs.nRand=nRand*ones(size(dataEnergyInnerNonPreservedMotifs.outerH1,1),1);
                    %filtering no transition data for each transition

                    %preserved motifs
                    sumTableEnergy=struct2table(dataEnergy);
                    nanIndex=(isnan(sumTableEnergy.innerH1) |  isnan(sumTableEnergy.outerH1));
                    sumTableEnergy=sumTableEnergy(~nanIndex,:);
                    %nonpreserved motifs
                    sumTableEnergyNonPreservedMotifsOuter=struct2table(dataEnergyOuterNonPreservedMotifs);
                    sumTableEnergyNonPreservedMotifsInner=struct2table(dataEnergyInnerNonPreservedMotifs);
                    nanIndexNonPreservedMotifsOuter=(isnan(sumTableEnergyNonPreservedMotifsOuter.outerH1));
                    nanIndexNonPreservedMotifsInner=(isnan(sumTableEnergyNonPreservedMotifsInner.outerH1));
                    sumTableEnergyNonPreservedMotifsOuter=sumTableEnergyNonPreservedMotifsOuter(~nanIndexNonPreservedMotifsOuter,:);
                    sumTableEnergyNonPreservedMotifsInner=sumTableEnergyNonPreservedMotifsInner(~nanIndexNonPreservedMotifsInner,:);

                    if strcmp(labelEdges{j},'transition')
                        tableTransitionEnergy=[tableTransitionEnergy;sumTableEnergy];
                        tableTransitionEnergyNonPreservedMotifsOuter=[tableTransitionEnergyNonPreservedMotifsOuter;sumTableEnergyNonPreservedMotifsOuter];
                        tableTransitionEnergyNonPreservedMotifsInner=[tableTransitionEnergyNonPreservedMotifsInner;sumTableEnergyNonPreservedMotifsInner];
                    else
                        if ~isempty(totalEdges{1}) && ~isempty(sumTableEnergy) && ~isempty(sumTableEnergy) && numberOfValidMotifsTransition>0
                            %same number of no transitions than transitions
                            pos = randperm(size(sumTableEnergy,1));
                            if size(sumTableEnergy,1) > numberOfValidMotifsTransition
                                pos = pos(1:numberOfValidMotifsTransition);
                            end
                            tableNoTransitionEnergyFilterRandom=[tableNoTransitionEnergyFilterRandom;sumTableEnergy(pos,:)];
                        end
                        tableNoTransitionEnergyTotal=[tableNoTransitionEnergyTotal;sumTableEnergy];
                        tableNoTransitionEnergyTotalNonPreservedMotifsOuter=[tableNoTransitionEnergyTotalNonPreservedMotifsOuter;sumTableEnergyNonPreservedMotifsOuter];
                        tableNoTransitionEnergyTotalNonPreservedMotifsInner=[tableNoTransitionEnergyTotalNonPreservedMotifsInner;sumTableEnergyNonPreservedMotifsInner];
                    end

                else
                    if strcmp(labelEdges{j},'transition')
                        totalEdges{1}=[];
                    end
                end

            end
        end
    end
end

