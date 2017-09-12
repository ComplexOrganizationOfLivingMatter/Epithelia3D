function layerVoronoi( pathArchMat, photoPath, photoName)

close all;
load(pathArchMat);
photo_Path=[photoPath '\' photoName];
[H,W]=size(imread(photo_Path));

for numLayer=1:size(LayerCentroid,1)
    
    if size(LayerCentroid{numLayer,1},1) >= 3
        
        imagen=zeros(H,W);
        
        for numCentroidLayer=1:size(LayerCentroid{numLayer,1},1)
            x{numLayer,1}=LayerCentroid{numLayer,1}(:,2);
            y{numLayer,1}=LayerCentroid{numLayer,1}(:,3);
            imagen(round(x{numLayer,1}(numCentroidLayer,1)),round(y{numLayer,1}(numCentroidLayer,1)))=1;
        end
        
        f=figure('Visible', 'off');
        k=boundary(x{numLayer,1},y{numLayer,1},0);
        D = bwdist(imagen);
        DL = watershed(D);
        bgm = DL == 0;
        invertedVoronoi=bgm;
        Voronoi=1-invertedVoronoi;
        imshow(Voronoi);
        hold on;
        
        [xq, yq]= find(Voronoi == 0);
        [in,on] = inpolygon(xq,yq,round(x{numLayer,1}(k,1)),round(y{numLayer,1}(k,1)));
        
        for index=1:size(in,1)
            if in(index,1)==0
                Voronoi(xq(index,1), yq(index,1))=1;
            end
        end
        
        imshow(Voronoi);
        plot(y{numLayer,1}(k),x{numLayer,1}(k),'-k' );
        numLay=sprintf('Layer%d', numLayer);
        legend(numLay);
        
        % Merge images to return
        voronoiPhoto=[photoPath '\Layers\Voronoi\'  'voronoi_layers' sprintf('%d',numLayer) '.jpg'];
        saveas(f,voronoiPhoto);
        
    end
end

end

