
% clear all
close all

addpath(genpath('..\voronoiEllipsoidModel\src'))
addpath (genpath('..\voronoiEllipsoidModel\lib'))
addpath(genpath('src'));

filePathFrustaStage8='results\Stage 8\';
filePathFrustaStage4='results\Stage 4\';
filePathVoronoiStage8='..\voronoiEllipsoidModel\results\Stage 8\';
filePathVoronoiStage4='..\voronoiEllipsoidModel\results\Stage 4\';

filePaths={filePathFrustaStage4,filePathFrustaStage8};
    
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
        tableNoTransitionEnergyTotalNonPreservedMotifs=table();
        tableTransitionEnergy = table();
        tableTransitionEnergyNonPreservedMotifs = table();

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
            maskRoiInner=1-im2bw(imread([filePaths{nPath} 'maskInner.tif']));
            for i=1:length(projectionsInnerWater)

                %function for getting inner roi, edges, neighbours and valid cells
                [innerRoiProjection,neighsOuter,neighsInner,noValidCells,validCells,totalEdges,labelEdges]= checkingParametersFromRoi(maskRoiInner,projectionsInnerWater{i},projectionsOuterWater{i});

                % Calculate energy if there is any transition
                for j=1:2
                    if ~isempty(totalEdges{j});

                        [dataEnergy,dataEnergyOuterNonPreservedMotifs,numberOfValidMotifs] = getEnergyFromEdges( projectionsOuterWater{i},innerRoiProjection,neighsOuter,neighsInner,noValidCells,validCells,totalEdges{j},labelEdges{j});

                        if ~isempty(dataEnergy)

                            if strcmp(labelEdges{j},'transition')
                                numberOfValidMotifsTransition=numberOfValidMotifs;
                            end

                            dataEnergy.nRand=nRand*ones(size(dataEnergy.outerH1,1),1);
                            dataEnergyOuterNonPreservedMotifs.nRand=nRand*ones(size(dataEnergyOuterNonPreservedMotifs.outerH1,1),1);
                            %filtering no transition data for each transition 
                            
                            %preserved motifs
                            sumTableEnergy=struct2table(dataEnergy);
                            nanIndex=(isnan(sumTableEnergy.innerH1) |  isnan(sumTableEnergy.outerH1));
                            sumTableEnergy=sumTableEnergy(~nanIndex,:);
                            %nonpreserved motifs
                            sumTableEnergyNonPreservedMotifs=struct2table(dataEnergyOuterNonPreservedMotifs);
                            nanIndexNonPreservedMotifs=(isnan(sumTableEnergyNonPreservedMotifs.outerH1));
                            sumTableEnergyNonPreservedMotifs=sumTableEnergyNonPreservedMotifs(~nanIndexNonPreservedMotifs,:);

                            if strcmp(labelEdges{j},'transition')
                                tableTransitionEnergy=[tableTransitionEnergy;sumTableEnergy];
                                tableTransitionEnergyNonPreservedMotifs=[tableTransitionEnergyNonPreservedMotifs;sumTableEnergyNonPreservedMotifs];
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
                                tableNoTransitionEnergyTotalNonPreservedMotifs=[tableNoTransitionEnergyTotalNonPreservedMotifs;sumTableEnergyNonPreservedMotifs];
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
            writetable(tableNoTransitionEnergyTotalNonPreservedMotifs,[filePaths{nPath} 'energy\energyNoTransitionEdgesNonPreservedMotifs_' splittedCellHeight(1:end-4) '_' date '.xls'])
            writetable(tableTransitionEnergyNonPreservedMotifs,[filePaths{nPath} 'energy\energyTransitionEdgesNonPreservedMotifs_' splittedCellHeight(1:end-4) '_' date '.xls'])

         else
            writetable(tableTransitionEnergy,[filePaths{nPath} 'energy\energyTransitionEdges_' date '.xls'])
            writetable(tableNoTransitionEnergyTotal,[filePaths{nPath} 'energy\energyNoTransitionEdges_' date '.xls'])
            writetable(tableNoTransitionEnergyFilterRandom,[filePaths{nPath} 'energy\energyNoTransitionEdgesFilter_' date '.xls'])
            %non preserved motifs between apical and basal
            writetable(tableTransitionEnergyNonPreservedMotifs,[filePaths{nPath} 'energy\energyTransitionEdgesNonPreservedMotifs_' date '.xls'])
            writetable(tableNoTransitionEnergyTotalNonPreservedMotifs,[filePaths{nPath} 'energy\energyNoTransitionEdgesNonPreservedMotifs_' date '.xls'])
         end
    

    end

 

end
    
    

    
    
    
