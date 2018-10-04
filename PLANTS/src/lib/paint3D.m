function [] = paint3D(varargin)
%PAINT3D Summary of this function goes here
%   Detailed explanation goes here
    if nargin==2 
        labelledImage=varargin{1};
        showingCells=varargin{2};
        colours = colorcube(double(max(labelledImage(:))));
        colours = colours(randperm(max(labelledImage(:))), :);
    elseif nargin == 3
        labelledImage=varargin{1};
        showingCells=varargin{2};
        colours=varargin{3};
    else
        labelledImage=varargin;
        showingCells = 1:max(labelledImage(:));
        colours = colorcube(double(max(labelledImage(:))));
        colours = colours(randperm(max(labelledImage(:))), :);
    end

    figure;
    for numSeed = unique(showingCells)'
        % Painting each cell
        [x,y,z] = ind2sub(size(labelledImage),find(labelledImage == numSeed));
        pcshow([x,y,z], colours(numSeed, :));
        hold on;
    end
end

