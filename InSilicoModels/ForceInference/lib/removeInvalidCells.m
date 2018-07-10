function [forceInference] = removeInvalidCells(forceInference)
%REMOVEINVALIDCELLS Summary of this function goes here
%   Detailed explanation goes here
borderCells = forceInference.RealSides ~= forceInference.NumEdgesOfTension;
forceInference(borderCells, :) = [];
end

