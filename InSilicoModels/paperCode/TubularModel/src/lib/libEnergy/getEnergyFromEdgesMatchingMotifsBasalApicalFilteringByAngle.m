function dataEnergy = getEnergyFromEdgesMatchingMotifsBasalApicalFilteringByAngle(L_basal,L_apical,neighs_basal,neighs_apical,noValidCells,pairsOfCells,flag,borderCellsBasal,arrayValidVerticesBorderLeftBasal,arrayValidVerticesBorderRightBasal,borderCellsApical,arrayValidVerticesBorderLeftApical,arrayValidVerticesBorderRightApical)
    
    %initializate
    dataEnergy.fourCellsMotif=nan;
    dataEnergy.apicalEdgeLength=nan;
    dataEnergy.apicalSumEdgesOfEnergy=nan;
    dataEnergy.apicalEdgeAngle=nan;            
    dataEnergy.apicalH1=nan;
    dataEnergy.apicalH2=nan;
    dataEnergy.apicalW1=nan;
    dataEnergy.apicalW2=nan;

    dataEnergy.basalEdgeLength=nan;
    dataEnergy.basalSumEdgesOfEnergy=nan;
    dataEnergy.basalEdgeAngle=nan;
    dataEnergy.basalH1=nan;
    dataEnergy.basalH2=nan;
    dataEnergy.basalW1=nan;
    dataEnergy.basalW2=nan;

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
    validPairs1=cell2mat(cellfun(@(x) isempty(intersect(noValidCells,x)) & length(x)==4 ,fourCellsMotifs,'UniformOutput',false));
    
    fourCellsMotifsValidCells=fourCellsMotifs(validPairs1,:);
    
    pairCellValidCells=pairCell(validPairs1,:);
    
    cellsInMotifContactingCellsEdge=arrayfun(@(x) setdiff(fourCellsMotifsValidCells{x},pairCellValidCells(x,:))',1:size(pairCellValidCells,1), 'UniformOutput', false);
    
    %deleting incoherences with motif of 5 or 3 cells
    validPairs2=cell2mat(cellfun(@(x) length(x)==2,cellsInMotifContactingCellsEdge,'UniformOutput',false))';
    cellsInMotifContactingCellsEdge=cell2mat(cellsInMotifContactingCellsEdge(validPairs2)');
    pairCellValidCells=pairCellValidCells(validPairs2,:);
       
    
    if sum(validPairs2)>0
        
    
        %check if the 4 cells motif are preserved in apical
        preservedMotifsInApical=cell2mat(arrayfun(@(x,y,z,zz) (sum(ismember(neighs_apical{x},[z,zz]))+sum(ismember(neighs_apical{y},[z,zz])))==4,...
            cellsInMotifContactingCellsEdge(:,1),cellsInMotifContactingCellsEdge(:,2),pairCellValidCells(:,1),pairCellValidCells(:,2),'UniformOutput',false));


        %we filter with the motifs that they are in contact in apical.
        pairCellValidCellsPreserved=pairCellValidCells(preservedMotifsInApical,:);
        cellsInMotifNoContactValidCellsPreserved=cellsInMotifContactingCellsEdge(preservedMotifsInApical,:);

    %     figure;
    %     imshow(L_basal)
    %     hold on

        if size(pairCellValidCellsPreserved,1)>0
            %testing transition data
            dataEnergy.fourCellsMotif=[pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved];

            [dataEnergy.basalEdgeLength,dataEnergy.basalSumEdgesOfEnergy,dataEnergy.basalEdgeAngle,dataEnergy.basalH1,dataEnergy.basalH2,dataEnergy.basalW1,dataEnergy.basalW2,notEmptyIndexesBasal]=capturingWidthHeightAndEnergyFilteringAnglesOfMotifs(basalVerticesPerCell,verticesBasal,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved,W_basal,borderCellsBasal,arrayValidVerticesBorderLeftBasal,arrayValidVerticesBorderRightBasal);
            if strcmp(flag,'transition')
                [dataEnergy.apicalEdgeLength,dataEnergy.apicalSumEdgesOfEnergy,dataEnergy.apicalEdgeAngle,dataEnergy.apicalH1,dataEnergy.apicalH2,dataEnergy.apicalW1,dataEnergy.apicalW2,notEmptyIndexesApical]=capturingWidthHeightAndEnergyFilteringAnglesOfMotifs(apicalVerticesPerCell,verticesApical,cellsInMotifNoContactValidCellsPreserved,pairCellValidCellsPreserved,W_apical,borderCellsApical,arrayValidVerticesBorderLeftApical,arrayValidVerticesBorderRightApical);       
            else
                [dataEnergy.apicalEdgeLength,dataEnergy.apicalSumEdgesOfEnergy,dataEnergy.apicalEdgeAngle,dataEnergy.apicalH1,dataEnergy.apicalH2,dataEnergy.apicalW1,dataEnergy.apicalW2,notEmptyIndexesApical]=capturingWidthHeightAndEnergyFilteringAnglesOfMotifs(apicalVerticesPerCell,verticesApical,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved,W_apical,borderCellsApical,arrayValidVerticesBorderLeftApical,arrayValidVerticesBorderRightApical);
            end


            if sum(notEmptyIndexesBasal)< length(notEmptyIndexesBasal) || sum(notEmptyIndexesApical)< length(notEmptyIndexesApical)

                notEmptyIndexes=(notEmptyIndexesApical & notEmptyIndexesBasal);

                dataEnergy.fourCellsMotif=dataEnergy.fourCellsMotif(notEmptyIndexes,:);

                dataEnergy.basalEdgeLength=dataEnergy.basalEdgeLength(notEmptyIndexes);
                dataEnergy.basalSumEdgesOfEnergy=dataEnergy.basalSumEdgesOfEnergy(notEmptyIndexes);
                dataEnergy.basalEdgeAngle=dataEnergy.basalEdgeAngle(notEmptyIndexes);
                dataEnergy.basalH1=dataEnergy.basalH1(notEmptyIndexes);
                dataEnergy.basalH2=dataEnergy.basalH2(notEmptyIndexes);
                dataEnergy.basalW1=dataEnergy.basalW1(notEmptyIndexes);
                dataEnergy.basalW2=dataEnergy.basalW2(notEmptyIndexes);

                dataEnergy.apicalEdgeLength=dataEnergy.apicalEdgeLength(notEmptyIndexes);
                dataEnergy.apicalSumEdgesOfEnergy=dataEnergy.apicalSumEdgesOfEnergy(notEmptyIndexes);
                dataEnergy.apicalEdgeAngle=dataEnergy.apicalEdgeAngle(notEmptyIndexes);
                dataEnergy.apicalH1=dataEnergy.apicalH1(notEmptyIndexes);
                dataEnergy.apicalH2=dataEnergy.apicalH2(notEmptyIndexes);
                dataEnergy.apicalW1=dataEnergy.apicalW1(notEmptyIndexes);
                dataEnergy.apicalW2=dataEnergy.apicalW2(notEmptyIndexes);
                          
            end
        end          
    end
end

