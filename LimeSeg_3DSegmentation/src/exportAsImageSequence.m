function [colours] = exportAsImageSequence(labelledImage, outputDir, colours, tipValue)
%EXPORTASIMAGESEQUENCE Summary of this function goes here
%   Detailed explanation goes here

    mkdir(outputDir);

    if exist('colours', 'var') == 0 || isempty(colours)
        colours = colorcube(max(labelledImage(:))+1);
        colours(end, :) = [];
        colours = colours(randperm(max(labelledImage(:))), :);
    end
    
    
    colours = vertcat([1 1 1], colours);
    
    h = figure('Visible', 'off');
    for numZ = 1+tipValue+1:(size(labelledImage, 3)-(tipValue+1))
        imshow(labelledImage(:, :, numZ)+1, colours);
        set(h, 'units','normalized','outerposition',[0 0 1 1]);
        centroids = regionprops(labelledImage(:, :, numZ), 'Centroid');
        centroids = vertcat(centroids.Centroid);
        ax = get(h, 'Children');
        set(ax,'Units','normalized')
        set(ax,'Position',[0 0 1 1])
        if tipValue ~= -1
            for numCentroid = 1:size(centroids, 1)
                if mean(colours(numCentroid+1, :)) < 0.4
                    text(ax, centroids(numCentroid, 1), centroids(numCentroid, 2), num2str(numCentroid), 'HorizontalAlignment', 'center', 'Color', 'white');
                else
                    text(ax, centroids(numCentroid, 1), centroids(numCentroid, 2), num2str(numCentroid), 'HorizontalAlignment', 'center');
                end
            end
        end
        h.InvertHardcopy = 'off';
        saveas(h,fullfile(outputDir, strcat('labelledImage_', num2str(numZ-(tipValue+1)), '.png')))
        %imwrite(labelledImage(:, :, numZ), , );
    end
    
    colours = colours(2:end, :);
end

