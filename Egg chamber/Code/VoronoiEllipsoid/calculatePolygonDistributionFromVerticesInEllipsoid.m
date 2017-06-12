function [ polygonDistribution, neighbourhood ] = calculatePolygonDistributionFromVerticesInEllipsoid(centroids, verticesPerCell )
%CALCULATEPOLYGONDISTRIBUTIONFROMVERTICESINELLIPSOID Summary of this function goes here
%   Detailed explanation goes here

    %Firstly, we get the neighbourhood
    neighbourhood = cell(length(verticesPerCell), 1);
    polygonDistribution = zeros(length(verticesPerCell), 1);
    for cellIndex = 1:length(verticesPerCell)
        actualCell = verticesPerCell{cellIndex};
        actualNeighbours = find(cellfun(@(otherCell) any(ismember(actualCell, otherCell, 'rows')), verticesPerCell));
        neighbourhood(cellIndex) = {actualNeighbours(actualNeighbours ~= cellIndex)};
        polygonDistribution(cellIndex) = length(actualNeighbours(actualNeighbours ~= cellIndex));
        text(centroids(cellIndex, 1), centroids(cellIndex, 2), centroids(cellIndex, 3), num2str(polygonDistribution(cellIndex)));
    end
end

