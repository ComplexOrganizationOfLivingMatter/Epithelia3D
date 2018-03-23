

addpath(genpath('src'))
addpath(genpath('lib'))

filePathVoronoiStage8='results\Stage 8\';
filePathVoronoiStage4='results\Stage 4\';
filePathGlobe='results\Globe\';
filePathRugby='results\Rugby\';
filePathSphere='results\Sphere\';

filePaths={filePathVoronoiStage8,filePathVoronoiStage4,filePathGlobe,filePathRugby,filePathSphere};
for nPath=1:length(filePaths)
    
    switch nPath
        case 1
            numRandoms=30;
            nCellHeight=1;
        case 2
            numRandoms=180;
            nCellHeight=1;
        case 5
            numRandoms=3;
            nCellHeight=3;
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
        totalCellsInRois=zeros(numRandoms,1);
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
            
            [totalCellsInRois(nRand),totalProportionScutoids(nRand),totalProportionWinNeigh(nRand),...
                totalProportionLossNeigh(nRand),totalProportionOfCellsInNoTransitions(nRand),...
                distributionWinningNeigh(nRand,:),distributionLossingNeigh(nRand,:),...
                distributionTransitionsPerCell(nRand,:),proportionAnglesTransition(nRand,:),...
                proportionAnglesNoTransition(nRand,:),totalAnglesTransition{nRand},...
                totalAnglesNoTransition{nRand},totalLengthTransition{nRand},totalLengthNoTransition{nRand}]...
                =calculationAngleLengthScutoidsInEdges(filePaths{nPath},nRand,cellHeight,nCellHeight);
           
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
        
        %total cells in ROIs
        meanTotalCellsInRois=mean(totalCellsInRois);
        stdTotalCellsInRois=std(totalCellsInRois);

        %organizing data in tables
        namesColumns={'firstfifteenDegrees','secondfifteenDegrees','thirdfifteenDegrees','fourthfifteenDegrees','fifthfifteenDegrees','sixthfifteenDegrees'};
        namesRows={'meanAnglesTransition','stdAnglesTransition','meanAnglesNoTransition','stdAnglesNoTransition'};
        tableProportionOfAngles=array2table([meanProportionAnglesTransition;stdProportionAnglesTransition;meanProportionAnglesNoTransition;stdProportionAnglesNoTransition],'VariableNames',namesColumns,'RowNames',namesRows);
        
        namesColumns={'zero','one','two','three','four','five','six','seven','eight','nine','ten'};
        namesRows={'meanTransitionsPerCell','stdTransitionsPerCell','meanWinningPerCell','stdWinningPerCell','meanLossingPerCell','stdLossingPerCell'};
        tableProportionOfPresencesPerCell=array2table([meanNumberOfTransitionsPerCell;stdNumberOfTransitionsPerCell;meanNumberOfWinningNeighPerCell;stdNumberOfWinningNeighPerCell;meanNumberOfLossingNeighPerCell;stdNumberOfLossingNeighPerCell],'VariableNames',namesColumns,'RowNames',namesRows);
       	
        namesColumns={'mean','standardDeviation'};
        namesRows={'scutoidsProportion','frustaProportion','winningNeighboursProportion','lossingNeighboursProportion','numberOfCellsInROI'};
        tableProportionScutoids=array2table([meanProportionScutoids,stdProportionScutoids;meanProportionCellsNoScutoids,stdProportionCellsNoScutoids;meanProportionWinningNeighs,stdProportionWinningNeighs;meanProportionLossingNeighs,stdProportionLossingNeighs;meanTotalCellsInRois,stdTotalCellsInRois],'VariableNames',namesColumns,'RowNames',namesRows);

        
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
        
         disp([filePaths{nPath} ' cell height ' num2str(cellHeight) '/' num2str(nCellHeight) ' completed'])
        

        
    end
    
end