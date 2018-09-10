function [] = paint3D(labelledImage, showingCells, colours)
%PAINT3D Summary of this function goes here
%   Detailed explanation goes here

    if exist('colours', 'var') == 0 || isempty(colours)
        colours = colorcube(max(labelledImage(:))+1);
        colours(end, :) = [];
        colours = colours(randperm(max(labelledImage(:))), :);
        colours = vertcat([1 1 1], colours);
    end
    if exist('showingCells', 'var') == 0 || isempty(showingCells)
        showingCells = 1:max(labelledImage(:));
    end
    % figure;
    
    for numSeed = showingCells
        if numSeed >= 0
            % Painting each cell
            [x,y,z] = ind2sub(size(labelledImage),find(labelledImage == numSeed));
            pcshow([x,y,z], colours(numSeed+1, :));
            hold on;
        end
    end
end

