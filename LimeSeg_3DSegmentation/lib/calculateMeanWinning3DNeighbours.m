function [meanWinningPerSide] = calculateMeanWinning3DNeighbours(numNeighAccumPerSurfacesRealization, validCells)
%CALCULATEMEANWINNING3DNEIGHBOURS Calculate winning neighbours in 3D per number of sides
%   Detailed explanation goes here
%Scutoids per number of sides
    numNeighAccumPerSurfacesRealizationValid = numNeighAccumPerSurfacesRealization(validCells, :);
    numberOfSides = 1:10;
    [~, sidesCorrespondance] = ismember(numNeighAccumPerSurfacesRealizationValid(:, 1), numberOfSides);
    winningNeighbours = numNeighAccumPerSurfacesRealizationValid - numNeighAccumPerSurfacesRealizationValid(:, 1);
   
    for numNumberOfSide = 1:length(numberOfSides)
        %numNumberOfSide
        %sum(sidesCorrespondance == numNumberOfSide)
        meanWinningPerSide(numNumberOfSide, :) = mean(winningNeighbours(sidesCorrespondance == numNumberOfSide, :), 1);
    end
end

