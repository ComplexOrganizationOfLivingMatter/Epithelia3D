clear
close all
names={'Hypocotyl A','Hypocotyl B','katanin meristem A',...
    'katanin meristem B','WT meristem A','WT meristem B','root A','root B'};
    
addpath(genpath('src'))

zScaleFactorHyp = [0.4,0.7];

for nNam=1:2%length(names)
    if contains(names{nNam},'Hypocot')
        resizeFactor=0.3;
        rangeY=round([700,1400]);
        
        %% This complex process is only for detecting the cells belonging to each surface
        if ~exist(['data/' names{nNam} '/unrolledHypocotyl.mat'],'file')
            [layer1,layer2,wrapping1,wrapping2,setOfCells,verticesInfoLayer1,verticesInfoLayer2,verticesInfoWrapping1,verticesInfoWrapping2]=getHypocotylSurfaces(names{nNam},rangeY*resizeFactor,resizeFactor,zScaleFactorHyp(nNam));      
            [unrolledImages] = unrollingHypocot(names{nNam},rangeY*resizeFactor,layer1,layer2);
            [~,cellsLayer1,cellsLayer2,~,~,~,~]=cleanAndGetMeasurements(['data/' names{nNam} '/'], unrolledImages);
            save(['data/' names{nNam} '/unrolledHypocotyl.mat'],'unrolledImages','cellsLayer1','cellsLayer2')
        else
            load(['data/' names{nNam} '/unrolledHypocotyl.mat'],'unrolledImages','cellsLayer1','cellsLayer2')
        end
        
        %% Once we have the layer' cells, it is possible get the unrolled Hypocotyl using normal vector extrapolations
        if ~exist(['data/' names{nNam} '/imagesOfLayers/layersClean.mat'],'file')
%             function that fill the Hyp perimeter using the vector imaginary with the centroid
            [layer1_3D,layer2_3D]=assingCells2maskPerim(names{nNam},rangeY,cellsLayer1,cellsLayer2);
            [unrolledImagesQuasiClean] = unrollingHypocot(names{nNam},rangeY,layer1_3D,layer2_3D);
            save(['data/' names{nNam} '/imagesOfLayers/layersClean.mat'],'layer1_3D','layer2_3D','unrolledImagesQuasiClean')

            [finalImages,~,~,finalCellsLayer1,finalCellsLayer2,noValidCellsLayer1,noValidCellsLayer2]=cleanUnrolledImages(['data/' names{nNam} '/'], unrolledImagesQuasiClean);
            save(['data/' names{nNam} '/imagesOfLayers/layersClean.mat'],'finalImages','finalCellsLayer1','finalCellsLayer2','noValidCellsLayer1','noValidCellsLayer2','-append')
        else
            load(['data/' names{nNam} '/imagesOfLayers/layersClean.mat'],'finalImages','finalCellsLayer1','finalCellsLayer2','noValidCellsLayer1','noValidCellsLayer2','layer1_3D','layer2_3D','unrolledImagesQuasiClean')
        end
        
        %% We get the cell properties
        getGeometricalFeaturesFrom2DImages(['data/' names{nNam} '/resultMeasurements/layer1'],finalImages(1:2),noValidCellsLayer1)      
        getGeometricalFeaturesFrom2DImages(['data/' names{nNam} '/resultMeasurements/layer2'],finalImages(3:4),noValidCellsLayer2)

    else
        [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getMeristemPerSurfaces(names{nNam});        
    end   
end