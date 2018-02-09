
clear all
close all

addpath('src\measureEnergy')
addpath lib
addpath ('lib\energy')

filePathStage8='results\Stage 8\';
filePathStage4='results\Stage 4\';
filePathSphere='results\Sphere\';

filePaths={filePathStage8,filePathStage4,filePathSphere};
    

numRandoms=10;

tableTransitionEnergy=table();
tableNoTransitionEnergyFilterRandom=table();
tableNoTransitionEnergyTotal=table();

for nPath=1:length(filePaths)
    for nRand=2:numRandoms
        
        ellipsoidPath=dir([filePaths{nPath} 'random_' num2str(nRand) '\ellipsoid*' ]);
        load([filePaths{nPath} 'random_' num2str(nRand) '\' ellipsoidPath.name],'ellipsoidInfo','initialEllipsoid','tableDataAnglesTransitionsEdgesOuter','tableDataAnglesNoTransitionsEdgesOuter')
        
        %getting 4 projections from 3d ellipsoid
        [projectionsInner,projectionsOuter,projectionsInnerWater,projectionsOuterWater]=zProjectionEllipsoid( ellipsoidInfo.img3DLayer,initialEllipsoid.img3DLayer);
        
        %loading mask central cells in projection
        maskRoi=1-im2bw(imread([filePaths{nPath} 'mask.tif']));

        
        for i=1:length(projectionsInner)

            % Calculation valid cells
            outerRoiProjection=maskRoi(1:size(projectionsOuterWater{i},1),1:size(projectionsOuterWater{i},2)).*projectionsOuterWater{i};
            innerRoiProjection=maskRoi(1:size(projectionsOuterWater{i},1),1:size(projectionsOuterWater{i},2)).*projectionsInnerWater{i};
            noValidCellsOuter=unique(imdilate((1-maskRoi(1:size(projectionsOuterWater{i},1),1:size(projectionsOuterWater{i},2))),[1 1;1 1]).*outerRoiProjection);
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
                    dataEnergy = getEnergyFromEdges( outerRoiProjection,innerRoiProjection,neighsOuter,neighsInner,noValidCellsOuter,totalEdges{j},labelEdges{j});
                    dataEnergy.nRand=nRand*ones(size(dataEnergy.outerH1,1),1);

                    %filtering no transition data for each transition  
                    sumTableEnergy=struct2table(dataEnergy);
                    nanIndex=(isnan(sumTableEnergy.innerH1) |  isnan(sumTableEnergy.outerH1));
                    sumTableEnergy=sumTableEnergy(~nanIndex,:);


                    if strcmp(labelEdges{j},'transition');
                        tableTransitionEnergy=[tableTransitionEnergy;sumTableEnergy];
                    else
                        if ~isempty(totalEdges{1})
                            %same number of no transitions than transitions
                            pos = randperm(size(sumTableEnergy,1));
                            pos = pos(1:size(pairTransitions,1));
                            tableNoTransitionEnergyFilterRandom=[tableNoTransitionEnergyFilterRandom;sumTableEnergy(pos,:)];
                        end
                        tableNoTransitionEnergyTotal=[tableNoTransitionEnergyTotal;sumTableEnergy];
                    end                 

                end
            end
        end
    
        ['randomization ' num2str(nRand)]
    
    end
    
    
    directory2save=['results\energyMeasurements\' typeProjection '\' num2str(nSeeds) 'seeds\'];
    mkdir(directory2save);

    writetable(tableTransitionEnergy,[filePaths{nPath} 'transitionEdges_' date '.xls'])
    writetable(tableNoTransitionEnergyTotal,[filePaths{nPath} 'noTransitionEdges_' date '.xls'])

    writetable(tableNoTransitionEnergyFilterRandom,[filePaths{nPath} 'noTransitionEdgesFilter_' date '.xls'])



    
    
    
end