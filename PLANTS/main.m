clear
close all
names={'Hypocotyl A','Hypocotyl B','katanin meristem A',...
    'katanin meristem B','WT meristem A','WT meristem B','root A','root B'};
    
addpath(genpath('src'))
for nNam=1:2%length(names)
    if contains(names{nNam},'Hypocot')
        resizeFactor=0.3;
        rangeY=round([700,1400]*resizeFactor);
        
        if ~exist(['data/' names{nNam} '/unrolledHypocotyl.mat'],'file')
            [layer1,layer2,wrapping1,wrapping2,setOfCells,verticesInfoLayer1,verticesInfoLayer2,verticesInfoWrapping1,verticesInfoWrapping2]=getHypocotylSurfaces(names{nNam},rangeY,resizeFactor);      
            [unrolledImages] = unrollingHypocot(names{nNam}, '\maskLayers\certerAndRadiusPerZ.mat',layer1,layer2);
            [~,cellsLayer1,cellsLayer2,~,~]=cleanAndGetMeasurements(['data/' names{nNam} '/'], unrolledImages);
            save(['data/' names{nNam} '/unrolledHypocotyl.mat'],'unrolledImages','cellsLayer1','cellsLayer2')
        else
            load(['data/' names{nNam} '/unrolledHypocotyl.mat'],'unrolledImages','cellsLayer1','cellsLayer2')
        end

        [layer1ImprovingApical,layer2ImprovingApical]=assingCells2maskPerim(names{nNam},resizeFactor,rangeY,cellsLayer1,cellsLayer2);
        [unrolledImagesForApical] = unrollingHypocot(names{nNam}, '\maskLayers\certerAndRadiusPerZ.mat',layer1ImprovingApical,layer2ImprovingApical);
        [finalImages,~,~,finalCellsLayer1,finalCellsLayer2]=cleanAndGetMeasurements(['data/' names{nNam} '/'], unrolledImagesForApical);
        save(['data/' names{nNam} '/imagesOfLayers/layersClean.mat'],'finalImages','finalCellsLayer1','finalCellsLayer2')

%         [totalMaskCyl]=extrapolatedImageAndVertices2DCylinder([names{nNam} '\maskLayers\certerAndRadiusPerZ.mat'],layer1,layer2,verticesInfoLayer1,verticesInfoLayer2);
%         [totalMaskCylWrapping]=extrapolatedImageAndVertices2DCylinder([names{nNam} '\maskLayers\certerAndRadiusPerZWrapping.mat'],wrapping1,wrapping2,verticesInfoWrapping1,verticesInfoWrapping2);
    else
        [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getMeristemPerSurfaces(names{nNam});        
    end   
end