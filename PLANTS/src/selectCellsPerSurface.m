clear
close all
names={'Hypocotyl A','Hypocotyl B','katanin meristem A',...
    'katanin meristem B','WT meristem A','WT meristem B','root A','root B'};
    
addpath(genpath('lib'))
for nNam=1:2%1:length(names)
    load(['..\' names{nNam} '\image3d_' strrep(names{nNam},' ','_') '.mat'],'img3d');
    
    img3d=uint16(img3d);
    
    if contains(names{nNam},'Hypocotyl')
        if ~exist(['..\' names{nNam} '\neighboursInfo.mat'],'file')
            [neighbourhoodInfo] = calculate_neighbours3D(img3d);
            save(['..\' names{nNam} '\neighboursInfo.mat'],'-v7.3','neighbourhoodInfo')
        else
            load(['..\' names{nNam} '\neighboursInfo.mat'],'neighbourhoodInfo')
        end
        
        if exist(['..\' names{nNam} '\cellsAndSurfacesPerLayer.mat'],'file')
            load(['..\' names{nNam} '\cellsAndSurfacesPerLayer.mat'],'layer1','layer2','setOfCells')
        else
            if exist(['..\' names{nNam} '\cellsLayer1Correction.mat'],'file') 
                load(['..\' names{nNam} '\cellsLayer1Correction.mat'],'cellsCorrectLayer1')
                [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getColHypocotylPerSurfaces(neighbourhoodInfo,uint16(img3d),cellsCorrectLayer1);
            else
                [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getColHypocotylPerSurfaces(neighbourhoodInfo,uint16(img3d),[]);
            end
        end
        
        verticesInfoLayer1.Outer=getVertices3D(layer1.outerSurface,setOfCells.Layer1,neighbourhoodInfo);
        verticesInfoLayer1.Inner=getVertices3D(layer1.innerSurface,setOfCells.Layer1,neighbourhoodInfo);
        verticesInfoLayer2.Outer=getVertices3D(layer2.outerSurface,setOfCells.Layer2,neighbourhoodInfo);
        verticesInfoLayer2.Inner=getVertices3D(layer2.innerSurface,setOfCells.Layer2,neighbourhoodInfo);
        
        save(['..\' names{nNam} '\verticesSurfaces.mat'],'verticesInfoLayer1','verticesInfoLayer2')

    else
            [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getMeristemPerSurfaces(uint16(img3d),names{nNam});        
            getVertices();
    end
    
%     save(['..\' names{nNam} '\cellsAndSurfacesPerLayer.mat'],'-v7.3','layer1','layer2','setOfCells')

%     colours = jet(double(max(setOfCells.Layer1)));
%     colours = colours(randperm(max(setOfCells.Layer1)), :);
%     img3dPerim=bwperim(img3d);
%     perimLabel=uint16(img3dPerim).*img3d;
%     h=figure;    
%     for nCell=setOfCells.Layer1'
%         
%         [x,y,z] = ind2sub(size(img3d),find(img3d==nCell));
%         shp=alphaShape(x,y,z,1);
%         plot(shp, 'FaceColor', colours(nCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
%         hold on
%         
%     end
    
%    savefig(h,[names{nNam} '\outerSurfaceCells.fig']);
end