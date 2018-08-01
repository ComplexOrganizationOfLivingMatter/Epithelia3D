function [layer1,layer2,setOfCells,verticesInfoLayer1,verticesInfoLayer2] = getHypocotylSurfaces(sampleName)

    disp(sampleName)

    load(['data\' sampleName '\image3d_' strrep(sampleName,' ','_') '.mat'],'img3d');
    img3d=uint16(img3d);

    %% Get neighbours 3d
    if ~exist(['data\' sampleName '\neighboursInfo.mat'],'file')
        [neighbourhoodInfo] = calculate_neighbours3D(img3d);
        save(['data\' sampleName '\neighboursInfo.mat'],'-v7.3','neighbourhoodInfo')
    else
        load(['data\' sampleName '\neighboursInfo.mat'],'neighbourhoodInfo')
    end
    
    disp('1 - neighbours calculated')
    
    %% Get surfaces 1 and 2 with its cells   
    if exist(['data\' sampleName '\cellsAndSurfacesPerLayer.mat'],'file')
        load(['data\' sampleName '\cellsAndSurfacesPerLayer.mat'],'layer1','layer2','setOfCells')
    else
        if exist(['data\' sampleName '\cellsLayer1Correction.mat'],'file') 
            load(['data\' sampleName '\cellsLayer1Correction.mat'],'cellsCorrectLayer1')
            [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getColHypocotylPerSurfaces(neighbourhoodInfo,uint16(img3d),cellsCorrectLayer1);
        else
            [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getColHypocotylPerSurfaces(neighbourhoodInfo,uint16(img3d),[]);
        end
        save(['data\' sampleName '\cellsAndSurfacesPerLayer.mat'],'-v7.3','layer1','layer2','setOfCells')
    end
        
    disp('2 - layers captured')

    %% Get vertices from surfaces
    if ~exist(['data\' sampleName '\verticesSurfaces.mat'],'file')
        verticesInfoLayer1.Outer=getVertices3D(layer1.outerSurface,setOfCells.Layer1,neighbourhoodInfo);
        verticesInfoLayer1.Inner=getVertices3D(layer1.innerSurface,setOfCells.Layer1,neighbourhoodInfo);
        verticesInfoLayer2.Outer=getVertices3D(layer2.outerSurface,setOfCells.Layer2,neighbourhoodInfo);
        verticesInfoLayer2.Inner=getVertices3D(layer2.innerSurface,setOfCells.Layer2,neighbourhoodInfo);
        save(['data\' sampleName '\verticesSurfaces.mat'],'verticesInfoLayer1','verticesInfoLayer2')
    else
        load(['data\' sampleName '\verticesSurfaces.mat'],'verticesInfoLayer1','verticesInfoLayer2')
    end
        
    disp('3 - vertices captured')
    
    %% Get center and axes length from hypocotyl
    if ~exist(['data\' sampleName '\certerAndRadiusPerZ.mat'],'file')
        [centers, radiiBasalLayer1] = calculateCenterRadiusCylSection(layer1.outerSurface,setOfCells.Layer1,['data\' sampleName '\maskLayers\outerMaskLayer1']);
        [~, radiiApicalLayer1] = calculateCenterRadiusCylSection(layer1.innerSurface,setOfCells.Layer1,['data\' sampleName '\maskLayers\innerMaskLayer1']);
        [~, radiiBasalLayer2] = calculateCenterRadiusCylSection(layer2.outerSurface,setOfCells.Layer2,['data\' sampleName '\maskLayers\outerMaskLayer2']);
        [~, radiiApicalLayer2] = calculateCenterRadiusCylSection(layer2.innerSurface,setOfCells.Layer2,['data\' sampleName '\maskLayers\innerMaskLayer2']);
        save(['data\' sampleName '\maskLayers\certerAndRadiusPerZ.mat'],'centers','radiiBasalLayer1','radiiApicalLayer1','radiiBasalLayer2','radiiApicalLayer2');               
    end
    
    disp('4 - get centroids and infered cylinder axes')
       
    %% draw surfaces
    draw3dSurfaces(setOfCells,layer1,layer2,sampleName)
    disp('**surfaces drawn')
end
