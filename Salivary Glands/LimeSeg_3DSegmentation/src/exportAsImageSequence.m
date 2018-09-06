function [] = exportAsImageSequence(labelledImage, outputDir)
%EXPORTASIMAGESEQUENCE Summary of this function goes here
%   Detailed explanation goes here

    mkdir(outputDir);

    colours = colorcube(max(labelledImage(:))+1);
    colours(end, :) = [];
    colours = colours(randperm(max(labelledImage(:))), :);
    colours = vertcat([1 1 1], colours);
    
    for numZ = 1:size(labelledImage, 3)
        imwrite(labelledImage(:, :, numZ), colours, fullfile(outputDir, strcat('labelledImage_', num2str(numZ), '.tif')));
    end
end

