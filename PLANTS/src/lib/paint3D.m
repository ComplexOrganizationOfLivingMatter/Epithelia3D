function [] = paint3D(varargnin)
%PAINT3D Summary of this function goes here
%   Detailed explanation goes here
    if nargin==2 
        labelledImage=varargnin{1};
        showingCells=varargnin{2};
    else
        labelledImage=varargnin;
        showingCells = 1:max(labelledImage(:));
    end
    colours = colorcube(double(max(labelledImage(:))));
    colours = colours(randperm(max(labelledImage(:))), :);

    figure;
    for numSeed = showingCells
        % Painting each cell
        [x,y,z] = ind2sub(size(labelledImage),find(labelledImage == numSeed));
        pcshow([x,y,z], colours(numSeed, :));
        hold on;
    end
end

