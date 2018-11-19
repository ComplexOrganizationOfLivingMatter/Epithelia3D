function [layer1,layer2,setOfCells] = getCylindricalSurfaces(folder,sampleName,rangeY,zScaleFactorHyp)

    disp(sampleName)
    if ~exist([folder sampleName '\rotatedImage3d_' strrep(sampleName,' ','_') '.mat'],'file')
        img3d = readImg3d(strrep(sampleName,' ','_'),zScaleFactorHyp);
        %function for rotate 3d image toward the Y axis.
        img3d = rotateImg3(img3d);
        save([folder sampleName '\rotatedImage3d_' strrep(sampleName,' ','_') '.mat'],'-v7.3','img3d');
    else
        load([folder sampleName '\rotatedImage3d_' strrep(sampleName,' ','_') '.mat'],'img3d');
    end
    
    disp('1 - building and reorienting image')
     
    %% Get surfaces 1 and 2 with its cells   
    if exist([folder sampleName '\cellsAndSurfacesPerLayer.mat'],'file')
        load([folder sampleName '\cellsAndSurfacesPerLayer.mat'],'layer1','layer2','layer3','layer1Limited','layer2Limited','setOfCells')
    else
        if exist([folder sampleName '\cellsLayer1Correction.mat'],'file') 
            load([folder sampleName '\cellsLayer1Correction.mat'],'cellsCorrectLayer1')
            [layer1,layer2,layer3,setOfCells.Layer1,setOfCells.Layer2,setOfCells.Layer3] = getSplittedCylinderPerSurfaces(img3d,cellsCorrectedLayer1);
        else
            [layer1,layer2,layer3,setOfCells.Layer1,setOfCells.Layer2,setOfCells.Layer3] = getSplittedCylinderPerSurfaces(img3d,[]);
        end
        layer1Limited = layer1(:,rangeY(1):rangeY(2),:);
        layer2Limited = layer2(:,rangeY(1):rangeY(2),:);

        save([folder sampleName '\cellsAndSurfacesPerLayer.mat'],'-v7.3','layer1','layer2','layer3','layer1Limited','layer2Limited','setOfCells')

    end
        
    disp('2 - layers captured')
       
    %% Get center and axes length from hypocotyl
    if ~exist([folder sampleName '\maskLayers\certerAndRadiusPerZ.mat'],'file')
        
        [centers{1},centers{2}, radiiBasalLayer1, radiiApicalLayer1] = calculateCenterRadiusCylSection(layer1,layer2,sampleName,'Layer1');
        [centers{3},centers{4}, radiiBasalLayer2, radiiApicalLayer2] = calculateCenterRadiusCylSection(layer2,layer3,sampleName,'Layer2');
 
        save([folder sampleName '\maskLayers\certerAndRadiusPerZ.mat'],'centers','radiiBasalLayer1','radiiApicalLayer1','radiiBasalLayer2','radiiApicalLayer2');               
        
    end
    
    disp('3 - get centroids and infered cylinder axes')

end
