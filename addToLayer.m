function [ LayerCentroid, LayerPixel] = addToLayer( xQuery, yQuery, numFrame, n, LayerCentroid, numLayer, LayerPixel)

w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
LayerCentroid{numLayer} = vertcat(LayerCentroid{numLayer},horzcat(numFrame, w)); %All the centroids constituting this layer
LayerPixel{numLayer} = vertcat(LayerPixel{numLayer},horzcat(numFrame, w));

end

