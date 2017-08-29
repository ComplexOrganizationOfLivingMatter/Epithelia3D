%%Variables
photo_Path='C:\Users\tinaf\OneDrive\Documentos\Departamento\Epithelia3D\Prueba2';
name='50epib_2_z0';
initial=6;
maxFrame=10;
nameComplete=cell(maxFrame,1);
photoPath=cell(maxFrame,1);
nameNew=cell(maxFrame,1);
centroids=cell(maxFrame,1);
pixel=cell(maxFrame,1);
in=cell(maxFrame,1);
on=cell(maxFrame,1);
% C=cell(maxFrame,1);
% ia=cell(maxFrame,1);
% ib=cell(maxFrame,1);
LayerCentroid=cell(1,1);
LayerPixel=cell(1,1);
k=cell(maxFrame,1);
w=[];
maskBW=cell(maxFrame,1);
Label=cell(maxFrame,1);
inNewLayer=cell(maxFrame,1);
onNewLayer=cell(maxFrame,1);

for numFrame=initial:maxFrame %Variable que corresponde con el nº de imágenes (frame)
    
    %Lectura de las imágenes
    nameComplete{numFrame}= [name sprintf('%02d',numFrame) '_c002.tif'];
    photoPath{numFrame}=[photo_Path '\' nameComplete{numFrame}];
    nameNew{numFrame}=[photo_Path '\' name sprintf('%02d',numFrame) 'centroid_c002'];
    
    
    [centroids{numFrame,1}, pixel{numFrame,1}, maskBW{numFrame,1}]=Centroid(photoPath{numFrame}, nameNew{numFrame});
    Label{numFrame}=bwlabel(maskBW{numFrame,1},4);
    %[C{numFrame,1},ia{numFrame,1},ib{numFrame,1}] = intersect(Label{numFrame},Label{numFrame-1}); %Hay que ignorar el 1º num porque son los ceros
    
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
            
            %[k{numFrame}]=boundary(xPixel{numFrame-1,1},yPixel{numFrame-1});
            %[in{numFrame},on{numFrame}] = inpolygon(xQuery{numFrame,1},yQuery{numFrame,1},xPixel{numFrame-1,1}(k{numFrame}),yPixel{numFrame-1,1}(k{numFrame}));
            x=LayerPixel{numLayer,1}(:,2);
            y=LayerPixel{numLayer,1}(:,3);
            [kLayer{numLayer}]=boundary(x,y,0.7);
            [inLayer{numLayer},onLayer{numLayer}] = inpolygon(xQuery{numFrame,1},yQuery{numFrame,1},x(kLayer{numLayer}),y(kLayer{numLayer}));
            
            %             figure
            %             imshow(photoPath{numFrame});
            %             hold on
            % %             plot(xPixel{numFrame-1,1}(k),yPixel{numFrame-1,1}(k),'LineWidth',2) % polygon
            %             axis equal
            % %             plot(xPixel{numFrame-1,1},yPixel{numFrame-1,1},'w*') % PostPoints
            %             plot(xQuery{numFrame,1}(in{numFrame}), yQuery{numFrame,1}(in{numFrame}),'g+') % points inside
            %             plot(xQuery{numFrame,1}(~in{numFrame}),yQuery{numFrame,1}(~in{numFrame}),'bo') % points outside
            %             hold off
            
            oldCentroids = ismember(round(centroids{numFrame,1}),pixel{numFrame-1,1},'rows'); %Los centroides del nuevo frame que están en los pixeles del anterior
            
            %           allCentroids = centroids{numFrame}; %Todos los centroides del nuevo frame
            %           newCentroids = allCentroids(oldCentroids == 0, :); %De todos los centroides del nuevo frame, cógeme las filas que tenga como valor 0 según coincida con el anterior frame y todas las columnas
            
            for n=1:size(centroids{numFrame}(:, 1))
                if oldCentroids(n)==0 %Para que no coja los repetidos
                        if (inLayer{numLayer}(n)==0) || ((inLayer{numLayer}(n)==1) && (numFrame==initial+1))
                            if(inLayer{1}(n)==1)
                                [LayerCentroid, LayerPixel] = SearchOfLayers( numLayer, numFrame, xQuery, yQuery, n, LayerCentroid, LayerPixel, inLayer);
                            elseif(inLayer{1}(n)==0)
                                w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
                                LayerCentroid{1} = vertcat(LayerCentroid{1},horzcat(numFrame, w));
                                LayerPixel{1} = vertcat(LayerPixel{1},horzcat(numFrame, w));
                            end                    
                         elseif (inLayer{numLayer}(n)==1)                           
                            if numLayer+1 > size(LayerCentroid, 1)
                                w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
                                LayerCentroid{numLayer+1, 1} = horzcat(numFrame, w);
                                LayerPixel{numLayer+1, 1} = horzcat(numFrame, w);
                                newLayer=true;
                                
                            elseif newLayer==true %Analizar si está en la capa uno o dos o tres o etc                                
                                w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
                                LayerCentroid{numLayer+1} = vertcat(LayerCentroid{numLayer+1},horzcat(numFrame, w));
                                LayerPixel{numLayer+1} = vertcat(LayerPixel{numLayer+1},horzcat(numFrame, w));
                                
                            end
                         end
                        
                    %else %if numLayer~=1 %&& distinto valor que antes
                        %oldLayers =
                        %ismember(LayerCentroid{numLayer,1}(:,2),LayerCentroid{numLayer-1,1}(:,2));
                        %Creo que no me sirve porque obviamente los de la
                        %nueva capa no van a estar en la siguiente CREOOOO
                        %Entra en la segunda capa que solo está los 5 centroides analizados por ahora del frame 10 
                    
                end
            end
        %LayerCentroid=unique(LayerCentroid{numLayer},'rows');
        end

    
%   Representación de los centroides de las diferentes capas      
        figure
        imshow(maskBW{numFrame-1});
        hold on;
        Color=colorcube(10);
        for numCentroidLayer=1:size(LayerCentroid, 1)
            mio=size(LayerCentroid{numCentroidLayer,1}(:, 1));
            for i=1:mio(1,1)
                plot(LayerCentroid{numCentroidLayer,1}(i,2), LayerCentroid{numCentroidLayer,1}(i, 3), '*','MarkerEdgeColor', Color(numCentroidLayer,:), 'MarkerFaceColor', Color(numCentroidLayer,:));
            end
        end
        
    end


end
