function [ dataEnergy ] = getEnergyFromAllMotifs(L_basal,neighs,noValidCells)

    [~,W]=size(L_basal);

    %get couples of edges
    pairCell=cellfun(@(x, y) [y*ones(length(x),1),x],neighs',num2cell(1:size(neighs,2))','UniformOutput',false);
    pairCell=unique(vertcat(pairCell{:}),'rows');
    pairCell=unique([min(pairCell,[],2),max(pairCell,[],2)],'rows');   
        
    %all vertices in basal
    [vertices]=calculateVertices(L_basal,neighs);
    verticesPerCell=arrayfun(@(x) find(sum(x==vertices.verticesConnectCells,2)), 1:max(max(L_basal)), 'UniformOutput', false);
    
       
    %% BASAL
    %vertices of edges transition in basal
    verticesOfEdges=arrayfun(@(x,y) intersect(verticesPerCell{x},verticesPerCell{y}), pairCell(:,1),pairCell(:,2),'UniformOutput',false);
    fourCellsMotifs=cellfun(@(x) unique(horzcat(vertices.verticesConnectCells(x,:))),verticesOfEdges, 'UniformOutput', false);
    validPairs1=cell2mat(cellfun(@(x) isempty(intersect(noValidCells,x)) & length(x)==4 ,fourCellsMotifs,'UniformOutput',false));
    fourCellsMotifsValidCells=fourCellsMotifs(validPairs1,:);
    pairCellValidCells=pairCell(validPairs1,:);
    cellsInMotifContactingCellsEdge=arrayfun(@(x) setdiff(fourCellsMotifsValidCells{x},pairCellValidCells(x,:))',1:size(pairCellValidCells,1), 'UniformOutput', false);
    
    %deleting incoherences with motif of 5 or 3 cells
    validPairs2=cell2mat(cellfun(@(x) length(x)==2,cellsInMotifContactingCellsEdge,'UniformOutput',false))';
    cellsInMotifContactingCellsEdge=cell2mat(cellsInMotifContactingCellsEdge(validPairs2)');
    pairCellValidCells=pairCellValidCells(validPairs2,:);

    
    %testing transition data
    dataEnergy.fourCellsMotif=[pairCellValidCells,cellsInMotifContactingCellsEdge];
    
    [dataEnergy.EdgeLength,dataEnergy.SumEdgesOfEnergy,dataEnergy.EdgeAngle,dataEnergy.H1,dataEnergy.H2,dataEnergy.W1,dataEnergy.W2,notEmptyIndexes]=capturingWidthHeightAndEnergy(verticesPerCell,vertices,pairCellValidCells,cellsInMotifContactingCellsEdge,W);
    
    

end

