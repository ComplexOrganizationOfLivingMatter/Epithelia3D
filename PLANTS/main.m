clear
close all
names={'Hypocotyl A','Hypocotyl B','katanin meristem A',...
    'katanin meristem B','WT meristem A','WT meristem B','root A','root B'};
    
addpath(genpath('src'))
for nNam=1%length(names)
    if contains(names{nNam},'Hypocot')
        resizeFactor=0.3;
        rangeY=round([700,1400]*resizeFactor);
        [layer1,layer2,wrapping1,wrapping2,setOfCells,verticesInfoLayer1,verticesInfoLayer2,verticesInfoWrapping1,verticesInfoWrapping2]=getHypocotylSurfaces(names{nNam},rangeY,resizeFactor);      
       
        [totalMaskCyl]=extrapolatedImageAndVertices2DCylinder([names{nNam} '\maskLayers\certerAndRadiusPerZ.mat'],layer1,layer2,verticesInfoLayer1,verticesInfoLayer2);
        [totalMaskCylWrapping]=extrapolatedImageAndVertices2DCylinder([names{nNam} '\maskLayers\certerAndRadiusPerZWrapping.mat'],wrapping1,wrapping2,verticesInfoWrapping1,verticesInfoWrapping2);
    else
        [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getMeristemPerSurfaces(names{nNam});        
    end   
end