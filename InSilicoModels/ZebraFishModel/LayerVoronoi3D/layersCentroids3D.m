function layersCentroids3D( pathArchMat, initialFrame )
%LAYERSCENTROIDS3D Represents layered centroids in 3D

close all;
%Load the seeds
load(pathArchMat);

%Represent the seeds according to the layer and therefore, by color.
Color=colorcube(10);
numCentroid=1;
f=figure('Visible', 'on');
for numFrame=initialFrame:size(centroids)
    for numLayer=1:size(LayerCentroid, 1)
        for numCentroidLayer=1:size(LayerCentroid{numLayer,1}(:, 1),1)
            if LayerCentroid{numLayer,1}(numCentroidLayer,1)==numFrame
                plot3(LayerCentroid{numLayer,1}(numCentroidLayer,2), LayerCentroid{numLayer,1}(numCentroidLayer, 3), numFrame, '*','MarkerEdgeColor', Color(numLayer,:), 'MarkerFaceColor', Color(numLayer,:));               
                hold on;    
                FinalMatrix(numCentroid,1:3)=horzcat(LayerCentroid{numLayer,1}(numCentroidLayer,2), LayerCentroid{numLayer,1}(numCentroidLayer, 3), numFrame);
                numCentroid=numCentroid+1;
            end
        end 
    end
end
voronoin
%LayerCentroid=cellfun(@(x) x(:,1)*0.1,LayerCentroid,'UniformOutput', false);
% [V,C]=voronoin(FinalMatrix);
X=[LayerCentroid{1,1}*0.9;LayerCentroid{1,1}*1.1];
[V,C]=voronoin(X);

V(1,:)=[];
C=cellfun(@(x) x(x>1)-1,C,'UniformOutput', false);

C1 = C(1:size(LayerCentroid{1, 1}, 1));


for numFaces=1:size(C1,1)
    
    %facesConv{numFaces,1}=convhulln(V(C1{numFaces}, :));
    facesAlpha{numFaces,1}=alphaShape(V(C1{numFaces}, :));
    k{numFaces,1}=boundary(V(C1{numFaces}, :),0);
    %facesBoun{numFaces,1}=V(k{numFaces});
end

figure
% hold on;
% figure('Visible', 'on');
% trisurf(k,V(k{:,1}),V(k(:,2)),V(k(:,3)),'Facecolor','red','FaceAlpha',0.1);
vert=V(C1{1},:);
patch('Faces',k{1},'Vertices', vert, 'FaceColor','b');
% figure
% patch('Faces',facesConv,'Vertices',V, 'FaceColor','b');

figure
%patch('Faces',facesAlpha{1},'Vertices', vert, 'FaceColor','b');
plot(facesAlpha{1});


end

