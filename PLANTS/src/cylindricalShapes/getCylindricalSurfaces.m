function [setOfCells] = getCylindricalSurfaces(folder,sampleName,rangeMajorAxis,zScaleFactorHyp)


    disp(sampleName)
    if ~exist([folder sampleName '\rotatedImage3d_' strrep(sampleName,' ','_') '.mat'],'file')
        img3d = readImg3d(folder, strrep(sampleName,' ','_'),zScaleFactorHyp);
        %function for rotate 3d image toward the Y axis.
        img3d = rotateImg3(img3d);
        [x,y,z]=ind2sub(size(img3d),find(img3d>0));
        cropImg = img3d(min(x):max(x),min(y):max(y),min(z):max(z));
        img3d = addTipsImg3D(2,cropImg);
        paint3D((imresize3(img3d,0.1,'nearest')>0))
        save([folder sampleName '\rotatedImage3d_' strrep(sampleName,' ','_') '.mat'],'-v7.3','img3d');
    else
        if ~exist([folder sampleName '\maskLayers\certerAndRadiusPerZ.mat'],'file') || ~exist([folder sampleName '\cellsAndSurfacesPerLayer.mat'],'file')
            load([folder sampleName '\rotatedImage3d_' strrep(sampleName,' ','_') '.mat'],'img3d');
        end
    end
    
    disp('1 - building and reorienting image')
     
    %% Get surfaces 1 and 2 with its cells   
    if exist([folder sampleName '\maskLayers\certerAndRadiusPerZ.mat'],'file')
        load([folder sampleName '\cellsAndSurfacesPerLayer.mat'],'setOfCells')
    else
        if exist([folder sampleName '\cellsAndSurfacesPerLayer.mat'],'file') 
            load([folder sampleName '\cellsAndSurfacesPerLayer.mat'],'layer1','layer2','layer3','layer1Limited','layer2Limited','setOfCells')
        else
            if exist([folder sampleName '\cellsLayer1Correction.mat'],'file') 
                load([folder sampleName '\cellsLayer1Correction.mat'],'cellsCorrectLayer1')
                [layer1,layer2,layer3,setOfCells.Layer1,setOfCells.Layer2,setOfCells.Layer3] = getSplittedCylinderPerSurfaces(img3d,cellsCorrectedLayer1);
            else
                [layer1,layer2,layer3,setOfCells.Layer1,setOfCells.Layer2,setOfCells.Layer3] = getSplittedCylinderPerSurfaces(img3d,[]);
            end
            layer1Limited = layer1(rangeMajorAxis(1):rangeMajorAxis(2),:,:);
            layer2Limited = layer2(rangeMajorAxis(1):rangeMajorAxis(2),:,:);
            

            save([folder sampleName '\cellsAndSurfacesPerLayer.mat'],'-v7.3','layer1','layer2','layer3','layer1Limited','layer2Limited','setOfCells')

        end
        
        disp('2 - layers captured')
       
        [centers{1},centers{2}, radiiBasalLayer1, radiiApicalLayer1] = calculateCenterRadiusCylSection(layer1Limited,layer2Limited,rangeMajorAxis,folder,sampleName,'Layer1');
        [centers{3},centers{4}, radiiBasalLayer2, radiiApicalLayer2] = calculateCenterRadiusCylSection(layer2Limited,layer3(rangeMajorAxis(1):rangeMajorAxis(2),:,:),rangeMajorAxis,folder,sampleName,'Layer2');
 
        save([folder sampleName '\maskLayers\certerAndRadiusPerZ.mat'],'centers','radiiBasalLayer1','radiiApicalLayer1','radiiBasalLayer2','radiiApicalLayer2');               
        disp('3 - get centroids and infered cylinder axes')
    end
    
    

end
