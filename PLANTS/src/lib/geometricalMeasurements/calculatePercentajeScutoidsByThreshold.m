function [tableScutoids] = calculatePercentajeScutoidsByThreshold(validCells,noValidCells,neighApical,neighBasal,totalEdges,thresholdRes)
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

%             winningNeighCells(ismember(winningNeighCells,noValidCells))=[];
%             lossingNeighCells(ismember(lossingNeighCells,noValidCells))=[];

            %number of presences
            numberOfCellsLossingOrWinning = length(scutoids)/length(validCells);
            numberOfCellsInNoTransitions = (1-numberOfCellsLossingOrWinning);
            frequencyOfChangesPerCell = sum(ismember(cellsWithTransition(:),validCells))/length(validCells);

        else
            numberOfCellsInNoTransitions = 1;
            scutoids = nan;
            numberOfCellsLossingOrWinning = 0;
            frequencyOfChangesPerCell = 0;
        end
        
        tableScutoids = cell2table([{scutoids},{numberOfCellsLossingOrWinning},{numberOfCellsInNoTransitions},{frequencyOfChangesPerCell}],'VariableNames',{'scutoidCells','percScutoid','percNoScutoid','transitionsPerCell'});

end