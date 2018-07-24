function [layer1,layer2,setOfCells,verticesInfoLayer1,verticesInfoLayer2] = getHypocotylSurfaces(sampleName)

    load(['..\' sampleName '\image3d_' strrep(sampleName,' ','_') '.mat'],'img3d');
    img3d=uint16(img3d);

    %% Get neighbours 3d
    if ~exist(['..\' sampleName '\neighboursInfo.mat'],'file')
        [neighbourhoodInfo] = calculate_neighbours3D(img3d);
        save(['..\' sampleName '\neighboursInfo.mat'],'-v7.3','neighbourhoodInfo')
    else
        load(['..\' sampleName '\neighboursInfo.mat'],'neighbourhoodInfo')
    end
    
    %% Get surfaces 1 and 2 with its cells   
    if exist(['..\' sampleName '\cellsAndSurfacesPerLayer.mat'],'file')
        load(['..\' sampleName '\cellsAndSurfacesPerLayer.mat'],'layer1','layer2','setOfCells')
    else
        if exist(['..\' sampleName '\cellsLayer1Correction.mat'],'file') 
            load(['..\' sampleName '\cellsLayer1Correction.mat'],'cellsCorrectLayer1')
            [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getColHypocotylPerSurfaces(neighbourhoodInfo,uint16(img3d),cellsCorrectLayer1);
        else
            [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getColHypocotylPerSurfaces(neighbourhoodInfo,uint16(img3d),[]);
        end
        save(['..\' sampleName '\cellsAndSurfacesPerLayer.mat'],'-v7.3','layer1','layer2','setOfCells')
    end
        
    %% Get vertices from surfaces
    if ~exist(['..\' sampleName '\verticesSurfaces.mat'],'file')
        verticesInfoLayer1.Outer=getVertices3D(layer1.outerSurface,setOfCells.Layer1,neighbourhoodInfo);
        verticesInfoLayer1.Inner=getVertices3D(layer1.innerSurface,setOfCells.Layer1,neighbourhoodInfo);
        verticesInfoLayer2.Outer=getVertices3D(layer2.outerSurface,setOfCells.Layer2,neighbourhoodInfo);
        verticesInfoLayer2.Inner=getVertices3D(layer2.innerSurface,setOfCells.Layer2,neighbourhoodInfo);
        save(['..\' sampleName '\verticesSurfaces.mat'],'verticesInfoLayer1','verticesInfoLayer2')
    else
        load(['..\' sampleName '\verticesSurfaces.mat'],'verticesInfoLayer1','verticesInfoLayer2')
    end
        
    %% Get center and axes length from hypocotyl
    if ~exist(['..\' sampleName '\certerAndRadiusPerZ.mat'],'file')
        [centers, radiiBasalLayer1] = calculateCenterRadiusCylSection(layer1.outerSurface,setOfCells.Layer1,['..\' sampleName '\outerMaskLayer1']);
        [~, radiiApicalLayer1] = calculateCenterRadiusCylSection(layer1.innerSurface,setOfCells.Layer1,['..\' sampleName '\innerMaskLayer1']);
        [~, radiiBasalLayer2] = calculateCenterRadiusCylSection(layer2.outerSurface,setOfCells.Layer2,['..\' sampleName '\outerMaskLayer2']);
        [~, radiiApicalLayer2] = calculateCenterRadiusCylSection(layer2.innerSurface,setOfCells.Layer2,['..\' sampleName '\innerMaskLayer2']);
        save(['..\' sampleName '\certerAndRadiusPerZ.mat'],'centers','radiiBasalLayer1','radiiApicalLayer1','radiiBasalLayer2','radiiApicalLayer2');               
    end
       
    %% draw surfaces
    %     draw3dSurfaces(setOfCells,layer1,layer2,names,nNam)
end
