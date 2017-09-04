function [LayerCentroid, LayerPixel] = layer_write_mode(fig,LayerCentroid, LayerPixel, numFrame)

newLayer1=false;

label=input('Write the number of the wrongly marked label: ');

labelOld=input('Write the old label: ');
labelNew=input('Write the new label: ');

x1=LayerCentroid{labelOld,1}(label,2);
y1=LayerCentroid{labelOld,1}(label,3);
Pixel = [round(x1),round(y1)];%x1=round(x1);y1=round(y1);
Centroids=[x1,y1];


%Se trata la capa antigua para elimitar ese centroide de esa capa
for numCentroidLayer=1:size(LayerCentroid{labelOld,1},1)
    
    if LayerCentroid{labelOld,1}(numCentroidLayer,:)== horzcat(numFrame,Centroids)
        LayerCentroid{labelOld,1}(numCentroidLayer,:)=[];
        LayerPixel{labelOld,1}(numCentroidLayer,:)=[];
    end
end

%Se trata la capa nueva para incluir ese centroide en esa capa

if labelNew > size(LayerCentroid, 1) %Si no hay capa creada 
    LayerCentroid{labelNew, 1} = horzcat(numFrame, Centroids);
    LayerPixel{labelNew, 1} = horzcat(numFrame, Pixel);
    newLayer1=true;
    
elseif newLayer1==true %Hay capa creada
    LayerCentroid{labelNew,1}= vertcat(LayerCentroid{labelNew,1}, horzcat(numFrame,Centroids));
    LayerPixel{labelNew,1}= vertcat(LayerPixel{labelNew,1}, horzcat(numFrame,Pixel));
end

end