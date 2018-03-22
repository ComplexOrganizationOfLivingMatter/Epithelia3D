

addpath(genpath('src'))
addpath(genpath('lib'))

filePathVoronoiStage8='results\Stage 8\';
filePathVoronoiStage4='results\Stage 4\';
filePathGlobe='results\Globe\';
filePathRugby='results\Rugby\';

filePaths={filePathVoronoiStage8,filePathVoronoiStage4,filePathGlobe,filePathRugby};
for nPath=1:length(filePaths)
    
    switch nPath
        case 1
            numRandoms=30;
            nCellHeight=1;
        case 2
            numRandoms=180;
            nCellHeight=1;
        otherwise
            numRandoms=10;
            nCellHeight=3;
    end
    
    for cellHeight=1:nCellHeight
        
        %initializing parameters to store the data of scutoids, angle and
        %lenth edges
        totalProportionScutoids=zeros(numRandoms,1);
        totalProportionWinNeigh=zeros(numRandoms,1);
        totalProportionLossNeigh=zeros(numRandoms,1);
        totalProportionOfCellsInNoTransitions=zeros(numRandoms,1);
        proportionAnglesTransition=zeros(numRandoms,6);
        proportionAnglesNoTransition=zeros(numRandoms,6);
        totalAnglesTransition=cell(numRandoms);
        totalAnglesNoTransition=cell(numRandoms);
        totalLengthTransition=cell(numRandoms);
        totalLengthNoTransition=cell(numRandoms);
        distributionWinningNeigh=zeros(numRandoms,11);
        distributionLossingNeigh=zeros(numRandoms,11);
        distributionTransitionsPerCell=zeros(numRandoms,11);
        
        for nRand=1:numRandoms           
            ellipsoidPath=dir([filePaths{nPath} 'random_' num2str(nRand) '\*llipsoid*' ]);
            splittedPath=strsplit(ellipsoidPath(cellHeight).name,'_');
            splittedCellHeight=splittedPath{end};
            if nCellHeight>1
                load([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections_' splittedCellHeight],'projectionsInnerWater','projectionsOuterWater')
            else
                load([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections.mat'],'projectionsInnerWater','projectionsOuterWater')
            end
            %loading mask central cells in projection
            maskRoiInner=1-im2bw(imread([filePaths{nPath} 'maskInner.tif']));
            neighsInner=cell(length(projectionsInnerWater),1);
            noValidCells=cell(length(projectionsInnerWater),1);
            neighsOuter=cell(length(projectionsInnerWater),1);
            validCells=cell(length(projectionsInnerWater),1);
            projectionsOuter=cell(length(projectionsInnerWater),1);
            nCells=zeros(length(projectionsInnerWater),1);
            for i=1:length(projectionsInnerWater)                
                [~,projectionsOuter{i},neighsOuter{i},neighsInner{i},noValidCells{i},validCells{i},~,~]= checkingParametersFromRoi(maskRoiInner,projectionsInnerWater{i},projectionsOuterWater{i});
                nCells(i)=size(neighsOuter{i},2);               
            end
            cellNeighsOuter=cell(4,max(nCells));
            cellNeighsInner=cell(4,max(nCells));
            for i=1:length(projectionsInnerWater)  
                cellNeighsOuter(i,1:size(neighsOuter{i},2))=neighsOuter{i};
                cellNeighsInner(i,1:size(neighsInner{i},2))=neighsInner{i};
            end
            globalValidCells=unique(horzcat(validCells{:}));
            globalNeighsOuter=cellfun(@(a,b,c,d) unique([a;b;c;d]),cellNeighsOuter(1,:),cellNeighsOuter(2,:),cellNeighsOuter(3,:),cellNeighsOuter(4,:),'UniformOutput',false);
            globalNeighsInner=cellfun(@(a,b,c,d) unique([a;b;c;d]),cellNeighsInner(1,:),cellNeighsInner(2,:),cellNeighsInner(3,:),cellNeighsInner(4,:),'UniformOutput',false);
            
            %calculate proportions of scutoids
            [totalProportionScutoids(nRand),totalProportionWinNeigh(nRand),totalProportionLossNeigh(nRand),totalProportionOfCellsInNoTransitions(nRand),...
                distributionWinningNeigh(i,:),distributionLossingNeigh(i,:),distributionTransitionsPerCell(i,:)]...
                =calculateNumberOfCellsInvolvedInTransitions(globalNeighsInner,globalNeighsOuter,globalValidCells);
              
            %get all the projections together
            outerOverlaped=horzcat([projectionsOuter{:}]);
            
            %measured angles and length discriminating between transition
            %and no transition
            [dataTransition,dataNoTransition]=measureAnglesAndLengthOfEdges(outerOverlaped,globalNeighsInner,globalNeighsOuter,globalValidCells);
            
            proportionAnglesTransition(nRand,:)=[dataTransition.proportionAnglesLess15deg,dataTransition.proportionAnglesBetween15_30deg,dataTransition.proportionAnglesBetween30_45deg,dataTransition.proportionAnglesBetween45_60deg,dataTransition.proportionAnglesBetween60_75deg,dataTransition.proportionAnglesBetween75_90deg];
            proportionAnglesNoTransition(nRand,:)=[dataNoTransition.proportionAnglesLess15deg,dataNoTransition.proportionAnglesBetween15_30deg,dataNoTransition.proportionAnglesBetween30_45deg,dataNoTransition.proportionAnglesBetween45_60deg,dataNoTransition.proportionAnglesBetween60_75deg,dataNoTransition.proportionAnglesBetween75_90deg];
            totalAnglesTransition{nRand}=dataTransition.edgeAngle;
            totalAnglesNoTransition{nRand}=dataNoTransition.edgeAngle;
            totalLengthTransition{nRand}=dataTransition.edgeLength;
            totalLengthNoTransition{nRand}=dataNoTransition.edgeLength;
        end
        
        %storage of scutoids and chenge of neighs
        meanNumberOfTransitionsPerCell=mean(distributionTransitionsPerCell);
        stdNumberOfTransitionsPerCell=std(distributionTransitionsPerCell);
        meanNumberOfWinningNeighPerCell=mean(distributionWinningNeigh);
        stdNumberOfWinningNeighPerCell=std(distributionWinningNeigh);
        meanNumberOfLossingNeighPerCell=mean(distributionLossingNeigh);
        stdNumberOfLossingNeighPerCell=std(distributionLossingNeigh);
        meanProportionScutoids=mean(totalProportionScutoids);
        stdProportionScutoids=std(totalProportionScutoids);
        meanProportionCellsNoScutoids=mean(totalProportionOfCellsInNoTransitions);
        stdProportionCellsNoScutoids=std(totalProportionOfCellsInNoTransitions);
        meanProportionWinningNeighs=mean(totalProportionWinNeigh);
        stdProportionWinningNeighs=std(totalProportionWinNeigh);
        meanProportionLossingNeighs=mean(totalProportionLossNeigh);
        stdProportionLossingNeighs=std(totalProportionLossNeigh);
               
        %storing angles and length
        meanProportionAnglesTransition=mean(proportionAnglesTransition);
        stdProportionAnglesTransition=std(proportionAnglesTransition);
        meanProportionAnglesNoTransition=mean(proportionAnglesNoTransition);
        stdProportionAnglesNoTransition=std(proportionAnglesNoTransition);
        totalAnglesTransition=vertcat(totalAnglesTransition{:});
        totalAnglesNoTransition=vertcat(totalAnglesNoTransition{:});
        totalLengthTransition=vertcat(totalLengthTransition{:});
        totalLengthNoTransition=vertcat(totalLengthNoTransition{:});
        

        %organizing data in tables
        labelProportions={'firstfifteenDegrees','secondfifteenDegrees','thirdfifteenDegrees','fourthfifteenDegrees','fifthfifteenDegrees','sixthfifteenDegrees'};
        namesRows={'meanAnglesTransition','stdAnglesTransition','meanAnglesNoTransition','stdAnglesNoTransition'};
        tableProportionOfAngles=array2table([meanProportionAnglesTransition;stdProportionAnglesTransition;meanProportionAnglesNoTransition;stdProportionAnglesNoTransition],'VariableNames',labelProportions,'RowNames',namesRows);
        
        labelProportions={'zero','one','two','three','four','five','six','seven','eight','nine','ten'};
        namesRows={'meanTransitionsPerCell','stdTransitionsPerCell','meanWinningPerCell','stdWinningPerCell','meanLossingPerCell','stdLossingPerCell'};
        tableProportionOfPresencesPerCell=array2table([meanNumberOfTransitionsPerCell;stdNumberOfTransitionsPerCell;meanNumberOfWinningNeighPerCell;stdNumberOfWinningNeighPerCell;meanNumberOfLossingNeighPerCell;stdNumberOfLossingNeighPerCell],'VariableNames',labelProportions,'RowNames',namesRows);
       	
        labelColumns={'mean','standardDeviation'};
        namesRows={'scutoidsProportion','frustaProportion','winningNeighboursProportion','lossingNeighboursProportion'};
        tableProportionScutoids=array2table([meanProportionScutoids,stdProportionScutoids;meanProportionCellsNoScutoids,stdProportionCellsNoScutoids;meanProportionWinningNeighs,stdProportionWinningNeighs;meanProportionLossingNeighs,stdProportionLossingNeighs],'VariableNames',labelColumns,'RowNames',namesRows);

        
        if nCellHeight>1
            save([filePaths{nPath} 'dataAngleLengthEdges_' splittedCellHeight],'totalAnglesTransition','totalAnglesNoTransition','totalLengthTransition','totalLengthNoTransition','tableProportionOfAngles')
            writetable(tableProportionOfAngles,[filePaths{nPath} 'tableDistributionAngleEdges_' splittedCellHeight(1:end-4) '_' date '.xls'],'WriteRowNames',true);
            writetable(tableProportionOfPresencesPerCell,[filePaths{nPath} 'tableNumberOfTransitionsWinningLossing_' splittedCellHeight(1:end-4) '_' date '.xls'],'WriteRowNames',true);
            writetable(tableProportionScutoids,[filePaths{nPath} 'tableScutoidsProportions_' splittedCellHeight(1:end-4) '_' date '.xls'],'WriteRowNames',true)
        else
            save([filePaths{nPath} 'dataAngleLengthEdges.mat'],'totalAnglesTransition','totalAnglesNoTransition','totalLengthTransition','totalLengthNoTransition','tableProportionOfAngles')
            writetable(tableProportionOfAngles,[filePaths{nPath} 'tableDistributionAngleEdges_' date '.xls'],'WriteRowNames',true);
            writetable(tableProportionOfPresencesPerCell,[filePaths{nPath} 'tableNumberOfTransitionsWinningLossing_' date '.xls'],'WriteRowNames',true);
            writetable(tableProportionScutoids,[filePaths{nPath} 'tableScutoidsProportions_' date '.xls'],'WriteRowNames',true)
        end
        
        

        
    end
    
end