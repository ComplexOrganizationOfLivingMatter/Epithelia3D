function [proportionOfScutoids,proportionOfCellsWinning,proportionOfCellsLossing,proportionOfFrusta,proportionWinningNeigh,proportionLossingNeigh,proportionTransitionsPerCell]=calculateNumberOfCellsInvolvedInTransitions(DataTransitionOuter,DataTransitionInner,validCells)
%Calculation of scutoids (using lossing or winngin of neighbours)

    if isempty(DataTransitionOuter) 
        scutoidsOuter=[];
    else
        scutoidsOuter=DataTransitionOuter.cellularMotifs(:);
        scutoidsOuter=scutoidsOuter(ismember(scutoidsOuter,validCells));
    end
    if isempty(DataTransitionInner)
        scutoidsInner=[];     
    else
        scutoidsInner=DataTransitionInner.cellularMotifs(:);
        scutoidsInner=scutoidsInner(ismember(scutoidsInner,validCells));
    end
    
    
    %Data for histograms 
    %number of lossing            
    proportionOfCellsLossing=(length(scutoidsOuter)/2)/length(validCells);
    uniqueOuterCells = unique(scutoidsOuter); 
    lossingPerCell = unique(uniqueOuterCells); 
    %number of winning             
    proportionOfCellsWinning=(length(scutoidsInner)/2)/length(validCells);
    uniqueInnerCells = unique(scutoidsInner); 
    winningPerCell = histc(scutoidsInner,uniqueInnerCells);
    
    uniqueTotalCells = unique([scutoidsOuter;scutoidsInner]);
    motifsTransitionPerCell = histc([scutoidsOuter;scutoidsInner],uniqueTotalCells);
    
    proportionWinningNeigh=[length(setdiff(validCells,uniqueInnerCells)),sum(winningPerCell==1),sum(winningPerCell==2),sum(winningPerCell==3),sum(winningPerCell==4)...
        sum(winningPerCell==5),sum(winningPerCell==6),sum(winningPerCell==7),sum(winningPerCell==8),sum(winningPerCell==9),sum(winningPerCell==10)]/length(validCells);
    proportionLossingNeigh=[length(setdiff(validCells,uniqueOuterCells)),sum(lossingPerCell==1),sum(lossingPerCell==2),sum(lossingPerCell==3),sum(lossingPerCell==4)...
        sum(lossingPerCell==5),sum(lossingPerCell==6),sum(lossingPerCell==7),sum(lossingPerCell==8),sum(lossingPerCell==9),sum(lossingPerCell==10)]/length(validCells);
    proportionTransitionsPerCell=[length(setdiff(validCells,uniqueTotalCells)),sum(motifsTransitionPerCell==1),sum(motifsTransitionPerCell==2),sum(motifsTransitionPerCell==3),sum(motifsTransitionPerCell==4)...
        sum(motifsTransitionPerCell==5),sum(motifsTransitionPerCell==6),sum(motifsTransitionPerCell==7),sum(motifsTransitionPerCell==8),sum(motifsTransitionPerCell==9),sum(motifsTransitionPerCell==10)]/length(validCells);

    %number of scutoids
    proportionOfScutoids=length(uniqueTotalCells)/length(validCells);
    proportionOfFrusta=1-proportionOfScutoids;
    
end

