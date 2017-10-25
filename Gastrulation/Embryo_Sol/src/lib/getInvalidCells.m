function [ invalidCells ] = getInvalidCells( img )
%GETINVALIDCELLS Summary of this function goes here
%   Detailed explanation goes here
    invalidCells = img(1:size(img, 1), 1);
    invalidCells = [invalidCells; img(1:size(img, 1), size(img, 2))];
    invalidCells = [invalidCells; img(size(img, 1), 1:size(img, 2))'];
    invalidCells = unique([invalidCells; img(1, 1:size(img, 2))']);
    
    invalidCells(invalidCells ~= 0);
end

