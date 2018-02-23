
% clear all
% close all

addpath('src\measureEnergy')
addpath lib
addpath ('lib\energy')

filePathStage8='results\Stage 8\';
filePathStage4='results\Stage 4\';
filePathSphere='results\Sphere\';

filePaths={filePathStage8,filePathStage4,filePathSphere};
    





for nPath=1:length(filePaths)
    
    tableTransitionEnergy=table();
    tableNoTransitionEnergyFilterRandom=table();
    tableNoTransitionEnergyTotal=table();
    
    if nPath==1
       numRandoms=30;
    else
       numRandoms=180; 
    end
    
    for nRand=1:numRandoms
         try
            
            ellipsoidPath=dir([filePaths{nPath} 'random_' num2str(nRand) '\ellipsoid*' ]);
            load([filePaths{nPath} 'random_' num2str(nRand) '\' ellipsoidPath.name],'ellipsoidInfo','initialEllipsoid','tableDataAnglesTransitionsEdgesOuter','tableDataAnglesNoTransitionsEdgesOuter')


%             if exist([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections.mat'],'file')
               load([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections.mat'],'projectionsInnerWater','projectionsOuterWater')
%             else
%                 %getting 4 projections from 3d ellipsoid
%                 [projectionsInner,projectionsOuter,projectionsInnerWater,projectionsOuterWater]=zProjectionEllipsoid( ellipsoidInfo.img3DLayer,initialEllipsoid);
%                 save([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections.mat'],'projectionsInnerWater','projectionsOuterWater')
% 
%             end


            %loading mask central cells in projection
            maskRoi=1-im2bw(imread([filePaths{nPath} 'mask.tif']));


            for i=1:length(projectionsInnerWater)

                % Calculation valid cells
                se=strel('disk',4);
                outerRoiProjection=maskRoi(1:size(projectionsOuterWater{i},1),1:size(projectionsOuterWater{i},2)).*projectionsOuterWater{i};
                innerRoiProjection=maskRoi(1:size(projectionsOuterWater{i},1),1:size(projectionsOuterWater{i},2)).*projectionsInnerWater{i};
                noValidCellsOuter=unique(imdilate((1-maskRoi(1:size(projectionsOuterWater{i},1),1:size(projectionsOuterWater{i},2))),se).*outerRoiProjection);
                validCellsOuter=setdiff(unique(outerRoiProjection),noValidCellsOuter);
                noValidCellsInner=setdiff(unique(innerRoiProjection),validCellsOuter);


                % Calculation neighbours
                [neighsOuter,~]=calculateNeighbours(outerRoiProjection);
                [neighsInner,~]=calculateNeighbours(innerRoiProjection);

                % Getting edges transition and no transition
                pairTransitions=tableDataAnglesTransitionsEdgesOuter.TotalRegion.cellularMotifs;
                pairNoTransitions=tableDataAnglesNoTransitionsEdgesOuter.TotalRegion.cellularMotifs;

                pairTransitions=pairTransitions(sum(ismember(pairTransitions,validCellsOuter),2)==2,:);
                pairNoTransitions=pairNoTransitions(sum(ismember(pairNoTransitions,validCellsOuter),2)==2,:);


                totalEdges={pairTransitions,pairNoTransitions};
                labelEdges={'transition','noTransition'};

                % Calculate energy if there is any transition
                for j=1:2
                    if ~isempty(totalEdges{j});

                        [dataEnergy,numberOfValidMotifs] = getEnergyFromEdges( outerRoiProjection,innerRoiProjection,neighsOuter,neighsInner,noValidCellsOuter,totalEdges{j},labelEdges{j});

                        if ~isempty(dataEnergy)
                            
                            if strcmp(labelEdges{j},'transition')
                                numberOfValidMotifsTransition=numberOfValidMotifs;
                            end

                            dataEnergy.nRand=nRand*ones(size(dataEnergy.outerH1,1),1);
                            %filtering no transition data for each transition  
                            sumTableEnergy=struct2table(dataEnergy);
                            nanIndex=(isnan(sumTableEnergy.innerH1) |  isnan(sumTableEnergy.outerH1));
                            sumTableEnergy=sumTableEnergy(~nanIndex,:);

                            if strcmp(labelEdges{j},'transition')
                                tableTransitionEnergy=[tableTransitionEnergy;sumTableEnergy];
                            else
                                if ~isempty(totalEdges{1}) && ~isempty(sumTableEnergy) && ~isempty(sumTableEnergy) && numberOfValidMotifsTransition>0
                                    %same number of no transitions than transitions
                                    pos = randperm(size(sumTableEnergy,1));
                                    pos = pos(1:numberOfValidMotifsTransition);
                                    tableNoTransitionEnergyFilterRandom=[tableNoTransitionEnergyFilterRandom;sumTableEnergy(pos,:)];
                                end
                                tableNoTransitionEnergyTotal=[tableNoTransitionEnergyTotal;sumTableEnergy];
                            end 

                        else
                            if strcmp(labelEdges{j},'transition')
                                totalEdges{1}=[];
                            end
                        end

                    end
                end
            end

            ['randomization ' num2str(nRand)]
        
        catch
            ['randomization ERROR:' num2str(nRand)]
        end
        
    
    end
    
    
    writetable(tableTransitionEnergy,[filePaths{nPath} 'energy\energyTransitionEdges_' date '.xls'])
    writetable(tableNoTransitionEnergyTotal,[filePaths{nPath} 'energy\energyNoTransitionEdges_' date '.xls'])

    writetable(tableNoTransitionEnergyFilterRandom,[filePaths{nPath} 'energy\energyNoTransitionEdgesFilter_' date '.xls'])



    
    
    
end