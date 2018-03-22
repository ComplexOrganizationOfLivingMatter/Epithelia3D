
% clear all
close all

addpath(genpath('..\voronoiEllipsoidModel\src'))
addpath (genpath('..\voronoiEllipsoidModel\lib'))
addpath(genpath('src'));

filePathFrustaStage8='results\Stage 8\';
filePathFrustaStage4='results\Stage 4\';
filePathVoronoiStage8='..\voronoiEllipsoidModel\results\Stage 8\';
filePathVoronoiStage4='..\voronoiEllipsoidModel\results\Stage 4\';

filePathFrustaGlobe = 'results\Globe\';
filePathFrustaRugby = 'results\Rugby\';
filePathVoronoiGlobe = '..\voronoiEllipsoidModel\results\Globe\';
filePathVoronoiRugby = '..\voronoiEllipsoidModel\results\Rugby\';

filePaths={filePathFrustaStage4,filePathFrustaStage8, filePathFrustaGlobe, filePathFrustaRugby};
    
for nPath=1:length(filePaths)
    
    
    
    if nPath==1
       numRandoms=180;
       nCellHeight=1;
    else if nPath==2
       numRandoms=30; 
       nCellHeight=1;
        else
            numRandoms=10;
            nCellHeight=3;
        end
    end
  
            
    for cellHeight=1:nCellHeight
        tableNoTransitionEnergyFilterRandom=table();
        tableNoTransitionEnergyTotal=table();
        tableNoTransitionEnergyTotalNonPreservedMotifsOuter=table();
        tableNoTransitionEnergyTotalNonPreservedMotifsInner=table();
        tableTransitionEnergy = table();
        tableTransitionEnergyNonPreservedMotifsOuter = table();
        tableTransitionEnergyNonPreservedMotifsInner = table();

        for nRand=1:numRandoms
            nRand
            try
            ellipsoidPath=dir([filePaths{nPath} 'random_' num2str(nRand) '\*llipsoid*' ]);
            %if projectins are just created...load, else run the
            %maxProjections program
            splittedPath=strsplit(ellipsoidPath(cellHeight).name,'_');
            splittedCellHeight=splittedPath{end};
            [projectionsInnerWater,projectionsOuterWater,projectionsInnerVertices,projectionsOuterVertices,projectionsCellsConnectedToVertex] = checkMaxProjectionExist(ellipsoidPath,filePaths,nRand,nCellHeight,splittedCellHeight,nPath,cellHeight);
            

            %loading mask central cells in projection
            maskImg = imread([filePaths{nPath} 'maskInner.tif']);
            maskRoiInner=1-logical(maskImg(:, :, 1));
            for i=1:length(projectionsInnerWater)

                %function for getting inner roi, edges, neighbours and valid cells
                [innerRoiProjection,neighsOuter,neighsInner,noValidCells,validCells,totalEdges,labelEdges]= checkingParametersFromRoi(maskRoiInner,projectionsInnerWater{i},projectionsOuterWater{i});
                [~,~,~,noValidCellsInner,validCellsInner,totalEdgesInner,~]= checkingParametersFromRoi(maskRoiInner,projectionsInnerWater{i},projectionsInnerWater{i});
                
                % Calculate energy if there is any transition
                for j=1:2
                    if ~isempty(totalEdges{j});

                        [dataEnergy,dataEnergyOuterNonPreservedMotifs,numberOfValidMotifs] = getEnergyFromEdges( projectionsOuterWater{i},innerRoiProjection,neighsOuter,neighsInner,noValidCells,validCells,totalEdges{j},labelEdges{j});
                        [~,dataEnergyInnerNonPreservedMotifs,numberOfValidMotifsInner] = getEnergyFromEdges( projectionsInnerWater{i},innerRoiProjection,neighsInner,neighsInner,noValidCellsInner,validCellsInner,totalEdgesInner{j},labelEdges{j});
                        
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

            [filePaths{nPath} 'randomization ' num2str(nRand) '  -  ' splittedCellHeight(1:end-4)]


            catch err
                fid = fopen('logFile','a+');
                % write the error to file
                % first line: message
                fprintf(fid,'%s\r\n',['randomization ERROR:' num2str(nRand) '  -  ' filePaths{nPath} '-' splittedCellHeight(1:end-4)]);
                fprintf(fid,'%s\r\n',err.message);
                
                fprintf(fid, '%s', err.getReport('extended', 'hyperlinks','off'));
                
                % close file
                fclose(fid);
            end


        end

        
         mkdir([filePaths{nPath} 'energy\'])
         %saving tables
         if nCellHeight>1
            writetable(tableTransitionEnergy,[filePaths{nPath} 'energy\energyTransitionEdges_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableNoTransitionEnergyTotal,[filePaths{nPath} 'energy\energyNoTransitionEdges_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableNoTransitionEnergyFilterRandom,[filePaths{nPath} 'energy\energyNoTransitionEdgesFilter_' splittedCellHeight(1:end-4) '_' date '.xls'])
            %non preserved motifs between apical and basal
            writetable(tableNoTransitionEnergyTotalNonPreservedMotifsOuter,[filePaths{nPath} 'energy\energyNoTransitionEdgesNonPreservedMotifs_Outer_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableNoTransitionEnergyTotalNonPreservedMotifsInner,[filePaths{nPath} 'energy\energyNoTransitionEdgesNonPreservedMotifs_Inner_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableTransitionEnergyNonPreservedMotifsOuter,[filePaths{nPath} 'energy\energyTransitionEdgesNonPreservedMotifs_Outer_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableTransitionEnergyNonPreservedMotifsInner,[filePaths{nPath} 'energy\energyTransitionEdgesNonPreservedMotifs_Inner_' splittedCellHeight(1:end-4) '_' date '.xls'])

         else
            writetable(tableTransitionEnergy,[filePaths{nPath} 'energy\energyTransitionEdges_' date '.xls'])
            writetable(tableNoTransitionEnergyTotal,[filePaths{nPath} 'energy\energyNoTransitionEdges_' date '.xls'])
            writetable(tableNoTransitionEnergyFilterRandom,[filePaths{nPath} 'energy\energyNoTransitionEdgesFilter_' date '.xls'])
            %non preserved motifs between apical and basal
            writetable(tableNoTransitionEnergyTotalNonPreservedMotifsOuter,[filePaths{nPath} 'energy\energyNoTransitionEdgesNonPreservedMotifs_Outer_' date '.xls'])
            writetable(tableNoTransitionEnergyTotalNonPreservedMotifsInner,[filePaths{nPath} 'energy\energyNoTransitionEdgesNonPreservedMotifs_Inner_' date '.xls'])
            writetable(tableTransitionEnergyNonPreservedMotifsOuter,[filePaths{nPath} 'energy\energyTransitionEdgesNonPreservedMotifs_Outer_' date '.xls'])
            writetable(tableTransitionEnergyNonPreservedMotifsInner,[filePaths{nPath} 'energy\energyTransitionEdgesNonPreservedMotifs_Inner_' date '.xls'])
         end
    

    end

 

end
    
    

    
    
    
