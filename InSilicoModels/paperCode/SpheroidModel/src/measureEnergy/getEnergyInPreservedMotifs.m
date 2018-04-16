function [ dataEnergy ] = getEnergyInPreservedMotifs( innerVerticesPerCell,verticesInner,outerVerticesPerCell,verticesOuter,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved,flag )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    dataEnergy.fourCellsMotif=[pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved];

    [dataEnergy.outerEdgeLength,dataEnergy.outerSumEdgesOfEnergy,dataEnergy.outerEdgeAngle,dataEnergy.outerH1,dataEnergy.outerH2,dataEnergy.outerW1,dataEnergy.outerW2,notEmptyIndexesOuter]=capturingWidthHeightAndEnergy(outerVerticesPerCell,verticesOuter,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved);
    if strcmp(flag,'transition')
        [dataEnergy.innerEdgeLength,dataEnergy.innerSumEdgesOfEnergy,dataEnergy.innerEdgeAngle,dataEnergy.innerH1,dataEnergy.innerH2,dataEnergy.innerW1,dataEnergy.innerW2,noEmptyIndexesInner]=capturingWidthHeightAndEnergy(innerVerticesPerCell,verticesInner,cellsInMotifNoContactValidCellsPreserved,pairCellValidCellsPreserved);        
    else
        [dataEnergy.innerEdgeLength,dataEnergy.innerSumEdgesOfEnergy,dataEnergy.innerEdgeAngle,dataEnergy.innerH1,dataEnergy.innerH2,dataEnergy.innerW1,dataEnergy.innerW2,noEmptyIndexesInner]=capturingWidthHeightAndEnergy(innerVerticesPerCell,verticesInner,pairCellValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved);
    end

    if sum(notEmptyIndexesOuter)< length(notEmptyIndexesOuter) || sum(noEmptyIndexesInner)< length(noEmptyIndexesInner)
        
        validIndexes=(noEmptyIndexesInner & notEmptyIndexesOuter);
        
        dataEnergy.fourCellsMotif=dataEnergy.fourCellsMotif(validIndexes,:);
        dataEnergy.innerH1=dataEnergy.innerH1(validIndexes);
        dataEnergy.innerH2=dataEnergy.innerH2(validIndexes);
        dataEnergy.innerW1=dataEnergy.innerW1(validIndexes);
        dataEnergy.innerW2=dataEnergy.innerW2(validIndexes);
        dataEnergy.innerSumEdgesOfEnergy=dataEnergy.innerSumEdgesOfEnergy(validIndexes);
        dataEnergy.innerEdgeLength=dataEnergy.innerEdgeLength(validIndexes);
        dataEnergy.innerEdgeAngle=dataEnergy.innerEdgeAngle(validIndexes);

        dataEnergy.outerH1=dataEnergy.outerH1(validIndexes);
        dataEnergy.outerH2=dataEnergy.outerH2(validIndexes);
        dataEnergy.outerW1=dataEnergy.outerW1(validIndexes);
        dataEnergy.outerW2=dataEnergy.outerW2(validIndexes);
        dataEnergy.outerSumEdgesOfEnergy=dataEnergy.outerSumEdgesOfEnergy(validIndexes);
        dataEnergy.outerEdgeLength=dataEnergy.outerEdgeLength(validIndexes);
        dataEnergy.outerEdgeAngle=dataEnergy.outerEdgeAngle(validIndexes);
    end
    
    
end

