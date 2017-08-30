function [ LayerCentroid, LayerPixel ] = SearchOfLayers( numLayer, numFrame, xQuery, yQuery, n, LayerCentroid, LayerPixel, inLayer )

for numLayers=2:(numLayer-1)
    if inLayer{numLayers}(n)==0
        w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
        LayerCentroid{numLayers} = vertcat(LayerCentroid{numLayers},horzcat(numFrame, w));
        LayerPixel{numLayers} = vertcat(LayerPixel{numLayers},horzcat(numFrame, w));
    elseif inLayer{numLayers}(n)==1
        numLayers=numLayers+1;
    end
end
end

