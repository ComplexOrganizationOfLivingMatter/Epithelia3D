function [ LayerCentroid, LayerPixel, numLayer] = addToLayer( xQuery, yQuery, numFrame, n, LayerCentroid, numLayer, LayerPixel)

w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
LayerCentroid{numLayer} = vertcat(LayerCentroid{numLayer},horzcat(numFrame, w)); %Todos los centroides que constituye esta capa
LayerPixel{numLayer} = vertcat(LayerPixel{numLayer},horzcat(numFrame, w));

end

