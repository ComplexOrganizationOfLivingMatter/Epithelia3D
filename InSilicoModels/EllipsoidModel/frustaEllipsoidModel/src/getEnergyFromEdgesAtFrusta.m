function [dataEnergy,dataEnergyOuterNonPreservedMotifs,numberOfValidMotifs] = getEnergyFromEdgesAtFrusta( outerProjection,innerRoiProjection,neighsOuter,neighsInner,noValidCells,validCells,pairsOfCells,flag, verticesInner)


    [~,W_outer]=size(outerProjection);
    [~,W_inner]=size(innerRoiProjection);
    
    verticesOuter = verticesInner;
    

    %all vertices in outer surface
    %[verticesOuter]=calculateVertices(outerProjection,neighsOuter);
    outerVerticesPerCell=arrayfun(@(x) find(sum(x==verticesOuter.verticesConnectCells,2)), 1:max(max(outerProjection)), 'UniformOutput', false);
    
    %all vertices in inner surface
    %[verticesInner]=calculateVertices(innerRoiProjection,neighsInner);
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
        dataEnergyOuterNonPreservedMotifs=[];
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
    dataEnergyOuterNonPreservedMotifs.fourCellsMotif=[pairCellValidCells,cellsInMotifNoContactValidCells];

    
    [dataEnergy.outerEdgeLength,dataEnergy.outerSumEdgesOfEnergy,dataEnergy.outerEdgeAngle,dataEnergy.outerH1,dataEnergy.outerH2,dataEnergy.outerW1,dataEnergy.outerW2,notEmptyIndexesOuter]=capturingWidthHeightAndEnergy(outerVerticesPerCell,verticesOuter,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved);
    if strcmp(flag,'transition')
        [dataEnergy.innerEdgeLength,dataEnergy.innerSumEdgesOfEnergy,dataEnergy.innerEdgeAngle,dataEnergy.innerH1,dataEnergy.innerH2,dataEnergy.innerW1,dataEnergy.innerW2,noEmptyIndexesInner]=capturingWidthHeightAndEnergy(innerVerticesPerCell,verticesInner,cellsInMotifNoContactValidCellsPreserved,pairCellValidCellsPreserved);        
    else
        [dataEnergy.innerEdgeLength,dataEnergy.innerSumEdgesOfEnergy,dataEnergy.innerEdgeAngle,dataEnergy.innerH1,dataEnergy.innerH2,dataEnergy.innerW1,dataEnergy.innerW2,noEmptyIndexesInner]=capturingWidthHeightAndEnergy(innerVerticesPerCell,verticesInner,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved);
    end
    
    %testing transitions data (without filtering with preserved in inner)
    [dataEnergyOuterNonPreservedMotifs.outerEdgeLength,dataEnergyOuterNonPreservedMotifs.outerSumEdgesOfEnergy,dataEnergyOuterNonPreservedMotifs.outerEdgeAngle,dataEnergyOuterNonPreservedMotifs.outerH1,dataEnergyOuterNonPreservedMotifs.outerH2,dataEnergyOuterNonPreservedMotifs.outerW1,dataEnergyOuterNonPreservedMotifs.outerW2,notEmptyIndexesOuterTransitions]=capturingWidthHeightAndEnergy(outerVerticesPerCell,verticesOuter,pairCellValidCells,cellsInMotifNoContactValidCells);
    
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
        dataEnergyOuterNonPreservedMotifs.fourCellsMotif=dataEnergyOuterNonPreservedMotifs.fourCellsMotif(notEmptyIndexesOuterTransitions,:);
        dataEnergyOuterNonPreservedMotifs.outerH1=dataEnergyOuterNonPreservedMotifs.outerH1(notEmptyIndexesOuterTransitions);
        dataEnergyOuterNonPreservedMotifs.outerH2=dataEnergyOuterNonPreservedMotifs.outerH2(notEmptyIndexesOuterTransitions);
        dataEnergyOuterNonPreservedMotifs.outerW1=dataEnergyOuterNonPreservedMotifs.outerW1(notEmptyIndexesOuterTransitions);
        dataEnergyOuterNonPreservedMotifs.outerW2=dataEnergyOuterNonPreservedMotifs.outerW2(notEmptyIndexesOuterTransitions);
        dataEnergyOuterNonPreservedMotifs.outerSumEdgesOfEnergy=dataEnergyOuterNonPreservedMotifs.outerSumEdgesOfEnergy(notEmptyIndexesOuterTransitions);
        dataEnergyOuterNonPreservedMotifs.outerEdgeLength=dataEnergyOuterNonPreservedMotifs.outerEdgeLength(notEmptyIndexesOuterTransitions);
        dataEnergyOuterNonPreservedMotifs.outerEdgeAngle=dataEnergyOuterNonPreservedMotifs.outerEdgeAngle(notEmptyIndexesOuterTransitions);
    end
    
    
end