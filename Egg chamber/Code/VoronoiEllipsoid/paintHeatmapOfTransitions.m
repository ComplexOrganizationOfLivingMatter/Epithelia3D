function [ ] = paintHeatmapOfTransitions( ellipsoidInfo, initialNeighbourhood )
%PAINTHEATMAPOFTRANSITIONS Summary of this function goes here
%   Detailed explanation goes here

    transitionsPerCell = cellfun(@(x, y) size(setxor(x, y), 1), ellipsoidInfo.neighbourhood, initialNeighbourhood);
    
    figure('Visible', 'off');
    clmap = hot(10);
    clmap = clmap(size(clmap, 1):-1:1, :);
    ncl = size(clmap,1);

    for cellIndex = 1:size(ellipsoidInfo.verticesPerCell, 1)
        cl = clmap(mod(transitionsPerCell(cellIndex),ncl)+1,:);
        VertCell = ellipsoidInfo.verticesPerCell{cellIndex};
        KVert = convhulln([VertCell; ellipsoidInfo.finalCentroids(cellIndex, :)]);
        patch('Vertices',[VertCell; ellipsoidInfo.finalCentroids(cellIndex, :)],'Faces', KVert,'FaceColor', cl ,'FaceAlpha', 1, 'EdgeColor', 'none')
        hold on;
    end
    axis equal
end

