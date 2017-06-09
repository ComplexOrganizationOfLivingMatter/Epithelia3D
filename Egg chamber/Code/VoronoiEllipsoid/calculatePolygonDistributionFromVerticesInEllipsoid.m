function [ polygonDistribution, neighbourhood ] = calculatePolygonDistributionFromVerticesInEllipsoid( verticesPerCell )
%CALCULATEPOLYGONDISTRIBUTIONFROMVERTICESINELLIPSOID Summary of this function goes here
%   Detailed explanation goes here

    %Firstly, we get the neighbourhood
    neighbourhood = cell(length(verticesPerCell), 1);
    polygonDistribution = zeros(length(verticesPerCell), 1);
    parfor cellIndex = 1:length(verticesPerCell)
        actualCell = verticesPerCell{cellIndex};
        actualNeighbours = find(cellfun(@(otherCell) any(ismember(actualCell, otherCell, 'rows')), verticesPerCell));
        neighbourhood(cellIndex) = {actualNeighbours(actualNeighbours ~= cellIndex)};
        polygonDistribution(cellIndex) = length(actualNeighbours(actualNeighbours ~= cellIndex));
    end
    polygonDistribution
end

