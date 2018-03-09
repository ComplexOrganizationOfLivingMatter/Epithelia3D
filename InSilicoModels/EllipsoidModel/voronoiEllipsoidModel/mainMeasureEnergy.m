
% clear all
close all

addpath('src\measureEnergy')
addpath lib
addpath ('lib\energy')

filePathVoronoiStage8='results\Stage 8\';
filePathVoronoiStage4='results\Stage 4\';
filePathFrustaStage8='..\frustaEllipsoidModel\results\Stage 8\';
filePathFrustaStage4='..\frustaEllipsoidModel\results\Stage 4\';
filePathSphere='results\Sphere\';
filePathGlobe='results\Globe\';
filePathRugby='results\Rugby\';

filePaths={filePathVoronoiStage8,filePathVoronoiStage4,filePathFrustaStage8,filePathFrustaStage4,filePathGlobe,filePathRugby,filePathSphere};
    
for nPath=4%1:length(filePaths)
    
    
    
    if nPath==1 || nPath==3
       numRandoms=30;
       nCellHeight=1;
    else if nPath==2 || nPath==4
       numRandoms=180; 
       nCellHeight=1;
        else
            numRandoms=10;
            nCellHeight=10;
        end
    end
  
            
    for cellHeight=1:nCellHeight

        tableTransitionEnergy=table();
        tableTransitionEnergyNonPreservedMotifs=table();
        tableNoTransitionEnergyFilterRandom=table();
        tableNoTransitionEnergyTotal=table();
        tableNoTransitionEnergyTotalNonPreservedMotifs=table();
        

        for nRand=1:numRandoms

            try
            ellipsoidPath=dir([filePaths{nPath} 'random_' num2str(nRand) '\*llipsoid*' ]);
            %if projectins are just created...load, else run the
            %zProjections program

            splittedPath=strsplit(ellipsoidPath(cellHeight).name,'_');
            splittedCellHeight=splittedPath{end};

            if exist([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections.mat'],'file') || exist([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections_' splittedCellHeight],'file')
                if nCellHeight>1
                    load([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections_' splittedCellHeight],'projectionsInnerWater','projectionsOuterWater')
                else
                    load([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections.mat'],'projectionsInnerWater','projectionsOuterWater')
                end
            else
                
                if nPath==3 || nPath==4
                    load([filePaths{nPath} 'random_' num2str(nRand) '\' ellipsoidPath(cellHeight).name],'allFrustaImage')
                    ellipsoidPath=dir([strrep(filePaths{nPath},'..\frustaEllipsoidModel\','') 'random_' num2str(nRand) '\*llipsoid*' ]);
                    load([strrep(filePaths{nPath},'..\frustaEllipsoidModel\','') 'random_' num2str(nRand) '\' ellipsoidPath(cellHeight).name],'initialEllipsoid','ellipsoidInfo')
                    ellipsoidInfo.img3DLayer=allFrustaImage;

                else
                    load([filePaths{nPath} 'random_' num2str(nRand) '\' ellipsoidPath(cellHeight).name],'ellipsoidInfo','initialEllipsoid')
                end
                    
                %getting 4 projections from 3d ellipsoid
                [projectionsInner,projectionsOuter,projectionsInnerWater,projectionsOuterWater]=zProjectionEllipsoid( ellipsoidInfo,initialEllipsoid);
                if nCellHeight>1
                    save([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections_' splittedCellHeight],'projectionsInnerWater','projectionsOuterWater')
                else
                    save([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections.mat'],'projectionsInnerWater','projectionsOuterWater')
                end

            end

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


            catch
                  ['randomization ERROR:' num2str(nRand) '  -  ' filePaths{nPath} '-' splittedCellHeight(1:end-4)]

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
    
    

    
    
    
