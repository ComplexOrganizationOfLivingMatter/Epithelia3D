load('E:\Tina\Epithelia3D\Zebrafish\Results\Sample2\LayersCentroids2.mat');
%load('E:\Tina\Epithelia3D\Zebrafish\Results\Sample2\trackingCentroids2.mat');
load('E:\Tina\pseudostratifiedEpithelia\trackingCentroids2.mat');
folderNumber=2;

acum=1;
[C,ia,ic] = unique(vertcat(finalCentroid{:,1}));

for numCell=1:size(C,1)
    for numCent=1:size(ic,1)
        if ic(numCent)==numCell
            num{numCell,1}=numCell;
            num{numCell,2}=acum;
            acum=acum+1;
        end
    end
    acum=1;
end

for numCell=1:size(vertcat(num{:,1}),1)
    if num{numCell,2}==1
        errors{acum,1}=num{numCell,1};
        acum=acum+1;
    end
    
end

for errorCent=1:size(vertcat(errors{:,1}),1)
    for numCent=1:size(vertcat(finalCentroid{:,1}))
        if errors{errorCent,1}==finalCentroid{numCent,1}
            errors{errorCent,2}=finalCentroid{numCent,2};
            errors{errorCent,3}=finalCentroid{numCent,3};
        end
    end
end

%Ya tenemos la matriz con los centroides que solo aparecen en un frame.
%Ahora lo que tenemos que hacer es coger las imagenes donde se dan, las dos
%de alante y las dos atras.


coord=vertcat(errors{:,2});
varTracking=cell(11,1);

for errorCent=1:1%size(vertcat(errors{:,1}),1)
    
    frameAnalysis=coord(errorCent,3);
    x=coord(errorCent,1);
    y=coord(errorCent,2);
    
    for photo=1:11 %5 fotos menos al frameAnalysis y 5 fotos mas
        
        
        %Tratamiento nuevo para ver el seguimiento.
        FileName{photo,1}=['E:\Tina\Epithelia3D\Zebrafish\50epib_' sprintf('%d',folderNumber) '\50epib_'  sprintf('%d',folderNumber) '_z' sprintf('%03d',frameAnalysis+(photo-6)) '_c002.tif'];
        
        if (frameAnalysis+(photo-6))~=frameAnalysis && (frameAnalysis+(photo-6))> 4 && (frameAnalysis+(photo-6))< size(centroids,1)-4   
            [finalCentroid, varTracking] = newTreatment( FileName, photo, frameAnalysis, x, y, finalCentroid, varTracking, errors, errorCent);     
        elseif (frameAnalysis+(photo-6))~=frameAnalysis && (frameAnalysis+(photo-6))< 5 && photo>5 %Cojo las primeras imágenes
            [finalCentroid, varTracking] = newTreatment( FileName, photo, frameAnalysis, x, y, finalCentroid, varTracking, errors, errorCent);
        elseif (frameAnalysis+(photo-6))~=frameAnalysis && (frameAnalysis+(photo-6))> size(centroids,1)-5 && photo<5 %Cojo las últimas imagenes
            [finalCentroid, varTracking] = newTreatment( FileName, photo, frameAnalysis, x, y, finalCentroid, varTracking, errors, errorCent);
        end
        
        %Representación del centroide que sólo está en un frame. Se
        %representa tanto en la imagen tratada nueva como en la imagen
        %original que se trata.
        
%         figure
%         imshow(maskBW)
%         hold on;
%         plot(coord(errorCent,1), coord(errorCent,2), 'b*')
%         
%         figure
%         imshow(FileName{photo,1})
%         hold on;
%         plot(coord(errorCent,1), coord(errorCent,2), 'b*')
        

    end
    
    %Crear una variable que contenga todos los frames que se han añadido
    %para esa célula. Ésto servirá para que luego se pueda comprobar si son
    %frames seguidos o no.
    acum2=1;
    for trackingFrame=1:size(varTracking,1)
        if isempty(varTracking{trackingFrame,1})==0
            variables(acum2,1)=varTracking{trackingFrame,1}(1,1);
            acum2=acum2+1;
        end
    end
    
    %Para eliminar los centroides que se acaban de meter si no son
    %seguidos, ya que será mierda.
    acum3=1;
    for framesTrack=2:size(variables(:,1))
        if variables(framesTrack,1)~=(variables(framesTrack-1,1))+1
            for numCen=1:size(finalCentroid,1)
                if finalCentroid{numCen,1}(1,1)~=errors{errorCent,1}
                    finalC{acum3,1}=finalCentroid{numCen,1};
                    finalC{acum3,2}= finalCentroid{numCen,2};
                    finalC{acum3,3}=finalCentroid{numCen,3};
                    acum3=acum3+1;
                end
            end
        end
    end
   
    
end

finalCentroid=sortrows(finalC,1);

%Re-etiquetar las células, ya que ahora algunas ya no existen
for numCell=1:max(vertcat(finalCentroid{:,1}))
    for numRep=1:size(vertcat(finalCentroid{:,1}),1) 
        %if finalCentroid{numRep,1} == numCell
            finalCentroid{numRep,4} = numCell;
        %end
    end
    
end

%Vuelvo a ver la matriz de errores que tengo ahora después de hacer el
%nuevo tratamiento/seguimiento

[C,ia,ic] = unique(vertcat(finalCentroid{:,1}));
acum=1;

for numCell=1:size(C,1)
    for numCent=1:size(ic,1)
        if ic(numCent)==numCell
            num{numCell,1}=numCell;
            num{numCell,2}=acum;
            acum=acum+1;
        end
    end
    acum=1;
end

for numCell=1:size(vertcat(num{:,1}),1)
    if num{numCell,2}==1
        errors{acum,1}=num{numCell,1};
        acum=acum+1;
    end
    
end


%Para eliminar las células que sólo tengan un solo frame
acum4=1;
for errorCent=1:size(vertcat(errors{:,1}),1)
    for numCent=1:size(vertcat(finalCentroid{:,1}),1) 
        if finalCentroid{numCent,1}(1,1)~=errors{errorCent,1}(1,1)
            f{acum4,1}=finalCentroid{numCent,1};
            f{acum4,2}= finalCentroid{numCent,2};
            f{acum4,3}=finalCentroid{numCent,3};
            acum4=acum4+1;
        end       
    end
end
acum4=1;
%Re-etiquetar las células, ya que ahora algunas ya no existen
for numRep=1:size(vertcat(f{:,1}),1)
    if f{numRep,1} == acum4
        f{numRep,4}= acum4;
    else
        acum4=acum4+1;
        f{numRep,4}= acum4;
    end
end

finalCentroid=sortrows(f,1);

%save('trackingCentroid2', 'finalCentroid')






