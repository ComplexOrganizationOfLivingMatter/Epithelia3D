function [layer1Limited,layer2Limited,setOfCells] = getCylindricalSurfaces(sampleName,rangeY,zScaleFactorHyp)

    disp(sampleName)
    if ~exist(['data\' sampleName '\image3d_' strrep(sampleName,' ','_') 'Rotated.mat'],'file')
        img3d = readImg3d(sampleName,zScaleFactorHyp);
        img3d = rotateImg3(img3d);      
    else
        load(['data\rotatedImage3d_' sampleName '.mat'],'rotatedImg3d');
        img3d = rotatedImage3d;
    end
    
    disp('1 - neighbours calculated')
     
    %% Get surfaces 1 and 2 with its cells   
    if exist(['data\' sampleName '\cellsAndSurfacesPerLayer.mat'],'file')
        load(['data\' sampleName '\cellsAndSurfacesPerLayer.mat'],'layer1','layer2','layer1Limited','layer2Limited','setOfCells')
    else
        if exist(['data\' sampleName '\cellsLayer1Correction.mat'],'file') 
            load(['data\' sampleName '\cellsLayer1Correction.mat'],'cellsCorrectLayer1')
            [layer1,layer2,setOfCells.Layer1,setOfCells.Layer2] = getSplittedCylinderPerSurfaces(img3d,cellsCorrectedLayer1);
%             [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getSplittedCylinderPerSurfaces(neighbourhoodInfo,uint16(img3d),cellsCorrectLayer1);
        else
            [layer1,layer2,setOfCells.Layer1,setOfCells.Layer2] = getSplittedCylinderPerSurfaces(img3d,[]);
%             [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getSplittedCylinderPerSurfaces(neighbourhoodInfo,uint16(img3d),[]);
        end

        layer1Limited = layer1(:,rangeY(1):rangeY(2),:);
        layer2Limited = layer2(:,rangeY(1):rangeY(2),:);

        save(['data\' sampleName '\cellsAndSurfacesPerLayer.mat'],'-v7.3','layer1','layer2','layer1Limited','layer2Limited','setOfCells')
        save(['data\' sampleName '\cellsAndSurfacesPerLayer.mat'],'-v7.3','layer1','layer2','layer1Limited','layer2Limited','setOfCells')

    end
        
    disp('2 - layers captured')
       
    %% Get center and axes length from hypocotyl
    if ~exist(['data\' sampleName '\maskLayers\certerAndRadiusPerZ.mat'],'file')
        
        [centers{1},centers{2}, radiiBasalLayer1, radiiApicalLayer1] = calculateCenterRadiusCylSection(layer1,sampleName,'Layer1');
        [centers{3},centers{4}, radiiBasalLayer2, radiiApicalLayer2] = calculateCenterRadiusCylSection(layer2,['data\' sampleName '\maskLayers\'],'outerMaskLayer1');

         save(['data\' sampleName '\maskLayers\certerAndRadiusPerZ.mat'],'centers','radiiBasalLayer1','radiiApicalLayer1','radiiBasalLayer2','radiiApicalLayer2');               
        
    end
    
    disp('3 - get centroids and infered cylinder axes')

end
