function [ LayerCentroid, LayerPixel] = separatesAndCorrectsCentroidsByLayers( photo_Path,name, initialFrame, maxFrame, currentFrame,  pathArchMat )

%%Variables
newLayer=false;
% photo_Path='C:\Users\tinaf\OneDrive\Documentos\Departamento\Epithelia3D\Prueba2';
% name='50epib_2_z0';
% initialFrame=6;
% maxFrame=48;
% pathArchMat='C:\Users\tinaf\OneDrive\Documentos\GitHub\pseudostratifiedEpitheli\LayersCentroids.mat';


if exist(pathArchMat)&& (initialFrame~=currentFrame)
    load(pathArchMat);  
end

for numFrame=currentFrame:maxFrame %Variable that corresponds with the number of images (frame)
    
    %Reading the images
    nameComplete{numFrame}= [name sprintf('%02d',numFrame) '_c002.tif'];
    photoPath{numFrame}=[photo_Path '\' nameComplete{numFrame}];
    nameNew{numFrame}=[photo_Path '\' name sprintf('%02d',numFrame) 'centroid_c002'];
        
    [centroids{numFrame,1}, pixel{numFrame,1}, maskBW{numFrame,1}]=Centroid(photoPath{numFrame}, nameNew{numFrame});
       
    xQuery{numFrame,1}=centroids{numFrame,1}(:, 1);
    yQuery{numFrame,1}=centroids{numFrame,1}(:, 2);
    
    if numFrame==initialFrame
        
        xPixel{numFrame,1}=pixel{numFrame,1}(:, 1);
        yPixel{numFrame,1}=pixel{numFrame,1}(:, 2);
        
        [k{numFrame}]=boundary(xPixel{numFrame,1},yPixel{numFrame,1},1);
        
        [in{numFrame},on{numFrame}] = inpolygon(xQuery{numFrame,1},yQuery{numFrame,1},xPixel{numFrame,1}(k{numFrame}),yPixel{numFrame,1}(k{numFrame}));
        LayerCentroid{1}=[ones(size(xQuery{numFrame}, 1), 1) * numFrame, xQuery{numFrame,1},yQuery{numFrame,1}]; %FRAME 6
        LayerPixel{1}=[ones(size(xPixel{numFrame}, 1), 1) * numFrame, xPixel{numFrame,1},yPixel{numFrame,1}]; %FRAME 6
        
    else
        %%Layer separator
        [LayerCentroid, LayerPixel, centroids, pixel, xQuery, yQuery, initialFrame, newLayer] = layersMarker( LayerCentroid, LayerPixel, centroids, pixel, numFrame, xQuery, yQuery, initialFrame, newLayer);

        %%Representation of the centroids of the different layers      
        f=figure('Visible', 'on');
        nameCompleteLayer{numFrame}= [name sprintf('%02d',numFrame) '_c001.tif'];
        photoPathLayer{numFrame}=['C:\Users\tinaf\OneDrive\Documentos\Departamento\Epithelia3D\50epib_2' '\' nameCompleteLayer{numFrame}];
        imshow(photoPathLayer{numFrame});
       
        hold on;
        Color=colorcube(10);
        
        
        for numCentroidLayer=1:size(LayerCentroid, 1)
            mio=size(LayerCentroid{numCentroidLayer,1}(:, 1));
            for i=1:mio(1,1)
                numLay(numCentroidLayer,:)=plot(LayerCentroid{numCentroidLayer,1}(i,2), LayerCentroid{numCentroidLayer,1}(i, 3), '*','MarkerEdgeColor', Color(numCentroidLayer,:), 'MarkerFaceColor', Color(numCentroidLayer,:));
            end
            numLay1{numCentroidLayer}=sprintf ('Layer%d', numCentroidLayer);
        end
        
          
        legend(numLay,numLay1);  
               
        % Merge images to return
          nameLayer=[photo_Path '\Layers\' name sprintf('%02d',numFrame) 'centroid_layers.jpg'];
          saveas(f,nameLayer);
        
        %%Treatment of layers
        if numFrame > initialFrame+1 %This is needed because we do not have a figure before (so here it enters Frame 8)
            % Display labels in screen
            want_modify=input('1 (change labelling mode) \n 0 (Next frame): ');
            want_modify_more =1;
            
            while want_modify_more ==1
                switch want_modify
                    case 0   
                        break
                    case 1
                        f = display_labelled (f, LayerCentroid);
                        [LayerCentroid, LayerPixel] = layer_write_mode(f,LayerCentroid, LayerPixel, numFrame);                      
                end
                want_modify_more=input('Do you want to make more changes? 1 (yes) \n 0 (no) \n:');
            end            
          
          close all;
        
        end

    end
    
    fprintf('Next frame:  \n %0d \n', numFrame+1)
    save('LayersCentroids.mat', 'LayerCentroid', 'LayerPixel', 'centroids', 'pixel')
end

end
