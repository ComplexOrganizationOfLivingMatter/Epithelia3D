%%Variables
photo_Path='C:\Users\tinaf\OneDrive\Documentos\Departamento\Epithelia3D\Prueba2';
name='50epib_2_z0';
initial=6;
maxFrame=20;
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
Layer=cell(20,1);
k=cell(maxFrame,1);
j=1; %Variable que aumenta con el número de capas
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
        Layer{j}=[ones(size(xQuery{numFrame}, 1), 1) * numFrame, xQuery{numFrame,1},yQuery{numFrame,1}]; %FRAME 6
        
        
    else
        
        xPixel{numFrame,1}=pixel{numFrame,1}(:, 1);
        yPixel{numFrame,1}=pixel{numFrame,1}(:, 2);
        
        xQuery{numFrame,1}=centroids{numFrame,1}(:, 1);
        yQuery{numFrame,1}=centroids{numFrame,1}(:, 2);
        %bucle for que compare todos los centroides con todas las capas for
        %numFrame de -1 a -1
        
        for numLayer=1:size(in{numFrame-1,1})
            
            %[k{numFrame}]=boundary(xPixel{numFrame-1,1},yPixel{numFrame-1});       
            %[in{numFrame},on{numFrame}] = inpolygon(xQuery{numFrame,1},yQuery{numFrame,1},xPixel{numFrame-1,1}(k{numFrame}),yPixel{numFrame-1,1}(k{numFrame}));
            x=Layer{j,1}(:,2);
            y=Layer{j,1}(:,3);
            [kNewLayer{numFrame}]=boundary(x,y);
            [inNewLayer{numFrame},onNewLayer{numFrame}] = inpolygon(xQuery{numFrame,1},yQuery{numFrame,1},x(kNewLayer{numFrame}),y(kNewLayer{numFrame})); %Debería ser con pixeles???
            
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
            allCentroids = centroids{numFrame}; %Todos los centroides del nuevo frame
            newCentroids = allCentroids(oldCentroids == 0, :); %De todos los centroides del nuevo frame, cógeme las filas que tenga como valor 0 según coincida con el anterior frame y todas las columnas
            
            for n=1:size(centroids{numFrame}(:, 1))
                if oldCentroids(n)==0
                    if (in{numFrame,1}(n)==0) || ((in{numFrame,1}(n)==1) && (numFrame==initial+1))
                        w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
                        Layer{j,1} = vertcat(Layer{j},horzcat(numFrame, w)); %Todos los centroides que constituye esta capa
                        
                    elseif (in{numFrame,1}(n)==1)
                        [Layer, j, inNewLayer, onNewLayer] = newLayer (Layer, j, xQuery{numFrame,1}(n), yQuery{numFrame,1}(n), oldCentroids, numFrame, inNewLayer, onNewLayer);
                        
                    end
                end
            end
        end
        %     figure
        %     imshow(maskBW{numFrame-1});
        %     hold on;
        %     numLayer=size(Layer{j,1}(:,1));
        %     Color=['b*', 'w+', 'g^'];
        %     for numCentroidLayer=1:numLayer
        %         plot(Layer{numCentroidLayer,1}(:,2), Layer{numCentroidLayer,1}(:, 3), 'Color', Color(numCentroidLayer));
        %     end
    end
end
