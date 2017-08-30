function [ LayerCentroid, LayerPixel] = LayersSeparator( photo_Path,name, initialFrame, maxFrame )

%%Variables

% photo_Path='C:\Users\tinaf\OneDrive\Documentos\Departamento\Epithelia3D\Prueba2';
% name='50epib_2_z0';
% initialFrame=6;
% maxFrame=48;
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

for numFrame=initialFrame:maxFrame %Variable que corresponde con el n� de im�genes (frame)
    
    %Lectura de las im�genes
    nameComplete{numFrame}= [name sprintf('%02d',numFrame) '_c002.tif'];
    photoPath{numFrame}=[photo_Path '\' nameComplete{numFrame}];
    nameNew{numFrame}=[photo_Path '\' name sprintf('%02d',numFrame) 'centroid_c002'];
        
    [centroids{numFrame,1}, pixel{numFrame,1}, maskBW{numFrame,1}]=Centroid(photoPath{numFrame}, nameNew{numFrame});
   
    xPixel{numFrame,1}=pixel{numFrame,1}(:, 1);
    yPixel{numFrame,1}=pixel{numFrame,1}(:, 2);
    xQuery{numFrame,1}=centroids{numFrame,1}(:, 1);
    yQuery{numFrame,1}=centroids{numFrame,1}(:, 2);
    
    if numFrame==initialFrame

        [k{numFrame}]=boundary(xPixel{numFrame,1},yPixel{numFrame,1});
        
        [in{numFrame},on{numFrame}] = inpolygon(xQuery{numFrame,1},yQuery{numFrame,1},xPixel{numFrame,1}(k{numFrame}),yPixel{numFrame,1}(k{numFrame}));
        LayerCentroid{1}=[ones(size(xQuery{numFrame}, 1), 1) * numFrame, xQuery{numFrame,1},yQuery{numFrame,1}]; %FRAME 6
        LayerPixel{1}=[ones(size(xPixel{numFrame}, 1), 1) * numFrame, xPixel{numFrame,1},yPixel{numFrame,1}]; %FRAME 6
        
    else
        
        oldCentroids = ismember(round(centroids{numFrame,1}),pixel{numFrame-1,1},'rows'); %Los centroides del nuevo frame que est�n en los pixeles del anterior

        for numLayer=1:size(LayerCentroid, 1)

            for n=1:size(centroids{numFrame}(:, 1))
                
                if oldCentroids(n)==0 %Para que no coja los repetidos
                    oldCentroids(n) = 1; %Cuando solo cojo los centroides no repetidos (0) pongo ese numero a 1 para que no me lo vuelva a coger en la siguiente repetici�n
                    
                    if size(LayerCentroid{numLayer,1},1)<4 %Si hay menos de 3 centroides en la capa entonces
                        [LayerCentroid, LayerPixel, numLayer] = addToLayer( xQuery, yQuery, numFrame, n, LayerCentroid, numLayer, LayerPixel);
                        
                    else
                        x=LayerPixel{numLayer,1}(:,2);
                        y=LayerPixel{numLayer,1}(:,3);
                        [kLayer{numLayer}]=boundary(x,y,0.8);
                        [inLayer{numLayer},onLayer{numLayer}] = inpolygon(xQuery{numFrame,1},yQuery{numFrame,1},x(kLayer{numLayer}),y(kLayer{numLayer}));
                        
                        if (inLayer{numLayer}(n)==0) || ((inLayer{numLayer}(n)==1) && (numFrame==initialFrame+1))
                            if(inLayer{1}(n)==1)
                                [LayerCentroid, LayerPixel, numLayer] = addToLayer( xQuery, yQuery, numFrame, n, LayerCentroid, numLayer, LayerPixel);
                            elseif(inLayer{1}(n)==0)
                                [LayerCentroid, LayerPixel, numLayer] = addToLayer( xQuery, yQuery, numFrame, n, LayerCentroid, 1, LayerPixel);
                            
                            end
                        elseif (inLayer{numLayer}(n)==1)
                            if numLayer+1 > size(LayerCentroid, 1) %Si no hay capa creada
                                w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
                                LayerCentroid{numLayer+1, 1} = horzcat(numFrame, w);
                                LayerPixel{numLayer+1, 1} = horzcat(numFrame, w);
                                newLayer=true;
                                
                            elseif newLayer==true %Hay capa creada 
                                if size(LayerCentroid{numLayer+1,1},1)<4
                                    %[LayerCentroid, LayerPixel, numLayer] = addToLayer( xQuery, yQuery, numFrame, n, LayerCentroid, numLayer+1, LayerPixel);
                                    w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
                                    LayerCentroid{numLayer+1} = vertcat(LayerCentroid{numLayer+1},horzcat(numFrame, w));
                                    LayerPixel{numLayer+1} = vertcat(LayerPixel{numLayer+1},horzcat(numFrame, w));
                               
                                else
                                    %Se deberia alacenar para cuando pase
                                    %de capa se analice y as� sucesivamente
                                    oldCentroids(n) = 0; %Lo vuelvo a poner a 0 pork en la siguiente capa quiero que analice otra vez este centroide
                                end
                            end
                        end
                    end
                end
            end
            
        end
        
    
%   Representaci�n de los centroides de las diferentes capas      
        f=figure('Visible', 'on');
        imshow(maskBW{numFrame-1});
        hold on;
        Color=colorcube(10);
        for numCentroidLayer=1:size(LayerCentroid, 1)
            mio=size(LayerCentroid{numCentroidLayer,1}(:, 1));
            for i=1:mio(1,1)
                plot(LayerCentroid{numCentroidLayer,1}(i,2), LayerCentroid{numCentroidLayer,1}(i, 3), '*','MarkerEdgeColor', Color(numCentroidLayer,:), 'MarkerFaceColor', Color(numCentroidLayer,:));
            end
        end
        %Merge images to return
%         nameLayer=[photo_Path '\' name sprintf('%02d',numFrame) 'centroid_layers'];
%         saveas(f,[nameLayer '.tiff']);
        
     end


end

disp(['El n�mero total de capas son: ', num2str(numLayer)]);

end

