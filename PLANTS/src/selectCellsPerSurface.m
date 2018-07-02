clear
close all
names={'Hypocotyl A','Hypocotyl B','katanin meristem A',...
    'katanin meristem B','root A','root B','WT meristem A',...
    'WT meristem B'};

addpath(genpath('lib'))
for nNam=1:2%1:length(names)
    load(['..\' names{nNam} '\image3d_' strrep(names{nNam},' ','_') '.mat'],'img3d');

%     tic
%     [neighbourhoodInfo] = calculate_neighbours3D(img3d);
%     toc
%     save(['..\' names{nNam} '\neighboursInfo.mat'],'neighbourhoodInfo')
    load(['..\' names{nNam} '\neighboursInfo.mat'],'neighbourhoodInfo')
   
    
    [surfacesHypocotyl]=getColHypocotylPerSurfaces(neighbourhoodInfo,img3d);
  


%     verticesInfoOuterLayerOuterSurface=getVertices3d(maskOuterSurface,neighboursLayer,neighbourhoodInfo);

        
%     colours = jet(max(totalBorderCells));
%     colours = colours(randperm(max(totalBorderCells)), :);
%     
%     
%     centroids=regionprops3(img3d,'Centroid');
%     centroids=cat(1,centroids.Centroid);
%     h=figure;    
%     for nCell=totalBorderCells
        
%         plot3(centroids(nCell,1),centroids(nCell,2),centroids(nCell,3),'*')
%         [x,y,z] = ind2sub(size(maskCellsOuter),find(maskCellsOuter==nCell));
%         shp=alphaShape(x,y,z,500);
%         plot(shp, 'FaceColor', colours(nCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
%         hold on
%     end
%     
%    savefig(h,[names{nNam} '\outerSurfaceCells.fig']);
end