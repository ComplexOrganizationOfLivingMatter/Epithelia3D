function [dataEnergy,dataEnergyNonPreservedMotifs,dataEnergyAngleThreshold,dataEnergyNonPreservedMotifsAngleThreshold,numberOfValidMotifs] = getEnergyFromEdges( outerProjection,innerProjection,neighsOuter,neighsInner,noValidCells,validCells,pairsOfCells,flag)

    %all vertices in outer surface
    [verticesOuter]=calculateVertices(outerProjection,neighsOuter);
    outerVerticesPerCell=arrayfun(@(x) find(sum(x==verticesOuter.verticesConnectCells,2)), 1:max(max(outerProjection)), 'UniformOutput', false);
        
    %all vertices in outer surface
    [verticesInner]=calculateVertices(innerProjection,neighsInner);
    innerVerticesPerCell=arrayfun(@(x) find(sum(x==verticesInner.verticesConnectCells,2)), 1:max(max(outerProjection)), 'UniformOutput', false);
        
    
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
        dataEnergyAngleThreshold = [];
        dataEnergyNonPreservedMotifsAngleThreshold = [];
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
    


    %getting energy in the preserved motifs
    [ dataEnergy ] = getEnergyInPreservedMotifs(innerVerticesPerCell,verticesInner,outerVerticesPerCell,verticesOuter,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved,flag);
    %getting energy in the non preserved motifs
    [ dataEnergyNonPreservedMotifs ] = getEnergyInNonPreservedMotifs( outerVerticesPerCell,verticesOuter,pairCellValidCells,cellsInMotifNoContactValidCells );
    
    %getting energy in the preserved motifs with angle threshold
    [ dataEnergyAngleThreshold ] = getEnergyInPreservedMotifsAngleThreshold(innerVerticesPerCell,verticesInner,outerVerticesPerCell,verticesOuter,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved,flag);
    %getting energy in the non preserved motifs
    [ dataEnergyNonPreservedMotifsAngleThreshold ] = getEnergyInNonPreservedMotifsAngleThreshold( outerVerticesPerCell,verticesOuter,pairCellValidCells,cellsInMotifNoContactValidCells );
    
    
   
    
    
    
end