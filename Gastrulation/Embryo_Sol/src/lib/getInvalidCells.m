function [ invalidCells ] = getInvalidCells( img )
%GETINVALIDCELLS Summary of this function goes here
%   Detailed explanation goes here
    invalidCells = img(1:size(img, 1), 1);
    invalidCells = [invalidCells; img(1:size(img, 1), size(img, 2))];
    invalidCells = [invalidCells; img(size(img, 1), 1:size(img, 2))'];
    invalidCells = [invalidCells; img(1, 1:size(img, 2))'];
    
    answer = input('InvalidRegion?(0/1) ');
    
    noValidRegion = [];
    if isequal(answer, 1)
        figure; imshow(img)
        [x,y] = getpts(gca);
        for numCell = 1:size(y, 1)
            noValidRegion = vertcat(noValidRegion, img(round(y(numCell)), round(x(numCell))));
        end
    end
    
    neighbours = calculateNeighbours(img);
    
    invalidCells = vertcat(invalidCells, neighbours{noValidRegion});
    
    invalidCells = unique(invalidCells(invalidCells ~= 0));
end

