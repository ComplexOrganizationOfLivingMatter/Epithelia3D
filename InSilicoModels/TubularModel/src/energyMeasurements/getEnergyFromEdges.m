function dataEnergy = getEnergyFromEdges( L_basal,L_apical,neighs_basal,neighs_apical,noValidCells,pairsOfCells,flag)


    [~,W_basal]=size(L_basal);
    [~,W_apical]=size(L_apical);

    
    %get couples of edges
    pairCell=cellfun(@(x, y) [y*ones(length(x),1),x],pairsOfCells',num2cell(1:size(neighs_basal,2))','UniformOutput',false);
    pairCell=unique(vertcat(pairCell{:}),'rows');
    pairCell=unique([min(pairCell,[],2),max(pairCell,[],2)],'rows');   
    
    %all vertices in basal
    [verticesBasal]=calculateVertices(L_basal,neighs_basal);
    basalVerticesPerCell=arrayfun(@(x) find(sum(x==verticesBasal.verticesConnectCells,2)), 1:max(max(L_basal)), 'UniformOutput', false);
    
    %all vertices in apical
    [verticesApical]=calculateVertices(L_apical,neighs_apical);
    apicalVerticesPerCell=arrayfun(@(x) find(sum(x==verticesApical.verticesConnectCells,2)), 1:max(max(L_apical)), 'UniformOutput', false);
    
    
    
    %vertices of edges transition in basal
    verticesOfEdgesBasal=arrayfun(@(x,y) intersect(basalVerticesPerCell{x},basalVerticesPerCell{y}), pairCell(:,1),pairCell(:,2),'UniformOutput',false);
       
    fourCellsMotifs=cellfun(@(x) unique(horzcat(verticesBasal.verticesConnectCells(x,:))),verticesOfEdgesBasal, 'UniformOutput', false);
    validPairs=cell2mat(cellfun(@(x) isempty(intersect(noValidCells,x)),fourCellsMotifs,'UniformOutput',false));
    
    fourCellsMotifsValidCells=fourCellsMotifs(validPairs,:);
    
    
    pairCellValidCells=pairCell(validPairs,:);   
    cellsInMotifNoContactValidCells=cell2mat(arrayfun(@(x) setdiff(fourCellsMotifsValidCells{x},pairCellValidCells(x,:))',1:size(pairCellValidCells,1), 'UniformOutput', false)');
    
    
    %check if the 4 cells motif are preserved in apical
    preservedMotifsInApical=cell2mat(arrayfun(@(x,y,z,zz) (sum(ismember(neighs_apical{x},[z,zz]))+sum(ismember(neighs_apical{y},[z,zz])))==4,...
        cellsInMotifNoContactValidCells(:,1),cellsInMotifNoContactValidCells(:,2),pairCellValidCells(:,1),pairCellValidCells(:,2),'UniformOutput',false));
    
    
    %we filter with the motifs that they are in contact in apical.
    pairCellValidCellsPreserved=pairCellValidCells(preservedMotifsInApical,:);
    cellsInMotifNoContactValidCellsPreserved=cellsInMotifNoContactValidCells(preservedMotifsInApical,:);
    
%     figure;
%     imshow(L_basal)
%     hold on
    
    %testing transition data
    dataEnergy.fourCellsMotif=[pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved];
    if strcmp(flag,'transition')
        [dataEnergy.basalH1,dataEnergy.basalH2,dataEnergy.basalW1,dataEnergy.basalW2,dataEnergy.basalSumEdgesOfEnergy,dataEnergy.basalEdgeLength,dataEnergy.basalEdgeAngle,notEmptyIndexesBasal]=capturingWidthHeightAndEnergy(basalVerticesPerCell,verticesBasal,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved,W_basal);
        [dataEnergy.apicalH1,dataEnergy.apicalH2,dataEnergy.apicalW1,dataEnergy.apicalW2,dataEnergy.apicalSumEdgesOfEnergy,dataEnergy.apicalEdgeLength,dataEnergy.apicalEdgeAngle,noEmptyIndexesApical]=capturingWidthHeightAndEnergy(apicalVerticesPerCell,verticesApical,cellsInMotifNoContactValidCellsPreserved,pairCellValidCellsPreserved,W_apical);        
    else
        [dataEnergy.basalH1,dataEnergy.basalH2,dataEnergy.basalW1,dataEnergy.basalW2,dataEnergy.basalSumEdgesOfEnergy,dataEnergy.basalEdgeLength,dataEnergy.basalEdgeAngle,notEmptyIndexesBasal]=capturingWidthHeightAndEnergy(basalVerticesPerCell,verticesBasal,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved,W_basal);
        [dataEnergy.apicalH1,dataEnergy.apicalH2,dataEnergy.apicalW1,dataEnergy.apicalW2,dataEnergy.apicalSumEdgesOfEnergy,dataEnergy.apicalEdgeLength,dataEnergy.apicalEdgeAngle,noEmptyIndexesApical]=capturingWidthHeightAndEnergy(apicalVerticesPerCell,verticesApical,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved,W_apical);
    end
    
    
    if sum(notEmptyIndexesBasal)< length(notEmptyIndexesBasal) || sum(noEmptyIndexesApical)< length(noEmptyIndexesApical)
        
        notEmptyIndexes=(noEmptyIndexesApical & notEmptyIndexesBasal);
        
        dataEnergy.fourCellsMotif=dataEnergy.fourCellsMotif(notEmptyIndexes,:);
        dataEnergy.apicalH1=dataEnergy.apicalH1(notEmptyIndexes);
        dataEnergy.apicalH2=dataEnergy.apicalH2(notEmptyIndexes);
        dataEnergy.apicalW1=dataEnergy.apicalW1(notEmptyIndexes);
        dataEnergy.apicalW2=dataEnergy.apicalW2(notEmptyIndexes);
        dataEnergy.apicalSumEdgesOfEnergy=dataEnergy.apicalSumEdgesOfEnergy(notEmptyIndexes);
        dataEnergy.apicalEdgeLength=dataEnergy.apicalEdgeLength(notEmptyIndexes);
        dataEnergy.apicalEdgeAngle=dataEnergy.apicalEdgeAngle(notEmptyIndexes);

        dataEnergy.basalH1=dataEnergy.basalH1(notEmptyIndexes);
        dataEnergy.basalH2=dataEnergy.basalH2(notEmptyIndexes);
        dataEnergy.basalW1=dataEnergy.basalW1(notEmptyIndexes);
        dataEnergy.basalW2=dataEnergy.basalW2(notEmptyIndexes);
        dataEnergy.basalSumEdgesOfEnergy=dataEnergy.basalSumEdgesOfEnergy(notEmptyIndexes);
        dataEnergy.basalEdgeLength=dataEnergy.basalEdgeLength(notEmptyIndexes);
        dataEnergy.basalEdgeAngle=dataEnergy.basalEdgeAngle(notEmptyIndexes);
    end
    
end

