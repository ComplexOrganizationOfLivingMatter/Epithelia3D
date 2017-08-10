function [ Layers ] = LayersSeparator( photo_Path,name, initialFrame, maxFrame )


%%Variables
nameComplete=cell(maxFrame,1);
photoPath=cell(maxFrame,1);
nameNew=cell(maxFrame,1);
centroids=cell(maxFrame,1);
pixel=cell(maxFrame,1);
in=cell(maxFrame,1);
on=cell(maxFrame,1);
Layers=cell(80,1);
j=1; %Variable que aumenta con el número de capas
w=[];
maskBW=cell(maxFrame,1);
Label=cell(maxFrame,1);


for i=initialFrame:maxFrame %Variable que corresponde con el nº de imágenes (frame)
    
    %Lectura de las imágenes
    nameComplete{i}= [name sprintf('%02d',i) '_c002.tif'];
    photoPath{i}=[photo_Path '\' nameComplete{i}];
    nameNew{i}=[photo_Path '\' name sprintf('%02d',i) 'centroid_c002'];
    
    
    [centroids{i,1}, pixel{i,1}, maskBW{i,1}]=Centroid(photoPath{i}, nameNew{i});
    Label{i}=bwlabel(maskBW{i,1},8);
    
    
    if numFrame==initial
        xPixel{numFrame,1}=pixel{numFrame,1}(:, 1);
        yPixel{numFrame,1}=pixel{numFrame,1}(:, 2);
        xQuery{numFrame,1}=centroids{numFrame,1}(:, 1);
        yQuery{numFrame,1}=centroids{numFrame,1}(:, 2);
        
        [k{numFrame}]=boundary(xPixel{numFrame,1},yPixel{numFrame,1});
        
        [in{numFrame},on{numFrame}] = inpolygon(xQuery{numFrame,1},yQuery{numFrame,1},xPixel{numFrame,1}(k{numFrame}),yPixel{numFrame,1}(k{numFrame}));
        Layer{j}=[ones(size(xQuery{numFrame}, 1), 1) * numFrame, xQuery{numFrame,1},yQuery{numFrame,1}]; %FRAME 6
        
        
    else
        
        xPixel{numFrame,1}=pixel{numFrame,1}(:, 1);
        yPixel{numFrame,1}=pixel{numFrame,1}(:, 2);
        
        xQuery{numFrame,1}=centroids{numFrame,1}(:, 1);
        yQuery{numFrame,1}=centroids{numFrame,1}(:, 2);
        
        [k{numFrame}]=boundary(xPixel{numFrame-1,1},yPixel{numFrame-1,1});
        [in{numFrame},on{numFrame}] = inpolygon(xQuery{numFrame,1},yQuery{numFrame,1},xPixel{numFrame-1,1}(k{numFrame}),yPixel{numFrame-1,1}(k{numFrame}));
        
        oldCentroids = ismember(round(centroids{numFrame,1}),pixel{numFrame-1,1},'rows'); %Los centroides del nuevo frame que están en los pixeles del anterior
        
        for n=1:size(centroids{numFrame}(:, 1))
            if oldCentroids(n)==0
                if in{numFrame,1}(n)==0
                    w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
                    Layer{j,1} = vertcat(Layer{j},horzcat(numFrame, w)); %Todos los centroides que constituye esta capa
                    
                elseif (in{numFrame,1}(n)==1) && (oldCentroids(n)==0)
                    Layer{j,1} = newLayer (Layer{j,1},xQuery{numFrame,1}(n), yQuery{numFrame,1}(n), oldCentroids);
                    
                end
            end
        end
        
    end
end