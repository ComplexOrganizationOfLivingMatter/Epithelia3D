function [scutoids,numberOfCellsInNoTransitions,numberOfCellsLossingOrWinning,frequencyOfChangesPerCell] = calculatePercentajeScutoidsByThreshold(validCells,noValidCells,neighApical,neighBasal,totalEdges,thresholdRes)
%CALCULATEPERCENTAJESCUTOIDSBYTHRESHOLD calculate the presence of scutoids
%that pass the edge length threshold in both layers (apical and basal)

        %load total edges with transition
        edgeLengthApical=totalEdges.apicalTransition.edgeLength;
        edgeLengthBasal=totalEdges.basalTransition.edgeLength;
        indexesOverThresholdApical=edgeLengthApical>(thresholdRes+2);
        indexesOverThresholdBasal=edgeLengthBasal>(thresholdRes+2);
        
        %pair of cells with transition
        cellPairsApical=totalEdges.apicalTransition.cellularMotifs;
        cellPairsBasal=totalEdges.basalTransition.cellularMotifs;
        
        %filtering by overthreshold
        cellPairsApical=cellPairsApical(indexesOverThresholdApical,:);
        cellPairsBasal=cellPairsBasal(indexesOverThresholdBasal,:);
        
        %unique pair of neighs in apical
        pairOfNeighApical=(cellfun(@(x, y) [y*ones(length(x),1),x],neighApical',num2cell(1:size(neighApical,1)),'UniformOutput',false));
        uniquePairOfNeighApical=unique(vertcat(pairOfNeighApical{:}),'rows');
        uniquePairOfNeighApical=unique([min(uniquePairOfNeighApical,[],2),max(uniquePairOfNeighApical,[],2)],'rows');
        
        
        if ~isempty(cellPairsApical) && ~isempty(cellPairsBasal)
            
            %unique pair of neighs in basal
            pairOfNeighBasal=(cellfun(@(x, y) [y*ones(length(x),1),x],neighBasal',num2cell(1:size(neighBasal,1)),'UniformOutput',false));
            uniquePairOfNeighBasal=unique(vertcat(pairOfNeighBasal{:}),'rows');
            uniquePairOfNeighBasal=unique([min(uniquePairOfNeighBasal,[],2),max(uniquePairOfNeighBasal,[],2)],'rows');
        
            %cells pair to discard in transitions
            indexToDeleteInApical=ismember(cellPairsApical,uniquePairOfNeighBasal,'rows');
            indexToDeleteInBasal=ismember(cellPairsBasal,uniquePairOfNeighApical,'rows');

            winningNeighCells=cellPairsApical(~indexToDeleteInApical,:);
            lossingNeighCells=cellPairsBasal(~indexToDeleteInBasal,:);
            cellsWithTransition=[winningNeighCells;lossingNeighCells];

            %scutoids
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
            numberOfCellsInNoTransitions(1,nSurfRat) = 1;
            scutoids = [];
            numberOfCellsLossingOrWinning = 0;
            frequencyOfChangesPerCell = 0;
        end

end