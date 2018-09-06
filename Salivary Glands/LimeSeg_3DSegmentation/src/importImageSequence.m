function [labelledImage] = importImageSequence(labelledImage, inputDir)
%IMPORTIMAGESEQUENCE Summary of this function goes here
%   Detailed explanation goes here

    for numZ = 1:size(labelledImage, 3)
        labelledImage(:, :, numZ) = imread(fullfile(inputDir, strcat('labelledImage_', num2str(numZ), '.tif')));
    end

end

