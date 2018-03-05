function [dataEnergy,dataEnergyNonPreservedMotifs,numberOfValidMotifs] = getEnergyFromEdges( outerProjection,innerRoiProjection,neighsOuter,neighsInner,noValidCells,validCells,pairsOfCells,flag)


    [~,W_outer]=size(outerProjection);
    [~,W_inner]=size(innerRoiProjection);

    %all vertices in outer surface
    [verticesOuter]=calculateVertices(outerProjection,neighsOuter);
    outerVerticesPerCell=arrayfun(@(x) find(sum(x==verticesOuter.verticesConnectCells,2)), 1:max(max(outerProjection)), 'UniformOutput', false);
    
    %all vertices in inner surface
    [verticesInner]=calculateVertices(innerRoiProjection,neighsInner);
    innerVerticesPerCell=arrayfun(@(x) find(sum(x==verticesInner.verticesConnectCells,2)), 1:max(max(innerRoiProjection)), 'UniformOutput', false);
    
    pairCell=cellfun(@(x, y) [y*ones(length(x),1),x],pairsOfCells',num2cell(1:length(pairsOfCells))','UniformOutput',false);
    pairCell=unique(vertcat(pairCell{:}),'rows');
    pairCell=unique([min(pairCell,[],2),max(pairCell,[],2)],'rows');
                
    pairCell=pairCell(sum(ismember(pairCell,validCells),2)==2,:);

    
    
    %vertices of edges transition in outer
    verticesOfEdgesOuter=arrayfun(@(x,y) intersect(outerVerticesPerCell{x},outerVerticesPerCell{y}), pairCell(:,1),pairCell(:,2),'UniformOutput',false);
       
    fourCellsMotifs=cellfun(@(x) unique(horzcat(verticesOuter.verticesConnectCells(x,:))),verticesOfEdgesOuter, 'UniformOutput', false);
    validPairs1=cell2mat(cellfun(@(x) isempty(intersect(noValidCells,x)) & length(x)==4 ,fourCellsMotifs,'UniformOutput',false));
    
    fourCellsMotifsValidCells=fourCellsMotifs(validPairs1,:);
    
    pairCellValidCells=pairCell(validPairs1,:);
    
    cellsInMotifNoContactValidCells=arrayfun(@(x) setdiff(fourCellsMotifsValidCells{x},pairCellValidCells(x,:))',1:size(pairCellValidCells,1), 'UniformOutput', false);
    
    %deleting incoherences with motif of 5 or 3 cells
    validPairs2=cell2mat(cellfun(@(x) length(x)==2,cellsInMotifNoContactValidCells,'UniformOutput',false))';
    cellsInMotifNoContactValidCells=cell2mat(cellsInMotifNoContactValidCells(validPairs2)');
    pairCellValidCells=pairCellValidCells(validPairs2,:);
       
    
    if sum(pairCellValidCells)==0
        dataEnergy=[];
        dataEnergyNonPreservedMotifs=[];
        numberOfValidMotifs=0;
        return
    else
        numberOfValidMotifs=length(validPairs2);
    end
    
    %check if the 4 cells motif are preserved in inner
    preservedMotifsInInner=cell2mat(arrayfun(@(x,y,z,zz) (sum(ismember(neighsInner{x},[z,zz]))+sum(ismember(neighsInner{y},[z,zz])))==4,...
        cellsInMotifNoContactValidCells(:,1),cellsInMotifNoContactValidCells(:,2),pairCellValidCells(:,1),pairCellValidCells(:,2),'UniformOutput',false));
    
    
    %we filter with the motifs that they are in contact in inner.
    pairCellValidCellsPreserved=pairCellValidCells(preservedMotifsInInner,:);
    cellsInMotifNoContactValidCellsPreserved=cellsInMotifNoContactValidCells(preservedMotifsInInner,:);
    

    %testing transition data
    dataEnergy.fourCellsMotif=[pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved];
    dataEnergyNonPreservedMotifs.fourCellsMotif=[pairCellValidCells,cellsInMotifNoContactValidCells];

    
    [dataEnergy.outerEdgeLength,dataEnergy.outerSumEdgesOfEnergy,dataEnergy.outerEdgeAngle,dataEnergy.outerH1,dataEnergy.outerH2,dataEnergy.outerW1,dataEnergy.outerW2,notEmptyIndexesOuter]=capturingWidthHeightAndEnergy(outerVerticesPerCell,verticesOuter,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved,W_outer);
    if strcmp(flag,'transition')
        [dataEnergy.innerEdgeLength,dataEnergy.innerSumEdgesOfEnergy,dataEnergy.innerEdgeAngle,dataEnergy.innerH1,dataEnergy.innerH2,dataEnergy.innerW1,dataEnergy.innerW2,noEmptyIndexesInner]=capturingWidthHeightAndEnergy(innerVerticesPerCell,verticesInner,cellsInMotifNoContactValidCellsPreserved,pairCellValidCellsPreserved,W_inner);        
    else
        [dataEnergy.innerEdgeLength,dataEnergy.innerSumEdgesOfEnergy,dataEnergy.innerEdgeAngle,dataEnergy.innerH1,dataEnergy.innerH2,dataEnergy.innerW1,dataEnergy.innerW2,noEmptyIndexesInner]=capturingWidthHeightAndEnergy(innerVerticesPerCell,verticesInner,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved,W_inner);
    end
    
    %testing transitions data (without filtering with preserved in inner)
    [dataEnergyNonPreservedMotifs.outerEdgeLength,dataEnergyNonPreservedMotifs.outerSumEdgesOfEnergy,dataEnergyNonPreservedMotifs.outerEdgeAngle,dataEnergyNonPreservedMotifs.outerH1,dataEnergyNonPreservedMotifs.outerH2,dataEnergyNonPreservedMotifs.outerW1,dataEnergyNonPreservedMotifs.outerW2,notEmptyIndexesOuterTransitions]=capturingWidthHeightAndEnergy(outerVerticesPerCell,verticesOuter,pairCellValidCells,cellsInMotifNoContactValidCells,W_outer);
    
    if sum(notEmptyIndexesOuter)< length(notEmptyIndexesOuter) || sum(noEmptyIndexesInner)< length(noEmptyIndexesInner)
        
        notEmptyIndexes=(noEmptyIndexesInner & notEmptyIndexesOuter);
        
        dataEnergy.fourCellsMotif=dataEnergy.fourCellsMotif(notEmptyIndexes,:);
        dataEnergy.innerH1=dataEnergy.innerH1(notEmptyIndexes);
        dataEnergy.innerH2=dataEnergy.innerH2(notEmptyIndexes);
        dataEnergy.innerW1=dataEnergy.innerW1(notEmptyIndexes);
        dataEnergy.innerW2=dataEnergy.innerW2(notEmptyIndexes);
        dataEnergy.innerSumEdgesOfEnergy=dataEnergy.innerSumEdgesOfEnergy(notEmptyIndexes);
        dataEnergy.innerEdgeLength=dataEnergy.innerEdgeLength(notEmptyIndexes);
        dataEnergy.innerEdgeAngle=dataEnergy.innerEdgeAngle(notEmptyIndexes);

        dataEnergy.outerH1=dataEnergy.outerH1(notEmptyIndexes);
        dataEnergy.outerH2=dataEnergy.outerH2(notEmptyIndexes);
        dataEnergy.outerW1=dataEnergy.outerW1(notEmptyIndexes);
        dataEnergy.outerW2=dataEnergy.outerW2(notEmptyIndexes);
        dataEnergy.outerSumEdgesOfEnergy=dataEnergy.outerSumEdgesOfEnergy(notEmptyIndexes);
        dataEnergy.outerEdgeLength=dataEnergy.outerEdgeLength(notEmptyIndexes);
        dataEnergy.outerEdgeAngle=dataEnergy.outerEdgeAngle(notEmptyIndexes);
    end
    
    if sum(notEmptyIndexesOuterTransitions)< length(notEmptyIndexesOuterTransitions)
        dataEnergyNonPreservedMotifs.fourCellsMotif=dataEnergyNonPreservedMotifs.fourCellsMotif(notEmptyIndexesOuterTransitions,:);
        dataEnergyNonPreservedMotifs.outerH1=dataEnergyNonPreservedMotifs.outerH1(notEmptyIndexesOuterTransitions);
        dataEnergyNonPreservedMotifs.outerH2=dataEnergyNonPreservedMotifs.outerH2(notEmptyIndexesOuterTransitions);
        dataEnergyNonPreservedMotifs.outerW1=dataEnergyNonPreservedMotifs.outerW1(notEmptyIndexesOuterTransitions);
        dataEnergyNonPreservedMotifs.outerW2=dataEnergyNonPreservedMotifs.outerW2(notEmptyIndexesOuterTransitions);
        dataEnergyNonPreservedMotifs.outerSumEdgesOfEnergy=dataEnergyNonPreservedMotifs.outerSumEdgesOfEnergy(notEmptyIndexesOuterTransitions);
        dataEnergyNonPreservedMotifs.outerEdgeLength=dataEnergyNonPreservedMotifs.outerEdgeLength(notEmptyIndexesOuterTransitions);
        dataEnergyNonPreservedMotifs.outerEdgeAngle=dataEnergyNonPreservedMotifs.outerEdgeAngle(notEmptyIndexesOuterTransitions);
    end
    
    
end