function [LayerCentroid, LayerPixel] = separatesAndCorrectsCentroidsByLayers( photo_Path,name, initialFrame, maxFrame, currentFrame,  pathArchMat, folderNumber )
%SEPARATESANDCORRECTSCENTROIDSBYLAYERS Separate and correct centroids
%
% Input/output specs
% ------------------
% photo_Path:   'E:\Tina\Epithelia3D\Zebrafish\50epib_5';
% name: '50epib_5_z';
% initialFrame:	16;
% maxFrame: 98;
% currentFrame: 50;
% pathArchMat:  'E:\Tina\Epithelia3D\Zebrafish\Code\LayersCentroids5.mat';
% folderNumber: 5;

%%Variables
newLayer=false;
Color=colorcube(10);
sameCentroid=cell(maxFrame, 1);
% In case you don't have to start from the beginning, you have to load the file with the necessary values to continue the execution of the program.
load_data=input('Is this the first time you run the program?:1 (yes) \n 0 (no) \n:');           
if load_data==0
    load(pathArchMat);
    load_data=1;
end

for numFrame=currentFrame:maxFrame % Variable that corresponds with the number of images (frame)
    
    % Reading the images
    channel2Name{numFrame}= [name sprintf('%03d',numFrame) '_c002.tif'];
    photoPath{numFrame}=[photo_Path '\' channel2Name{numFrame}];
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
%         channel1Name{numFrame}= [name sprintf('%03d',numFrame) '_c001.tif'];
%         channel1PhotoPath{numFrame}=[photo_Path '\' channel1Name{numFrame}];
        [LayerCentroid, LayerPixel] = LayerDraw( LayerCentroid, LayerPixel, Color, numFrame, initialFrame, photo_Path, name);
%         f=figure('Visible', 'on');  
%         imshow(channel1PhotoPath{numFrame});
%         hold on;
%         numLay = [];
%         nameLay = [];
% 
%         for numLayer=1:size(LayerCentroid, 1)
%             for numCentroidLayer=1:size(LayerCentroid{numLayer,1}(:, 1),1)
% %                 if (LayerCentroid{numCentroidLayer,1}(numCentroidLayer,1)==numFrame) || (LayerCentroid{numCentroidLayer,1}(numCentroidLayer,1) == (numFrame-1)) || (LayerCentroid{numCentroidLayer,1}(numCentroidLayer,1) == (numFrame-2))
%                     numLay(numLayer,:)=plot(LayerCentroid{numLayer,1}(numCentroidLayer,2), LayerCentroid{numLayer,1}(numCentroidLayer, 3), '*','MarkerEdgeColor', Color(numLayer,:), 'MarkerFaceColor', Color(numLayer,:));
% %                 end
%             end
%             nameLay{numLayer}=sprintf ('Layer%d', numLayer);            
%         end
%         legend(numLay,nameLay,'Location','best');    
%         
%         % Merge images to return
% %           finalLayerPhoto=[photo_Path '\Layers\' name sprintf('%03d',numFrame) 'centroid_layers.jpg'];
% %           saveas(f,finalLayerPhoto);
%         
%           
%         %%Treatment of layers
%         if numFrame > initialFrame+1 %This is needed because we don't have a figure before (so here it enters Frame 8)
%             % To add new centroids
%             want_add_centroid=input('Do you want to add centroid? 1 (yes) \n 0 (no) \n:');
%             want_add_more =1;
%             while want_add_more ==1
%                 switch want_add_centroid
%                     case 0
%                         break
%                     case 1
%                         [LayerCentroid, LayerPixel ] = addNewCentroid( f, LayerCentroid, LayerPixel, numFrame );
%                 end
%                 want_add_more=input('Do you want to add more? 1 (yes) \n 0 (no) \n:');
%             end
%             want_modify=input('1 (change labelling mode) \n 0 (Next frame): ');
%             want_modify_more =1;
%             
%             % To change a centroid from a layer to other layer
%             while want_modify_more ==1
%                 switch want_modify
%                     case 0   
%                         break
%                     case 1
%                         f = display_labelled (f, LayerCentroid);
%                         [LayerCentroid, LayerPixel] = layer_write_mode(f,LayerCentroid, LayerPixel, numFrame);                      
%                 end
%                 want_modify_more=input('Do you want to make more changes? 1 (yes) \n 0 (no) \n:');
%             end                      
%           close all;        
%         end
%         
%     end
%     
    % Save the result to a .mat file
    finalFileName=['LayersCentroids' sprintf('%d',folderNumber) '.mat'];
    save(finalFileName, 'LayerCentroid', 'LayerPixel', 'centroids', 'pixel', 'newLayer','sameCentroid')
    
    % Display the next frame number in screen
    if numFrame+1 <= maxFrame
        fprintf('Next frame:  \n %0d \n', numFrame+1)
    end

end

% Clean layers that are empty
%for numLayer=1:size(LayerCentroid,1)
%  if isempty(LayerCentroid{numLayer,1})==1
%    LayerCentroid(numLayer)=[];
%    LayerPixel(numLayer)=[];
%  end
%end
%         

end
