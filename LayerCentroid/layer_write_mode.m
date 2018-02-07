function [LayerCentroid] = layer_write_mode(fig,LayerCentroid, numFrame)

newLayer1=false;

label=input('Write the number of the wrongly marked label: ');

layerOld=input('Write the old layer: ');
layerNew=input('Write the new layer: ');

x1=LayerCentroid{layerOld,1}(label,2);
y1=LayerCentroid{layerOld,1}(label,3);
Pixel = [round(x1),round(y1)];
Centroids=[x1,y1];


%The old layer is treated to remove the centroid from that layer
for numCentroidLayer=1:size(LayerCentroid{layerOld,1},1)  
    if LayerCentroid{layerOld,1}(numCentroidLayer,2:3)== Centroids
        LayerCentroid{layerOld,1}(numCentroidLayer,:)=[];
        %LayerPixel{layerOld,1}(numCentroidLayer,:)=[];
        break
    end
end


%The new layer is treated to include that centroid in that layer
if layerNew > size(LayerCentroid, 1) %If there is no layer created
    LayerCentroid{layerNew, 1} = horzcat(numFrame, Centroids);
    %LayerPixel{layerNew, 1} = horzcat(numFrame, Pixel);
    newLayer1=true;
    
else %If there is layer created
    LayerCentroid{layerNew,1}= vertcat(LayerCentroid{layerNew,1}, horzcat(numFrame,Centroids));
    %LayerPixel{layerNew,1}= vertcat(LayerPixel{layerNew,1}, horzcat(numFrame,Pixel));
end

end