load('E:\Tina\Epithelia3D\Zebrafish\Results\Sample1\LayersCentroids1.mat');
numFrame=6;

photo_Path='E:\Tina\Epithelia3D\Zebrafish\50epib_1';
name='50epib_1_z';

channel2Name{numFrame}= [name sprintf('%03d',numFrame) '_c002.tif'];
photoPath{numFrame}=[photo_Path '\' channel2Name{numFrame}];
nameNew{numFrame}=[photo_Path '\' name sprintf('%02d',numFrame) 'centroid_c002'];

[centroids{numFrame,1}, pixel{numFrame,1}, maskBW{numFrame,1}]=Centroid(photoPath{numFrame}, nameNew{numFrame});

xQuery{numFrame,1}=centroids{numFrame,1}(:, 1);
yQuery{numFrame,1}=centroids{numFrame,1}(:, 2);
a=horzcat(xQuery{numFrame,1},yQuery{numFrame,1});

LayerCentroid{1,1}(end+1,:)=[numFrame,a(1,1),a(1,2)];
LayerCentroid{1,1}(end+1,:)=[numFrame,a(2,1),a(2,2)];

LayerCentroid{1,1}=sortrows(LayerCentroid{1,1},1);

LayerCentroid1{1,1}=LayerCentroid{1,1};
LayerCentroid1{2,1}=LayerCentroid{2,1};
LayerCentroid1{3,1}=LayerCentroid{3,1};
LayerCentroid1{4,1}=LayerCentroid{4,1};

clear LayerCentroid;

LayerCentroid{1,1}=LayerCentroid1{1,1};
LayerCentroid{2,1}=LayerCentroid1{2,1};
LayerCentroid{3,1}=LayerCentroid1{3,1};
LayerCentroid{4,1}=LayerCentroid1{4,1};


save('LayersCentroids1.mat', 'LayerCentroid', 'LayerPixel', 'centroids', 'pixel', 'newLayer')
