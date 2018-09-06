function [layer1,layer2,setOfCells,verticesInfoLayer1,verticesInfoLayer2] = getHypocotylSurfaces(sampleName,rangeY,resizeFactor)

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
    
    %% Get filled surfaces using the closest point to the wrapping
   [wrapping1.outerSurface,wrapping1.innerSurface,wrapping2.outerSurface,wrapping2.innerSurface] = fillingLayersColHypocotyl(layer1,layer2,rangeY,resizeFactor,['data\' sampleName '\']);
    disp('3 - layers closest point')
    
    %% Get neighbours of the wrapping
    if exist(['data\' sampleName '\neighboursInfoClosestPoint.mat'],'file') 
        load(['data\' sampleName '\neighboursInfoClosestPoint.mat'],'neighbourhoodInfoL1Outer','neighbourhoodInfoL1Inner','neighbourhoodInfoL2Outer','neighbourhoodInfoL2Inner')
    else
        [neighbourhoodInfoL1Outer] = calculate_neighbours3D_closestPoint(wrapping1.outerSurface);
        [neighbourhoodInfoL1Inner] = calculate_neighbours3D_closestPoint(wrapping1.innerSurface);
        [neighbourhoodInfoL2Outer] = calculate_neighbours3D_closestPoint(wrapping2.outerSurface);
        [neighbourhoodInfoL2Inner] = calculate_neighbours3D_closestPoint(wrapping2.innerSurface);
        save(['data\' sampleName '\neighboursInfoClosestPoint.mat'],'-v7.3','neighbourhoodInfoL1Outer','neighbourhoodInfoL1Inner','neighbourhoodInfoL2Outer','neighbourhoodInfoL2Inner')
    end
    
    disp('4 - neighbours closest point')
    
    %% Get vertices from surfaces
    if ~exist(['data\' sampleName '\verticesSurfaces.mat'],'file')
        verticesInfoLayer1.Outer=getVertices3D(imresize3(layer1.outerSurface,resizeFactor),setOfCells.Layer1,neighbourhoodInfo);
        verticesInfoLayer1.Outer.verticesPerCell(verticesInfoLayer1.Outer.verticesPerCell(:,2)<rangeY(1) | verticesInfoLayer1.Outer.verticesPerCell(:,2)>rangeY(2),:)=[];
        verticesInfoLayer1.Outer.verticesPerCell(:,2)=verticesInfoLayer1.Outer.verticesPerCell(:,2)-rangeY(1)+1;
        
        verticesInfoLayer1.Inner=getVertices3D(imresize3(layer1.innerSurface,resizeFactor),setOfCells.Layer1,neighbourhoodInfo);
        verticesInfoLayer1.Inner.verticesPerCell(verticesInfoLayer1.Inner.verticesPerCell(:,2)<rangeY(1) | verticesInfoLayer1.Inner.verticesPerCell(:,2)>rangeY(2),:)=[];
        verticesInfoLayer1.Inner.verticesPerCell(:,2)=verticesInfoLayer1.Inner.verticesPerCell(:,2)-rangeY(1)+1;
        
        verticesInfoLayer2.Outer=getVertices3D(imresize3(layer2.outerSurface,resizeFactor),setOfCells.Layer2,neighbourhoodInfo);
        verticesInfoLayer2.Outer.verticesPerCell(verticesInfoLayer2.Outer.verticesPerCell(:,2)<rangeY(1) | verticesInfoLayer2.Outer.verticesPerCell(:,2)>rangeY(2),:)=[];
        verticesInfoLayer2.Outer.verticesPerCell(:,2)=verticesInfoLayer2.Outer.verticesPerCell(:,2)-rangeY(1)+1;
       
        verticesInfoLayer2.Inner=getVertices3D(imresize3(layer2.innerSurface,resizeFactor),setOfCells.Layer2,neighbourhoodInfo);
        verticesInfoLayer2.Inner.verticesPerCell(verticesInfoLayer2.Inner.verticesPerCell(:,2)<rangeY(1) | verticesInfoLayer2.Inner.verticesPerCell(:,2)>rangeY(2),:)=[];
        verticesInfoLayer2.Inner.verticesPerCell(:,2)=verticesInfoLayer2.Inner.verticesPerCell(:,2)-rangeY(1)+1;
        
        save(['data\' sampleName '\verticesSurfaces.mat'],'verticesInfoLayer1','verticesInfoLayer2')
    else
        load(['data\' sampleName '\verticesSurfaces.mat'],'verticesInfoLayer1','verticesInfoLayer2')
    end
        
    disp('5 - vertices captured')
    
    %% Get vertices from wrapping
    if ~exist(['data\' sampleName '\verticesWrapping.mat'],'file')
        verticesInfoWrapping1.Outer=getVertices3D(wrapping1.outerSurface,unique(wrapping1.outerSurface),neighbourhoodInfoL1Outer);
        verticesInfoWrapping1.Inner=getVertices3D(wrapping1.innerSurface,unique(wrapping1.innerSurface),neighbourhoodInfoL1Inner);
        verticesInfoWrapping2.Outer=getVertices3D(wrapping2.outerSurface,unique(wrapping2.outerSurface),neighbourhoodInfoL2Outer);
        verticesInfoWrapping2.Inner=getVertices3D(wrapping2.innerSurface,unique(wrapping2.innerSurface),neighbourhoodInfoL2Inner);
        save(['data\' sampleName '\verticesWrapping.mat'],'verticesInfoWrapping1','verticesInfoWrapping2')
    else
        load(['data\' sampleName '\verticesWrapping.mat'],'verticesInfoWrapping1','verticesInfoWrapping2')
    end
        
    disp('6 - vertices captured in wrapping')
    
    %% Get center and axes length from hypocotyl
    if ~exist(['data\' sampleName '\maskLayers\certerAndRadiusPerZ.mat'],'file')
        
        outerLayer1Limit=imresize3(layer1.outerSurface,resizeFactor);
        innerLayer1Limit=imresize3(layer1.innerSurface,resizeFactor);
        outerLayer2Limit=imresize3(layer2.outerSurface,resizeFactor);
        innerLayer2Limit=imresize3(layer2.innerSurface,resizeFactor);
        [centers, radiiBasalLayer1] = calculateCenterRadiusCylSection(outerLayer1Limit(:,rangeY(1):rangeY(2),:),setOfCells.Layer1,['data\' sampleName '\maskLayers\outerMaskLayer1']);
        [~, radiiApicalLayer1] = calculateCenterRadiusCylSection(innerLayer1Limit(:,rangeY(1):rangeY(2),:),setOfCells.Layer1,['data\' sampleName '\maskLayers\innerMaskLayer1']);
        [~, radiiBasalLayer2] = calculateCenterRadiusCylSection(outerLayer2Limit(:,rangeY(1):rangeY(2),:),setOfCells.Layer2,['data\' sampleName '\maskLayers\outerMaskLayer2']);
        [~, radiiApicalLayer2] = calculateCenterRadiusCylSection(innerLayer2Limit(:,rangeY(1):rangeY(2),:),setOfCells.Layer2,['data\' sampleName '\maskLayers\innerMaskLayer2']);
        save(['data\' sampleName '\maskLayers\certerAndRadiusPerZ.mat'],'centers','radiiBasalLayer1','radiiApicalLayer1','radiiBasalLayer2','radiiApicalLayer2');               
    end
    
    disp('7 - get centroids and infered cylinder axes')
       
%     %% draw surfaces
%     draw3dSurfaces(setOfCells,layer1,layer2,sampleName)
%     disp('**surfaces drawn')
end
