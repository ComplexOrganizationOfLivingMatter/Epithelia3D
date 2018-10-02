function [layer1Limited,layer2Limited,wrapping1,wrapping2,setOfCells,verticesInfoLayer1,verticesInfoLayer2,verticesInfoWrapping1,verticesInfoWrapping2] = getHypocotylSurfaces(sampleName,rangeY,resizeFactor)

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
        load(['data\' sampleName '\cellsAndSurfacesPerLayer.mat'],'layer1','layer2','layer1Limited','layer2Limited','setOfCells')
    else
        if exist(['data\' sampleName '\cellsLayer1Correction.mat'],'file') 
            load(['data\' sampleName '\cellsLayer1Correction.mat'],'cellsCorrectLayer1')
            [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getColHypocotylPerSurfaces(neighbourhoodInfo,uint16(img3d),cellsCorrectLayer1);
        else
            [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getColHypocotylPerSurfaces(neighbourhoodInfo,uint16(img3d),[]);
        end
        outerLayer1Limit=imresize3(layer1.outerSurface,resizeFactor,'Method','nearest');
        innerLayer1Limit=imresize3(layer1.innerSurface,resizeFactor,'Method','nearest');
        outerLayer2Limit=imresize3(layer2.outerSurface,resizeFactor,'Method','nearest');
        innerLayer2Limit=imresize3(layer2.innerSurface,resizeFactor,'Method','nearest');

        layer1Limited.outerSurface=outerLayer1Limit(:,rangeY(1):rangeY(2),:);
        layer1Limited.innerSurface=innerLayer1Limit(:,rangeY(1):rangeY(2),:);
        layer2Limited.outerSurface=outerLayer2Limit(:,rangeY(1):rangeY(2),:);
        layer2Limited.innerSurface=innerLayer2Limit(:,rangeY(1):rangeY(2),:);

        save(['data\' sampleName '\cellsAndSurfacesPerLayer.mat'],'-v7.3','layer1','layer2','layer1Limited','layer2Limited','setOfCells')
    end
        
    disp('2 - layers captured')
    
%     %% Get filled surfaces using the closest point to the wrapping
%    [wrapping1.outerSurface,wrapping1.innerSurface,wrapping2.outerSurface,wrapping2.innerSurface] = fillingLayersColHypocotyl(layer1,layer2,rangeY,resizeFactor,['data\' sampleName '\']);
%     disp('3 - layers closest point')
    wrapping1=[];
    wrapping2=[];
    verticesInfoWrapping1=[];
    verticesInfoWrapping2=[];
%     
%     %% Get neighbours of the wrapping
%     if exist(['data\' sampleName '\neighboursInfoClosestPoint.mat'],'file') 
%         load(['data\' sampleName '\neighboursInfoClosestPoint.mat'],'neighbourhoodInfoL1Outer','neighbourhoodInfoL1Inner','neighbourhoodInfoL2Outer','neighbourhoodInfoL2Inner')
%     else
%         [neighbourhoodInfoL1Outer] = calculate_neighbours3D_closestPoint(wrapping1.outerSurface);
%         [neighbourhoodInfoL1Inner] = calculate_neighbours3D_closestPoint(wrapping1.innerSurface);
%         [neighbourhoodInfoL2Outer] = calculate_neighbours3D_closestPoint(wrapping2.outerSurface);
%         [neighbourhoodInfoL2Inner] = calculate_neighbours3D_closestPoint(wrapping2.innerSurface);
%         save(['data\' sampleName '\neighboursInfoClosestPoint.mat'],'-v7.3','neighbourhoodInfoL1Outer','neighbourhoodInfoL1Inner','neighbourhoodInfoL2Outer','neighbourhoodInfoL2Inner')
%     end
%     
%     disp('4 - neighbours closest point')
    
%     %% Get vertices from surfaces
%     if ~exist(['data\' sampleName '\verticesSurfaces.mat'],'file')
%         verticesInfoLayer1.Outer=getVertices3D(layer1.outerSurface,setOfCells.Layer1,neighbourhoodInfo);
%         verticesInfoLayer1.Outer.verticesPerCell=round(verticesInfoLayer1.Outer.verticesPerCell*resizeFactor);
%         idVertOutlayers=verticesInfoLayer1.Outer.verticesPerCell(:,2)<rangeY(1) | verticesInfoLayer1.Outer.verticesPerCell(:,2)>rangeY(2);
%         verticesInfoLayer1.Outer.verticesPerCell(idVertOutlayers,:)=[];
%         verticesInfoLayer1.Outer.verticesPerCell(:,2)=verticesInfoLayer1.Outer.verticesPerCell(:,2)-rangeY(1)+1;
%         verticesInfoLayer1.Outer.verticesConnectCells(idVertOutlayers,:)=[];
%         
%         verticesInfoLayer1.Inner=getVertices3D(layer1.innerSurface,setOfCells.Layer1,neighbourhoodInfo);
%         verticesInfoLayer1.Inner.verticesPerCell=round(verticesInfoLayer1.Inner.verticesPerCell*resizeFactor);
%         idVertOutlayers=verticesInfoLayer1.Inner.verticesPerCell(:,2)<rangeY(1) | verticesInfoLayer1.Inner.verticesPerCell(:,2)>rangeY(2);
%         verticesInfoLayer1.Inner.verticesPerCell(idVertOutlayers,:)=[];
%         verticesInfoLayer1.Inner.verticesPerCell(:,2)=verticesInfoLayer1.Inner.verticesPerCell(:,2)-rangeY(1)+1;
%         verticesInfoLayer1.Inner.verticesConnectCells(idVertOutlayers,:)=[];
% 
%         verticesInfoLayer2.Outer=getVertices3D(layer1.outerSurface,setOfCells.Layer1,neighbourhoodInfo);
%         verticesInfoLayer2.Outer.verticesPerCell=round(verticesInfoLayer2.Outer.verticesPerCell*resizeFactor);
%         idVertOutlayers=verticesInfoLayer2.Outer.verticesPerCell(:,2)<rangeY(1) | verticesInfoLayer2.Outer.verticesPerCell(:,2)>rangeY(2);
%         verticesInfoLayer2.Outer.verticesPerCell(idVertOutlayers,:)=[];
%         verticesInfoLayer2.Outer.verticesPerCell(:,2)=verticesInfoLayer2.Outer.verticesPerCell(:,2)-rangeY(1)+1;
%         verticesInfoLayer2.Outer.verticesConnectCells(idVertOutlayers,:)=[];
%         
%         verticesInfoLayer2.Inner=getVertices3D(layer1.innerSurface,setOfCells.Layer1,neighbourhoodInfo);
%         verticesInfoLayer2.Inner.verticesPerCell=round(verticesInfoLayer2.Inner.verticesPerCell*resizeFactor);
%         idVertOutlayers=verticesInfoLayer2.Inner.verticesPerCell(:,2)<rangeY(1) | verticesInfoLayer2.Inner.verticesPerCell(:,2)>rangeY(2);
%         verticesInfoLayer2.Inner.verticesPerCell(idVertOutlayers,:)=[];
%         verticesInfoLayer2.Inner.verticesPerCell(:,2)=verticesInfoLayer2.Inner.verticesPerCell(:,2)-rangeY(1)+1;
%         verticesInfoLayer2.Inner.verticesConnectCells(idVertOutlayers,:)=[];
%         
%         save(['data\' sampleName '\verticesSurfaces.mat'],'verticesInfoLayer1','verticesInfoLayer2')
%     else
%         load(['data\' sampleName '\verticesSurfaces.mat'],'verticesInfoLayer1','verticesInfoLayer2')
%     end
%         
%     disp('5 - vertices captured')
    
%     %% Get vertices from wrapping
%     if ~exist(['data\' sampleName '\verticesWrapping.mat'],'file')
%         verticesInfoWrapping1.Outer=getVertices3D(wrapping1.outerSurface,unique(wrapping1.outerSurface),neighbourhoodInfoL1Outer);
%         verticesInfoWrapping1.Inner=getVertices3D(wrapping1.innerSurface,unique(wrapping1.innerSurface),neighbourhoodInfoL1Inner);
%         verticesInfoWrapping2.Outer=getVertices3D(wrapping2.outerSurface,unique(wrapping2.outerSurface),neighbourhoodInfoL2Outer);
%         verticesInfoWrapping2.Inner=getVertices3D(wrapping2.innerSurface,unique(wrapping2.innerSurface),neighbourhoodInfoL2Inner);
%         save(['data\' sampleName '\verticesWrapping.mat'],'verticesInfoWrapping1','verticesInfoWrapping2')
%     else
%         load(['data\' sampleName '\verticesWrapping.mat'],'verticesInfoWrapping1','verticesInfoWrapping2')
%     end
%         
%     disp('6 - vertices captured in wrapping')
    
    verticesInfoLayer1 = [];
    verticesInfoLayer2 = [];
    
    %% Get center and axes length from hypocotyl
%     if ~exist(['data\' sampleName '\maskLayers\certerAndRadiusPerZ.mat'],'file')
        
        [centers{1}, radiiBasalLayer1] = calculateCenterRadiusCylSection(layer1.outerSurface,['data\' sampleName '\maskLayers\outerMaskLayer1']);
        [centers{2}, radiiApicalLayer1] = calculateCenterRadiusCylSection(layer1.innerSurface,['data\' sampleName '\maskLayers\innerMaskLayer1']);
        [centers{3}, radiiBasalLayer2] = calculateCenterRadiusCylSection(layer2.outerSurface,['data\' sampleName '\maskLayers\outerMaskLayer2']);
        [centers{4}, radiiApicalLayer2] = calculateCenterRadiusCylSection(layer2.innerSurface,['data\' sampleName '\maskLayers\innerMaskLayer2']);
        save(['data\' sampleName '\maskLayers\certerAndRadiusPerZ.mat'],'centers','radiiBasalLayer1','radiiApicalLayer1','radiiBasalLayer2','radiiApicalLayer2');               
        
%     end
    
    disp('7 - get centroids and infered cylinder axes')
       
%     %% Get center and axes length from hypocotyl
%     if ~exist(['data\' sampleName '\maskLayers\certerAndRadiusPerZWrapping.mat'],'file')
% 
%         [centers{1}, radiiBasalLayer1] = calculateCenterRadiusCylSection(wrapping1.outerSurface,['data\' sampleName '\maskLayers\outerWrappingMaskLayer1']);
%         [centers{2}, radiiApicalLayer1] = calculateCenterRadiusCylSection(wrapping1.innerSurface,['data\' sampleName '\maskLayers\innerWrappingMaskLayer1']);
%         [centers{3}, radiiBasalLayer2] = calculateCenterRadiusCylSection(wrapping2.outerSurface,['data\' sampleName '\maskLayers\outerWrappingMaskLayer2']);
%         [centers{4}, radiiApicalLayer2] = calculateCenterRadiusCylSection(wrapping2.innerSurface,['data\' sampleName '\maskLayers\innerWrappingMaskLayer2']); 
%         save(['data\' sampleName '\maskLayers\certerAndRadiusPerZWrapping.mat'],'centers','radiiBasalLayer1','radiiApicalLayer1','radiiBasalLayer2','radiiApicalLayer2');               
%     end
%     
%     disp('8 - get centroids and radius from wrapping cylinder axes')
    
    
%     %% draw surfaces
%     draw3dSurfaces(setOfCells,layer1,layer2,sampleName)
%     disp('**surfaces drawn')
end
