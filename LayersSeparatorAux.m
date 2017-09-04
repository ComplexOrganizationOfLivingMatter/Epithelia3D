function [ LayerCentroid, LayerPixel ] = LayersSeparatorAux( archMat, initialFrame, maxFrame,photo_Path,name )
load(archMat);
varargin
%newLayer=false;
for numFrame=initialFrame:maxFrame
    %Lectura de las imágenes
    nameComplete{numFrame}= [name sprintf('%02d',numFrame) '_c002.tif'];
    photoPath{numFrame}=[photo_Path '\' nameComplete{numFrame}];
    nameNew{numFrame}=[photo_Path '\' name sprintf('%02d',numFrame) 'centroid_c002'];
    
    [centroids{numFrame,1}, pixel{numFrame,1}, maskBW{numFrame,1}]=Centroid(photoPath{numFrame}, nameNew{numFrame});
    
    xPixel{numFrame,1}=pixel{numFrame,1}(:, 1);
    yPixel{numFrame,1}=pixel{numFrame,1}(:, 2);
    xQuery{numFrame,1}=centroids{numFrame,1}(:, 1);
    yQuery{numFrame,1}=centroids{numFrame,1}(:, 2);
    oldCentroids = ismember(round(centroids{numFrame,1}),pixel{numFrame-1,1},'rows'); %Los centroides del nuevo frame que están en los pixeles del anterior
    
    for numLayer=1:size(LayerCentroid, 1)
        
        x=LayerPixel{numLayer,1}(:,2);
        y=LayerPixel{numLayer,1}(:,3);
        
        for n=1:size(centroids{numFrame}(:, 1))
            
            if oldCentroids(n)==0 %Para que no coja los repetidos
                oldCentroids(n) = 1; %Cuando solo cojo los centroides no repetidos (0) pongo ese numero a 1 para que no me lo vuelva a coger en la siguiente repetición
                
                if size(LayerCentroid{numLayer,1},1)<4 %Si hay menos de 3 centroides en la capa entonces
                    [LayerCentroid, LayerPixel, numLayer] = addToLayer( xQuery, yQuery, numFrame, n, LayerCentroid, numLayer, LayerPixel);
                    
                else
                    
                    [kLayer{numLayer}]=boundary(x,y,0.8);
                    [inLayer{numLayer},onLayer{numLayer}] = inpolygon(xQuery{numFrame,1},yQuery{numFrame,1},x(kLayer{numLayer}),y(kLayer{numLayer}));
                    
                    if (inLayer{numLayer}(n)==0) || ((inLayer{numLayer}(n)==1) && (numFrame==initialFrame+1))
                        if(inLayer{1}(n)==1)
                            [LayerCentroid, LayerPixel, numLayer] = addToLayer( xQuery, yQuery, numFrame, n, LayerCentroid, numLayer, LayerPixel);
                        elseif(inLayer{1}(n)==0)
                            w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
                            LayerCentroid{1} = vertcat(LayerCentroid{1},horzcat(numFrame, w));
                            LayerPixel{1} = vertcat(LayerPixel{1},horzcat(numFrame, w));
                        end
                    elseif (inLayer{numLayer}(n)==1)
                        if numLayer+1 > size(LayerCentroid, 1) %Si no hay capa creada
                            w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
                            LayerCentroid{numLayer+1, 1} = horzcat(numFrame, w);
                            LayerPixel{numLayer+1, 1} = horzcat(numFrame, w);
                            
                        else
                            if size(LayerCentroid{numLayer+1,1},1)<4
                                w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
                                LayerCentroid{numLayer+1} = vertcat(LayerCentroid{numLayer+1},horzcat(numFrame, w));
                                LayerPixel{numLayer+1} = vertcat(LayerPixel{numLayer+1},horzcat(numFrame, w));
                                
                            else
                                %Se deberia alacenar para cuando pase
                                %de capa se analice y así sucesivamente
                                oldCentroids(n) = 0; %Lo vuelvo a poner a 0 pork en la siguiente capa quiero que analice otra vez este centroide
                            end
                            
                        end
                    end
                end
            end
        end
        
    end
    
    
    %%Representación de los centroides de las diferentes capas
    f=figure('Visible', 'on');
    nameCompleteLayer{numFrame}= [name sprintf('%02d',numFrame) '_c001.tif'];
    photoPathLayer{numFrame}=['C:\Users\tinaf\OneDrive\Documentos\Departamento\Epithelia3D\50epib_2' '\' nameCompleteLayer{numFrame}];
    imshow(photoPathLayer{numFrame});
    %         imshow(maskBW{numFrame-1});
    hold on;
    Color=colorcube(10);
    
    %if size(LayerCentroid(:, 1),1)>6
    for numCentroidLayer=1:size(LayerCentroid, 1)
        mio=size(LayerCentroid{numCentroidLayer,1}(:, 1));
        for i=1:mio(1,1)
            %text(LayerCentroid{numCentroidLayer,1}(i,2), LayerCentroid{numCentroidLayer,1}(i, 3),sprintf('%d',numCentroidLayer),'HorizontalAlignment','center','VerticalAlignment','middle','Color',Color(numCentroidLayer,:),'FontSize',9);
            numLay(numCentroidLayer,:)=plot(LayerCentroid{numCentroidLayer,1}(i,2), LayerCentroid{numCentroidLayer,1}(i, 3), '*','MarkerEdgeColor', Color(numCentroidLayer,:), 'MarkerFaceColor', Color(numCentroidLayer,:));
        end
        numLay1{numCentroidLayer}=sprintf ('Layer%d', numCentroidLayer);
    end
    %end
    
    legend(numLay,numLay1);
    
    % Merge images to return
    nameLayer=[photo_Path '\Layers\' name sprintf('%02d',numFrame) 'centroid_layers.jpg'];
    saveas(f,nameLayer);
    
    %%Tratamiento de las capas
    % Display labels in screen
    want_modify=input('1 (change labelling mode) \n 0 (Next frame): ');
    want_modify_more =1;
    
    while want_modify_more ==1
        switch want_modify
            case 0
                disp('Next frame');
                break
            case 1
                f = display_labelled (f, LayerCentroid);
                [LayerCentroid, LayerPixel] = layer_write_mode(f,LayerCentroid, LayerPixel, numFrame);
        end
        want_modify_more=input('Do you want to make more changes? 1 (yes) \n 0 (no) \n:');
    end
    
    
    close all;

    
end
save('LayersCentroids.mat', 'LayerCentroid', 'LayerPixel', 'centroids', 'pixel')
end

