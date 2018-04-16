function [ dataEnergyNonPreservedMotifs ] = getEnergyInNonPreservedMotifsAngleThreshold( outerVerticesPerCell,verticesOuter,pairCellValidCells,cellsInMotifNoContactValidCells )

    dataEnergyNonPreservedMotifs.fourCellsMotif=[pairCellValidCells,cellsInMotifNoContactValidCells];

    %testing transitions data (without filtering with preserved in inner)
    [dataEnergyNonPreservedMotifs.outerEdgeLength,dataEnergyNonPreservedMotifs.outerSumEdgesOfEnergy,dataEnergyNonPreservedMotifs.outerEdgeAngle,dataEnergyNonPreservedMotifs.outerH1,dataEnergyNonPreservedMotifs.outerH2,dataEnergyNonPreservedMotifs.outerW1,dataEnergyNonPreservedMotifs.outerW2,notEmptyIndexesOuterTransitions]=capturingWidthHeightAndEnergyAngleThreshold(outerVerticesPerCell,verticesOuter,pairCellValidCells,cellsInMotifNoContactValidCells);  
    
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

