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
        %LayerPixel{1}=[ones(size(xPixel{numFrame}, 1), 1) * numFrame, xPixel{numFrame,1},yPixel{numFrame,1}]; %FRAME 6
        
    else
        
        %%Layer separator
        [LayerCentroid, centroids, pixel, xQuery, yQuery, initialFrame, newLayer] = layersMarker( LayerCentroid, centroids, pixel, numFrame, xQuery, yQuery, initialFrame, newLayer);
        
        %%Representation of the centroids of the different layers
        [LayerCentroid] = LayerDraw( LayerCentroid, Color, numFrame, initialFrame, photo_Path, name, pixel);
        
        % Save the result to a .mat file
        finalFileName=['LayersCentroidsPrueba' sprintf('%d',folderNumber) '.mat'];
        save(finalFileName, 'LayerCentroid', 'centroids', 'pixel', 'newLayer')
        
        % Display the next frame number in screen
        if numFrame+1 <= maxFrame
            fprintf('Next frame:  \n %0d \n', numFrame+1)
        end
        
    end


end
