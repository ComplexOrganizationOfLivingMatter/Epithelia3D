

addpath(genpath('src'))
addpath(genpath('lib'))

filePathVoronoiStage8='results\Stage 8\';
filePathVoronoiStage4='results\Stage 4\';
filePathGlobe='results\Globe\';
filePathRugby='results\Rugby\';
filePathSphere='results\Sphere\';
resolutionTresholds=[4, 0];

filePaths={filePathVoronoiStage8,filePathVoronoiStage4,filePathGlobe,filePathRugby, filePathSphere};
for resolutionTreshold=resolutionTresholds
    for nPath=5%length(filePaths)

        switch nPath
            case 1
                numRandoms=1:30;
                nCellHeight=1;
                listCellHeight=[1];
            case 2
                numRandoms=1:130;
                nCellHeight=1;
                listCellHeight=[1];
            otherwise
                numRandoms=1:10;
                nCellHeight=3;
                listCellHeight=[0.5 1 2];
        end

        for cellHeight=1:nCellHeight

            %initializing parameters to store the data of scutoids, angle and
            %lenth edges
            totalProportionScutoids=zeros(length(numRandoms),1);
            totalProportionWinNeigh=zeros(length(numRandoms),1);
            totalProportionLossNeigh=zeros(length(numRandoms),1);
            totalProportionOfCellsInNoTransitions=zeros(length(numRandoms),1);
            totalCellsInRois=zeros(length(numRandoms),1);
            proportionAnglesTransition=zeros(length(numRandoms),6);
            proportionAnglesNoTransition=zeros(length(numRandoms),6);
            totalAnglesTransition=cell(length(numRandoms));
            totalAnglesNoTransition=cell(length(numRandoms));
            totalLengthTransition=cell(length(numRandoms));
            totalLengthNoTransition=cell(length(numRandoms));
            distributionWinningNeigh=zeros(length(numRandoms),11);
            distributionLossingNeigh=zeros(length(numRandoms),11);
            distributionTransitionsPerCell=zeros(length(numRandoms),11);

            parfor numnRand=1:length(numRandoms)
                nRand = numRandoms(numnRand);
                [totalCellsInRois(numnRand),totalProportionScutoids(numnRand),totalProportionWinNeigh(numnRand),...
                    totalProportionLossNeigh(numnRand),totalProportionOfCellsInNoTransitions(numnRand),...
                    distributionWinningNeigh(numnRand,:),distributionLossingNeigh(numnRand,:),...
                    distributionTransitionsPerCell(numnRand,:),proportionAnglesTransition(numnRand,:),...
                    proportionAnglesNoTransition(numnRand,:),totalAnglesTransition{numnRand},...
                    totalAnglesNoTransition{numnRand},totalLengthTransition{numnRand},totalLengthNoTransition{numnRand}]...
                    =calculationAngleLengthScutoidsInEdges(filePaths{nPath},nRand,listCellHeight(cellHeight),nCellHeight,resolutionTreshold);
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
            proportionAnglesTransition(isnan(proportionAnglesTransition)) = 0;
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

            folderResThreshold=[filePaths{nPath} 'resolutionThreshold' num2str(resolutionTreshold) '\'];
            mkdir(folderResThreshold)
            if nCellHeight>1
                save([folderResThreshold 'dataAngleLengthEdges_cellHeight' num2str(listCellHeight(cellHeight)) '_' date '.mat'],'totalAnglesTransition','totalAnglesNoTransition','totalLengthTransition','totalLengthNoTransition','tableProportionOfAngles')
                writetable(tableProportionOfAngles,[folderResThreshold 'tableDistributionAngleEdges_cellHeight' num2str(listCellHeight(cellHeight)) '_' date '.xls'],'WriteRowNames',true);
                writetable(tableProportionOfPresencesPerCell,[folderResThreshold 'tableNumberOfTransitionsWinningLossing_cellHeight' num2str(listCellHeight(cellHeight)) '_' date '.xls'],'WriteRowNames',true);
                writetable(tableProportionScutoids,[folderResThreshold 'tableScutoidsProportions_cellHeight' num2str(listCellHeight(cellHeight)) '_' date '.xls'],'WriteRowNames',true)
            else
                save([folderResThreshold 'dataAngleLengthEdges_' date '.mat'],'totalAnglesTransition','totalAnglesNoTransition','totalLengthTransition','totalLengthNoTransition','tableProportionOfAngles')
                writetable(tableProportionOfAngles,[folderResThreshold 'tableDistributionAngleEdges_' date '.xls'],'WriteRowNames',true);
                writetable(tableProportionOfPresencesPerCell,[folderResThreshold 'tableNumberOfTransitionsWinningLossing_' date '.xls'],'WriteRowNames',true);
                writetable(tableProportionScutoids,[folderResThreshold 'tableScutoidsProportions_' date '.xls'],'WriteRowNames',true)
            end

             disp([filePaths{nPath} ' cell height ' num2str(listCellHeight(cellHeight)) '/' num2str(listCellHeight(end)) ' completed'])

        end

    end
end