function [pairTotalVerticesModified] = connectVerticesOfTipCells(tipCells, pairTotalVertices, dataVertID)
%CONNECTVERTICESOFTIPCELLS Summary of this function goes here
%   Detailed explanation goes here

    for numCell = tipCells'
         actualPairOfVertices = pairTotalVertices(any(ismember(pairTotalVertices, numCell), 2), :);
    end
end

