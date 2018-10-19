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
        labelledImage=varargin{1};
        showingCells = (1:max(labelledImage(:)))';
        colours = colorcube(double(max(labelledImage(:))));
        colours = colours(randperm(max(labelledImage(:))), :);
    end

    if isempty(showingCells)
        showingCells = (1:max(labelledImage(:)));
    end
    if isempty(colours)
        colours = colorcube(double(max(labelledImage(:))));
        colours = colours(randperm(max(labelledImage(:))), :);
    end
    figure;

    if size(unique(showingCells),1) > size(unique(showingCells),2)
        showingCells = unique(showingCells)';
    else
        showingCells = unique(showingCells);
    end

    for numSeed = showingCells
        % Painting each cell
        [x,y,z] = ind2sub(size(labelledImage),find(labelledImage == numSeed));
        pcshow([x,y,z], colours(numSeed, :));
        hold on;
    end
end

