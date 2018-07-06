clear
close all
names={'Hypocotyl A','Hypocotyl B','katanin meristem A',...
    'katanin meristem B','root A','root B','WT meristem A',...
    'WT meristem B'};

addpath(genpath('lib'))
for nNam=1:2%1:length(names)
    load(['..\' names{nNam} '\image3d_' strrep(names{nNam},' ','_') '.mat'],'img3d');

    if ~exist(['..\' names{nNam} '\neighboursInfo.mat'],'file')
        [neighbourhoodInfo] = calculate_neighbours3D(img3d);
        save(['..\' names{nNam} '\neighboursInfo.mat'],'neighbourhoodInfo')
    else
        load(['..\' names{nNam} '\neighboursInfo.mat'],'neighbourhoodInfo')
    end
    
    if exist(['..\' names{nNam} '\cellsLayer1Correction.mat'],'file')
        load(['..\' names{nNam} '\cellsLayer1Correction.mat'],'cellsCorrectLayer1')
        [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getColHypocotylPerSurfaces(neighbourhoodInfo,img3d,cellsCorrectLayer1);
    end
    
    [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getColHypocotylPerSurfaces(neighbourhoodInfo,img3d,[]);
    
    centroids=regionprops3(img3d,'Centroid');
    centroids=cat(1,centroids.Centroid);
    save(['..\' names{nNam} '\cellsAndSurfacesPerLayer.mat'],'-v7.3','layer1','layer2','setOfCells','centroids')

%     verticesInfoOuterLayerOuterSurface=getVertices3d(maskOuterSurface,neighboursLayer,neighbourhoodInfo);

    
%     colours = jet(double(max(setOfCells.Layer2)));
%     colours = colours(randperm(max(setOfCells.Layer2)), :);
% 
%     h=figure;    
%     for nCell=setOfCells.Layer2'
%         
%         [x,y,z] = ind2sub(size(layer2.outerSurface),find(layer2.outerSurface==nCell));
%         shp=alphaShape(x,y,z,500);
%         plot(shp, 'FaceColor', colours(nCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
%         hold on
%         
%         [x,y,z] = ind2sub(size(layer2.innerSurface),find(layer2.innerSurface==nCell));
%         shp=alphaShape(x,y,z,500);
%         plot(shp, 'FaceColor', colours(nCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
%         hold on
%     end
%     
%    savefig(h,[names{nNam} '\outerSurfaceCells.fig']);
end