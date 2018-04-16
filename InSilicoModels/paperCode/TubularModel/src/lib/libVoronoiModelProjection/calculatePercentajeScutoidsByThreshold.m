function calculatePercentajeScutoidsByThreshold(pathTube,numSeeds,H,W,totalRandom,projection,thresholdRes)

numberOfRows=11;
path2load=[pathTube projection '\' num2str(H) 'x' num2str(W) '_' num2str(numSeeds) 'seeds\'];
load([path2load 'Image_1_Diagram_5\Image_1_Diagram_5.mat'],'listLOriginalProjection')
listSurfaceRatios=listLOriginalProjection.surfaceRatio;
    
numOfSurfaceRatios=length(listSurfaceRatios);

%defining variables to storage the total data involved in transitions
listTransitionPerCell=zeros(numberOfRows,numOfSurfaceRatios,totalRandom);
listWinningNeigh=zeros(numberOfRows,numOfSurfaceRatios,totalRandom);
listLossingNeigh=zeros(numberOfRows,numOfSurfaceRatios,totalRandom);
listNumberOfCellsWinning=zeros(numOfSurfaceRatios,totalRandom);
listNumberOfCellsLossing=zeros(numOfSurfaceRatios,totalRandom);
listNumberOfScutoids=zeros(numOfSurfaceRatios,totalRandom);
listNumberOfFrusta=zeros(numOfSurfaceRatios,totalRandom);
listFrequencyOfChangesPerCell=zeros(numOfSurfaceRatios,totalRandom);


for nRand = 1:totalRandom
    
    load([path2load 'Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listLOriginalProjection','totalCellMotifs','totalEdges')
       
    numberOfCellsWinning=zeros(1,size(listLOriginalProjection,1));
    numberOfCellsLossing=zeros(1,size(listLOriginalProjection,1));
    numberOfCellsLossingOrWinning=zeros(1,size(listLOriginalProjection,1));
    numberOfCellsInNoTransitions=zeros(1,size(listLOriginalProjection,1));
    frequencyOfChangesPerCell=zeros(1,size(listLOriginalProjection,1));
    winningNeigh=zeros(size(listLOriginalProjection,1),numberOfRows);
    lossingNeigh=zeros(size(listLOriginalProjection,1),numberOfRows);
    transitionPerCell=zeros(size(listLOriginalProjection,1),numberOfRows);

    for nSurfRat=1:length(listSurfaceRatios)
        if strcmp(projection,'expansion')
            L_basal=listLOriginalProjection.L_originalProjection{listSurfaceRatios==listSurfaceRatios(nSurfRat)};
            L_apical=listLOriginalProjection.L_originalProjection{listSurfaceRatios==1};
        else
            L_apical=listLOriginalProjection.L_originalProjection{listSurfaceRatios(nSurfRat)};
            L_basal=listLOriginalProjection.L_originalProjection{listSurfaceRatios==1};
        end
        edgeLengthApical=totalEdges.TransitionInApical{nSurfRat};
        edgeLengthBasal=totalEdges.TransitionInBasal{nSurfRat};
        indexesOverThresholdApical=edgeLengthApical>(thresholdRes+2);
        indexesOverThresholdBasal=edgeLengthBasal>(thresholdRes+2);
        
        cellPairsApical=totalCellMotifs.TransitionInApical{nSurfRat};
        cellPairsBasal=totalCellMotifs.TransitionInBasal{nSurfRat};
        %filtering by overthreshold
        cellPairsApical=cellPairsApical(indexesOverThresholdApical,:);
        cellPairsBasal=cellPairsBasal(indexesOverThresholdBasal,:);
        
        %calculateNeighs in apical with a distance equal to the threshold,
        %to discard transition motifs that were captured in basal
        if nSurfRat==1
            neighsApicalThres=calculateNeighboursByThreshold(L_apical,thresholdRes);
            pairOfNeighsApicalThreshold=(cellfun(@(x, y) [y*ones(length(x),1),x],neighsApicalThres',num2cell(1:size(neighsApicalThres,2))','UniformOutput',false));
            uniquePairOfNeighApicalThreshold=unique(vertcat(pairOfNeighsApicalThreshold{:}),'rows');
            uniquePairOfNeighApicalThreshold=unique([min(uniquePairOfNeighApicalThreshold,[],2),max(uniquePairOfNeighApicalThreshold,[],2)],'rows');
        end
        
        
        if ~isempty(cellPairsApical) && ~isempty(cellPairsApical)
            %calculateNeighs in basal with a distance equal to the threshold,
            %to discard transition motifs that were captured in apical
            neighsBasalThres=calculateNeighboursByThreshold(L_basal,thresholdRes);
            pairOfNeighsBasalThreshold=(cellfun(@(x, y) [y*ones(length(x),1),x],neighsBasalThres',num2cell(1:size(neighsBasalThres,2))','UniformOutput',false));
            uniquePairOfNeighBasalThreshold=unique(vertcat(pairOfNeighsBasalThreshold{:}),'rows');
            uniquePairOfNeighBasalThreshold=unique([min(uniquePairOfNeighBasalThreshold,[],2),max(uniquePairOfNeighBasalThreshold,[],2)],'rows');
        
            indexToDeleteInApical=ismember(cellPairsApical,uniquePairOfNeighBasalThreshold,'rows');
            indexToDeleteInBasal=ismember(cellPairsBasal,uniquePairOfNeighApicalThreshold,'rows');

            winningNeighCells=cellPairsApical(~indexToDeleteInApical,:);
            lossingNeighCells=cellPairsBasal(~indexToDeleteInBasal,:);
            cellsWithTransition=[winningNeighCells;lossingNeighCells];

            %calculate valid cells
            noValidCells=unique([L_basal([1 end],:),L_apical([1 end],:)]);
            validCells=setdiff(unique(L_apical),noValidCells);

            scutoids=validCells(ismember(validCells,cellsWithTransition));

            winningNeighCells(ismember(winningNeighCells,noValidCells))=[];
            lossingNeighCells(ismember(lossingNeighCells,noValidCells))=[];

            winningPerCell=cell2mat(arrayfun(@(x) sum(sum(ismember(winningNeighCells,x))),1:numSeeds,'UniformOutput',false));
            lossingPerCell=cell2mat(arrayfun(@(x) sum(sum(ismember(lossingNeighCells,x))),1:numSeeds,'UniformOutput',false));
            motifsTransitionPerCell=cell2mat(arrayfun(@(x,y) sum([x,y]),winningPerCell,lossingPerCell,'UniformOutput',false));

            %number of presences
            numberOfCellsWinning(1,nSurfRat)=length(unique(winningNeighCells))/length(validCells);
            numberOfCellsLossing(1,nSurfRat)=length(unique(lossingNeighCells))/length(validCells);
            numberOfCellsLossingOrWinning(1,nSurfRat)=length(scutoids)/length(validCells);
            numberOfCellsInNoTransitions(1,nSurfRat)=(1-numberOfCellsLossingOrWinning(1,nSurfRat));
            frequencyOfChangesPerCell(1,nSurfRat)=mean(motifsTransitionPerCell(validCells));

            %Data for histograms
            winningNeigh(nSurfRat,:)=[sum(winningPerCell(validCells)==0),sum(winningPerCell(validCells)==1),sum(winningPerCell(validCells)==2),sum(winningPerCell(validCells)==3),sum(winningPerCell(validCells)==4)...
                sum(winningPerCell(validCells)==5),sum(winningPerCell(validCells)==6),sum(winningPerCell(validCells)==7),sum(winningPerCell(validCells)==8),sum(winningPerCell(validCells)==9),sum(winningPerCell(validCells)==10)]/length(validCells);
            lossingNeigh(nSurfRat,:)=[sum(lossingPerCell(validCells)==0),sum(lossingPerCell(validCells)==1),sum(lossingPerCell(validCells)==2),sum(lossingPerCell(validCells)==3),sum(lossingPerCell(validCells)==4)...
                sum(lossingPerCell(validCells)==5),sum(lossingPerCell(validCells)==6),sum(lossingPerCell(validCells)==7),sum(lossingPerCell(validCells)==8),sum(lossingPerCell(validCells)==9),sum(lossingPerCell(validCells)==10)]/length(validCells);
            transitionPerCell(nSurfRat,:)=[sum(motifsTransitionPerCell(validCells)==0),sum(motifsTransitionPerCell(validCells)==1),sum(motifsTransitionPerCell(validCells)==2),sum(motifsTransitionPerCell(validCells)==3),sum(motifsTransitionPerCell(validCells)==4)...
                sum(motifsTransitionPerCell(validCells)==5),sum(motifsTransitionPerCell(validCells)==6),sum(motifsTransitionPerCell(validCells)==7),sum(motifsTransitionPerCell(validCells)==8),sum(motifsTransitionPerCell(validCells)==9),sum(motifsTransitionPerCell(validCells)==10)]/length(validCells);
        else
            numberOfCellsInNoTransitions(1,nSurfRat)=1;
        end
        
        
    end
    
    disp(['Completed % scutoids in ' num2str(H) 'x' num2str(W) '_' num2str(numSeeds) 'seeds - rand' num2str(nRand)])

    %Acum data
    listTransitionPerCell(:,:,nRand)=transitionPerCell';
    listWinningNeigh(:,:,nRand)=winningNeigh';
    listLossingNeigh(:,:,nRand)=lossingNeigh';
    listNumberOfCellsWinning(:,nRand)=numberOfCellsWinning';
    listNumberOfCellsLossing(:,nRand)=numberOfCellsLossing';
    listNumberOfScutoids(:,nRand)=numberOfCellsLossingOrWinning';
    listNumberOfFrusta(:,nRand)=numberOfCellsInNoTransitions';
    listFrequencyOfChangesPerCell(:,nRand)=frequencyOfChangesPerCell';
   
end

%table of scutoids presence
colNames={'meanScutoids','stdScutoids','meanFrusta','stdFrusta','meanWinningNeighbouringBasal',...
    'stdWinningNeighbouringBasal','meanLossingNeighbouringBasal','stdLossingNeighbouringBasal','meanScutoidalEdgesPerCell','stdScutoidalEdgesPerCell'};
rowNames=arrayfun(@(x) ['surfaceRatio' num2str(x)],listLOriginalProjection.surfaceRatio,'UniformOutput',false);
tableProportionOfScutoids=array2table([mean(listNumberOfScutoids,2),std(listNumberOfScutoids,[],2),...
    mean(listNumberOfFrusta,2),std(listNumberOfFrusta,[],2),...
    mean(listNumberOfCellsWinning,2),std(listNumberOfCellsWinning,[],2),...
    mean(listNumberOfCellsLossing,2),std(listNumberOfCellsLossing,[],2),...
    mean(listFrequencyOfChangesPerCell,2),std(listFrequencyOfChangesPerCell,[],2)],'VariableNames',colNames,'RowNames',rowNames);

colNames={'zero','one','two','three','four','five','six','seven','eight','nine','ten'};

%distribution of scutoids repetitions, per surface ratio and per cell
scutoidsDistribution.average=array2table(mean(listTransitionPerCell,3)','VariableNames',colNames,'RowNames',rowNames);
scutoidsDistribution.std=array2table(std(listTransitionPerCell,[],3)','VariableNames',colNames,'RowNames',rowNames);
winningNeighDistribution.average=array2table(mean(listWinningNeigh,3)','VariableNames',colNames,'RowNames',rowNames);
winningNeighDistribution.std=array2table(std(listWinningNeigh,[],3)','VariableNames',colNames,'RowNames',rowNames);
lossingNeighDistribution.average=array2table(mean(listLossingNeigh,3)','VariableNames',colNames,'RowNames',rowNames);
lossingNeighDistribution.std=array2table(std(listLossingNeigh,[],3)','VariableNames',colNames,'RowNames',rowNames);


writetable(tableProportionOfScutoids, [path2load 'scutoidsProportion_threshold' num2str(thresholdRes) '_' date '.xls'],'WriteRowNames',true);
save([path2load 'distributionScutoidsPerCell_threshold' num2str(thresholdRes) '_' date '.mat'],'scutoidsDistribution','winningNeighDistribution','lossingNeighDistribution');
