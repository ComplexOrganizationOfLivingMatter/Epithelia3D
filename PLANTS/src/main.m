clear
close all
names={'Hypocotyl A','Hypocotyl B','katanin meristem A',...
    'katanin meristem B','WT meristem A','WT meristem B','root A','root B'};
    
addpath(genpath('lib'))
for nNam=1:length(names)
    if contains(names{nNam},'Hypocot')
        [layer1,layer2,setOfCells,verticesInfoLayer1,verticesInfoLayer2]=getHypocotylSurfaces(names{nNam});      
    else
        [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getMeristemPerSurfaces(sampleName);        
    end   
end