function [] = exportAsImageSequence(labelledImage, outputDir)
%EXPORTASIMAGESEQUENCE Summary of this function goes here
%   Detailed explanation goes here

    mkdir(outputDir);

    colours = colorcube(max(labelledImage(:))+1);
    colours(end, :) = [];
    colours = colours(randperm(max(labelledImage(:))), :);
    colours = vertcat([1 1 1], colours);
    
    figure('Visible', 'off');
    for numZ = 1:size(labelledImage, 3)
        imshow(labelledImage(:, :, numZ), colours);
        set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
        centroids = regionprops(labelledImage(:, :, numZ), 'Centroid');
        centroids = vertcat(centroids.Centroid);
        for numCentroid = 1:size(centroids, 1)
            if mean(colours(numCentroid, :)) < 0.4
                text(centroids(numCentroid, 1), centroids(numCentroid, 2), num2str(numCentroid), 'HorizontalAlignment', 'center', 'Color', 'white');
            else
                text(centroids(numCentroid, 1), centroids(numCentroid, 2), num2str(numCentroid), 'HorizontalAlignment', 'center');
            end
        end
        print(fullfile(outputDir, strcat('labelledImage_', num2str(numZ), '.tif')), '-dtiff');
        %imwrite(labelledImage(:, :, numZ), , );
    end
end

