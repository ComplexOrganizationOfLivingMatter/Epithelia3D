function dataEnergy = getEnergyFromEdgesInFrusta( L_img,neighs,noValidCells,verticesApical,verticesProjection,surfaceRatio,borderCells,arrayValidVerticesBorderLeft,arrayValidVerticesBorderRight)

    
    [~,W]=size(L_img);
    W_projection=round(W*surfaceRatio);
    %get couples of edges
    pairCell=cellfun(@(x, y) [y*ones(length(x),1),x],neighs',num2cell(1:size(neighs,2))','UniformOutput',false);
    pairCell=unique(vertcat(pairCell{:}),'rows');
    pairCell=unique([min(pairCell,[],2),max(pairCell,[],2)],'rows');   
    
    %all vertices in basal
    projectionVerticesPerCell=arrayfun(@(x) find(sum(x==verticesProjection.verticesConnectCells,2)), 1:max(max(L_img)), 'UniformOutput', false);
       
    %vertices of edges transition in basal
    verticesOfEdgesProjection=arrayfun(@(x,y) intersect(projectionVerticesPerCell{x},projectionVerticesPerCell{y}), pairCell(:,1),pairCell(:,2),'UniformOutput',false);
    fourCellsMotifs=cellfun(@(x) unique(horzcat(verticesProjection.verticesConnectCells(x,:))),verticesOfEdgesProjection, 'UniformOutput', false);
    validPairs1=cell2mat(cellfun(@(x) isempty(intersect(noValidCells,x)) & length(x)==4 ,fourCellsMotifs,'UniformOutput',false));
    fourCellsMotifsValidCells=fourCellsMotifs(validPairs1,:);
    pairCellValidCells=pairCell(validPairs1,:);
    cellsInMotifContactingCellsEdge=arrayfun(@(x) setdiff(fourCellsMotifsValidCells{x},pairCellValidCells(x,:))',1:size(pairCellValidCells,1), 'UniformOutput', false);
    
    %deleting incoherences with motif of 5 or 3 cells
    validPairs2=cell2mat(cellfun(@(x) length(x)==2,cellsInMotifContactingCellsEdge,'UniformOutput',false))';
    cellsInMotifContactingCellsEdge=cell2mat(cellsInMotifContactingCellsEdge(validPairs2)');
    pairCellValidCells=pairCellValidCells(validPairs2,:);
       
    %check if the 4 cells motif are preserved in apical
    preservedMotifsInApical=cell2mat(arrayfun(@(x,y,z,zz) (sum(ismember(neighs{x},[z,zz]))+sum(ismember(neighs{y},[z,zz])))==4,...
        cellsInMotifContactingCellsEdge(:,1),cellsInMotifContactingCellsEdge(:,2),pairCellValidCells(:,1),pairCellValidCells(:,2),'UniformOutput',false));
   
    
    %we filter with the motifs that they are in contact in apical.
    pairCellValidCellsPreserved=pairCellValidCells(preservedMotifsInApical,:);
    cellsInMotifNoContactValidCellsPreserved=cellsInMotifContactingCellsEdge(preservedMotifsInApical,:);
    
   
    %testing transition data
    dataEnergy.fourCellsMotif=[pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved];
    
    [dataEnergy.EdgeLength,dataEnergy.SumEdgesOfEnergy,dataEnergy.EdgeAngle,dataEnergy.H1,dataEnergy.H2,dataEnergy.W1,dataEnergy.W2,notEmptyIndexes]=capturingWidthHeightAndEnergy(projectionVerticesPerCell,verticesProjection,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved,W_projection,borderCells,arrayValidVerticesBorderLeft,arrayValidVerticesBorderRight);
   
    dataEnergy.fourCellsMotif=dataEnergy.fourCellsMotif(notEmptyIndexes,:);
    dataEnergy.H1=dataEnergy.H1(notEmptyIndexes);
    dataEnergy.H2=dataEnergy.H2(notEmptyIndexes);
    dataEnergy.W1=dataEnergy.W1(notEmptyIndexes);
    dataEnergy.W2=dataEnergy.W2(notEmptyIndexes);
    dataEnergy.SumEdgesOfEnergy=dataEnergy.SumEdgesOfEnergy(notEmptyIndexes);
    dataEnergy.EdgeLength=dataEnergy.EdgeLength(notEmptyIndexes);
    dataEnergy.EdgeAngle=dataEnergy.EdgeAngle(notEmptyIndexes);
    
    
end

