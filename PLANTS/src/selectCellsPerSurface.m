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
        
        if ~exist(['..\' names{nNam} '\verticesSurfaces.mat'],'file')
            verticesInfoLayer1Outer=getVertices3D(layer1.outerSurface,setOfCells.Layer1,neighbourhoodInfo);
            verticesInfoLayer1Inner=getVertices3D(layer1.innerSurface,setOfCells.Layer1,neighbourhoodInfo);
            verticesInfoLayer2Outer=getVertices3D(layer2.outerSurface,setOfCells.Layer2,neighbourhoodInfo);
            verticesInfoLayer2Inner=getVertices3D(layer2.innerSurface,setOfCells.Layer2,neighbourhoodInfo);
            save(['..\' names{nNam} '\verticesSurfaces.mat'],'verticesInfoLayer1','verticesInfoLayer2')
        else
            load(['..\' names{nNam} '\verticesSurfaces.mat'],'verticesInfoLayer1','verticesInfoLayer2')
        end
        [centers, radiiBasalLayer1] = calculateCenterRadiusCylSection(layer1.outerSurface,setOfCells.Layer1,['..\' names{nNam} '\outerMaskLayer1']);
        [~, radiiApicalLayer1] = calculateCenterRadiusCylSection(layer1.innerSurface,setOfCells.Layer1,['..\' names{nNam} '\innerMaskLayer1']);
        [~, radiiBasalLayer2] = calculateCenterRadiusCylSection(layer2.outerSurface,setOfCells.Layer2,['..\' names{nNam} '\outerMaskLayer2']);
        [~, radiiApicalLayer2] = calculateCenterRadiusCylSection(layer2.innerSurface,setOfCells.Layer2,['..\' names{nNam} '\innerMaskLayer2']);
        
        save(['..\' names{nNam} '\certerAndRadiusPerZ.mat'],'centers','radiiBasalLayer1','radiiApicalLayer1','radiiBasalLayer2','radiiApicalLayer2');
    else
        [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getMeristemPerSurfaces(uint16(img3d),names{nNam});        
        getVertices();
    end
    
%     save(['..\' names{nNam} '\cellsAndSurfacesPerLayer.mat'],'-v7.3','layer1','layer2','setOfCells')

    draw3dSurfaces(setOfCells,layer1,layer2,names,nNam)

end