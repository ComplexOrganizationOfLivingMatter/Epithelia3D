function [] = paint3D(labelledImage)
%PAINT3D Summary of this function goes here
%   Detailed explanation goes here

    colours = colorcube(max(labelledImage(:)));
    colours = colours(randperm(max(labelledImage(:))), :);
    figure;
    for numSeed = 1:max(labelledImage(:))
        % Painting each cell
        [x,y,z] = ind2sub(size(labelledImage),find(labelledImage == numSeed));
        pcshow([x,y,z], colours(numSeed, :));
        hold on;
    end
end

