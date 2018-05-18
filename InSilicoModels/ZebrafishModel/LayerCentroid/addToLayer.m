function [ LayerCentroid] = addToLayer( xQuery, yQuery, numFrame, n, LayerCentroid, numLayer)
%ADDTOLAYER The coordinate of the centroid and its frame to its corresponding layer are stored in a variable.

w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
LayerCentroid{numLayer} = vertcat(LayerCentroid{numLayer},horzcat(numFrame, w)); %All the centroids constituting this layer
%LayerPixel{numLayer} = vertcat(LayerPixel{numLayer},horzcat(numFrame, round(w)));

end

