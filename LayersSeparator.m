function [ LayerCentroid, LayerPixel] = LayersSeparator( photo_Path,name, initialFrame, maxFrame )

%%Variables
nameComplete=cell(maxFrame,1);
photoPath=cell(maxFrame,1);
nameNew=cell(maxFrame,1);
centroids=cell(maxFrame,1);
pixel=cell(maxFrame,1);
in=cell(maxFrame,1);
on=cell(maxFrame,1);
LayerCentroid=cell(1,1);
LayerPixel=cell(1,1);
k=cell(maxFrame,1);
maskBW=cell(maxFrame,1);
Label=cell(maxFrame,1);


for numFrame=initialFrame:maxFrame %Variable que corresponde con el nº de imágenes (frame)
    
    %Lectura de las imágenes
    nameComplete{numFrame}= [name sprintf('%02d',numFrame) '_c002.tif'];
    photoPath{numFrame}=[photo_Path '\' nameComplete{numFrame}];
    nameNew{numFrame}=[photo_Path '\' name sprintf('%02d',numFrame) 'centroid_c002'];
    
    
    [centroids{numFrame,1}, pixel{numFrame,1}, maskBW{numFrame,1}]=Centroid(photoPath{numFrame}, nameNew{numFrame});
    Label{numFrame}=bwlabel(maskBW{numFrame,1},4);
    
    if numFrame==initial
        xPixel{numFrame,1}=pixel{numFrame,1}(:, 1);
        yPixel{numFrame,1}=pixel{numFrame,1}(:, 2);
        xQuery{numFrame,1}=centroids{numFrame,1}(:, 1);
        yQuery{numFrame,1}=centroids{numFrame,1}(:, 2);
        
        [k{numFrame}]=boundary(xPixel{numFrame,1},yPixel{numFrame,1},1);
        
        [in{numFrame},on{numFrame}] = inpolygon(xQuery{numFrame,1},yQuery{numFrame,1},xPixel{numFrame,1}(k{numFrame}),yPixel{numFrame,1}(k{numFrame}));
        LayerCentroid{1}=[ones(size(xQuery{numFrame}, 1), 1) * numFrame, xQuery{numFrame,1},yQuery{numFrame,1}]; %FRAME 6
        LayerPixel{1}=[ones(size(xPixel{numFrame}, 1), 1) * numFrame, xPixel{numFrame,1},yPixel{numFrame,1}]; %FRAME 6
        
    else
        
        xPixel{numFrame,1}=pixel{numFrame,1}(:, 1);
        yPixel{numFrame,1}=pixel{numFrame,1}(:, 2);
        
        xQuery{numFrame,1}=centroids{numFrame,1}(:, 1);
        yQuery{numFrame,1}=centroids{numFrame,1}(:, 2);
        
        for numLayer=1:size(LayerCentroid, 1)
            
            x=LayerPixel{numLayer,1}(:,2);
            y=LayerPixel{numLayer,1}(:,3);
            [kLayer{numLayer}]=boundary(x,y);
            [inLayer{numLayer},onLayer{numLayer}] = inpolygon(xQuery{numFrame,1},yQuery{numFrame,1},x(kLayer{numLayer}),y(kLayer{numLayer})); %Debería ser con pixeles???
            
            oldCentroids = ismember(round(centroids{numFrame,1}),pixel{numFrame-1,1},'rows'); %Los centroides del nuevo frame que están en los pixeles del anterior
            
            for n=1:size(centroids{numFrame}(:, 1))
                if oldCentroids(n)==0
                    if (inLayer{numLayer}(n)==0) || ((inLayer{numLayer}(n)==1) && (numFrame==initial+1))
                        w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
                        LayerCentroid{numLayer} = vertcat(LayerCentroid{numLayer},horzcat(numFrame, w)); %Todos los centroides que constituye esta capa
                        LayerPixel{numLayer} = vertcat(LayerPixel{numLayer},horzcat(numFrame, w));
                        
                    elseif (inLayer{numLayer}(n)==1)
                        
                        if numLayer+1 > size(LayerCentroid, 1)
                            w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
                            LayerCentroid{numLayer+1, 1} = horzcat(numFrame, w);
                            LayerPixel{numLayer+1, 1} = horzcat(numFrame, w);
                            newLayer=true;
                            
                        elseif newLayer==true
                            w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
                            LayerCentroid{numLayer+1} = vertcat(LayerCentroid{numLayer+1},horzcat(numFrame, w));
                            LayerPixel{numLayer+1} = vertcat(LayerPixel{numLayer+1},horzcat(numFrame, w));
                            
                        end
                    end
                end
            end
        end
        
    end
    figure
    imshow(maskBW{numFrame-1});
    hold on;
    Color=colorcube;
    for numCentroidLayer=1:size(LayerCentroid, 1)
        mio=size(LayerCentroid{numCentroidLayer,1}(:, 1));
        for i=1:mio(1,1)
            plot(LayerCentroid{numCentroidLayer,1}(i,2), LayerCentroid{numCentroidLayer,1}(i, 3), '*','MarkerEdgeColor', Color(numCentroidLayer,:), 'MarkerFaceColor', Color(numCentroidLayer,:));
        end
    end
end
end

