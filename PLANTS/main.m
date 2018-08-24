clear
close all
names={'Hypocotyl A','Hypocotyl B','katanin meristem A',...
    'katanin meristem B','WT meristem A','WT meristem B','root A','root B'};
    
addpath(genpath('src'))
for nNam=2%length(names)
    if contains(names{nNam},'Hypocot')
        rangeY=[700,1400];
        [layer1,layer2,setOfCells,verticesInfoLayer1,verticesInfoLayer2]=getHypocotylSurfaces(names{nNam},rangeY);      
        connectVertices(names{nNam},verticesInfoLayer1,verticesInfoLayer2,rangeY);
    else
        [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getMeristemPerSurfaces(names{nNam});        
    end   
end