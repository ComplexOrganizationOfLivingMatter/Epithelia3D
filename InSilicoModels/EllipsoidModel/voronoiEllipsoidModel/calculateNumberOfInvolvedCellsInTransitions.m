function [proportionOfScutoids,proportionOfCellsWinning,proportionOfCellsLossing,proportionOfCellsInNoTransitions,proportionWinningNeigh,proportionLossingNeigh,proportionTransitionsPerCell]=calculateNumberOfInvolvedCellsInTransitions(neighsInner,neighsOuter,validCells)
%Calculation of scutoids (using lossing or winngin of neighbours)

    Lossing=cellfun(@(x,y) setdiff(x,y),neighsOuter(validCells),neighsInner(validCells),'UniformOutput',false);
    Winning=cellfun(@(x,y) setdiff(x,y),neighsInner(validCells),neighsOuter(validCells),'UniformOutput',false);

    winningPerCell=cell2mat(cellfun(@(x) length(x),Winning,'UniformOutput',false));
    lossingPerCell=cell2mat(cellfun(@(x) length(x),Lossing,'UniformOutput',false));
    motifsTransitionPerCell=cell2mat(cellfun(@(x,y) length(unique([x; y])),Lossing,Winning,'UniformOutput',false));

    %number of presences (winning or lossing neighs and number of scutoids)
    proportionOfCellsWinning=sum(winningPerCell>0)/length(validCells);
    proportionOfCellsLossing=sum(lossingPerCell>0)/length(validCells);
    proportionOfScutoids=sum(motifsTransitionPerCell>0)/length(validCells);
    proportionOfCellsInNoTransitions=1-proportionOfScutoids;

    %Data for histograms
    labelProportions={'zero','one','two','three','four','five','six','seven','eight','nine','ten'};
   
    winningNeigh=[sum(winningPerCell==0),sum(winningPerCell==1),sum(winningPerCell==2),sum(winningPerCell==3),sum(winningPerCell==4)...
        sum(winningPerCell==5),sum(winningPerCell==6),sum(winningPerCell==7),sum(winningPerCell==8),sum(winningPerCell==9),sum(winningPerCell==10)];
    lossingNeigh=[sum(lossingPerCell==0),sum(lossingPerCell==1),sum(lossingPerCell==2),sum(lossingPerCell==3),sum(lossingPerCell==4)...
        sum(lossingPerCell==5),sum(lossingPerCell==6),sum(lossingPerCell==7),sum(lossingPerCell==8),sum(lossingPerCell==9),sum(lossingPerCell==10)];
    transitionPerCell=[sum(motifsTransitionPerCell==0),sum(motifsTransitionPerCell==1),sum(motifsTransitionPerCell==2),sum(motifsTransitionPerCell==3),sum(motifsTransitionPerCell==4)...
        sum(motifsTransitionPerCell==5),sum(motifsTransitionPerCell==6),sum(motifsTransitionPerCell==7),sum(motifsTransitionPerCell==8),sum(motifsTransitionPerCell==9),sum(motifsTransitionPerCell==10)]/2;

    proportionWinningNeigh=array2table(winningNeigh/length(validCells),'VariableNames',labelProportions);
    proportionLossingNeigh=array2table(lossingNeigh/length(validCells),'VariableNames',labelProportions);
    proportionTransitionsPerCell=array2table(transitionPerCell/length(validCells),'VariableNames',labelProportions);

   
end

