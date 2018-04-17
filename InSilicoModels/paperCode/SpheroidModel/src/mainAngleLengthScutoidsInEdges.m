function [] = mainAngleLengthScutoidsInEdges()
%MAINANGLELENGTHSCUTOIDSINEDGES 
% 
    originalDir = 'results';
    filePaths = dir(originalDir);
    filePaths = {filePaths(3:end).name};
    resolutionTresholds=[4, 0];

    for resolutionTreshold=resolutionTresholds
        for nPath=1:length(filePaths)
            actualDir = strcat(originalDir, '\', filePaths{nPath}, '\');

            randomDirectories = dir(strcat(actualDir, '\randomizations\random_*'));
            numRandoms = 1:length(randomDirectories);

            cellHeightFiles = dir(strcat(actualDir, 'randomizations\random_1\*llipsoid_*cellHeight*'));

            nCellHeight = length(cellHeightFiles);

            listCellHeight = cellfun(@(x) strsplit(strrep(x, '.mat', ''), 'cellHeight'), {cellHeightFiles.name}, 'uniformOutput', false);
            listCellHeight = cellfun(@(x) x(end), listCellHeight);

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

                for numnRand=1:length(numRandoms)
                    nRand = numRandoms(numnRand);
                    [totalCellsInRois(numnRand),totalProportionScutoids(numnRand),totalProportionWinNeigh(numnRand),...
                        totalProportionLossNeigh(numnRand),totalProportionOfCellsInNoTransitions(numnRand),...
                        distributionWinningNeigh(numnRand,:),distributionLossingNeigh(numnRand,:),...
                        distributionTransitionsPerCell(numnRand,:),proportionAnglesTransition(numnRand,:),...
                        proportionAnglesNoTransition(numnRand,:),totalAnglesTransition{numnRand},...
                        totalAnglesNoTransition{numnRand},totalLengthTransition{numnRand},totalLengthNoTransition{numnRand}]...
                        =calculationAngleLengthScutoidsInEdges(actualDir,nRand,listCellHeight{cellHeight},nCellHeight,resolutionTreshold);
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

                save([folderResThreshold 'dataAngleLengthEdges_cellHeight' listCellHeight{cellHeight} '_' date '.mat'],'totalAnglesTransition','totalAnglesNoTransition','totalLengthTransition','totalLengthNoTransition','tableProportionOfAngles')
                writetable(tableProportionOfAngles,[folderResThreshold 'tableDistributionAngleEdges_cellHeight' listCellHeight{cellHeight} '_' date '.xls'],'WriteRowNames',true);
                writetable(tableProportionOfPresencesPerCell,[folderResThreshold 'tableNumberOfTransitionsWinningLossing_cellHeight' listCellHeight{cellHeight} '_' date '.xls'],'WriteRowNames',true);
                writetable(tableProportionScutoids,[folderResThreshold 'tableScutoidsProportions_cellHeight' listCellHeight{cellHeight} '_' date '.xls'],'WriteRowNames',true)


                disp([filePaths{nPath} ' cell height ' cellHeight '/' length(listCellHeight) ' completed'])

            end
        end
    end
end