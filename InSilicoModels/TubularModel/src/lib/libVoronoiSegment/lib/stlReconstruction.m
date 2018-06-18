
addpath lib
cMap=round(jet(100)*255);

%%load info3DCell 

for i=1:size(info3DCell,1)
    [x,y,z]=findND(info3DCell{i}.region);
    coord=[x,y,z];
    shp=alphaShape(coord,5);
    [F,V]=shp.boundaryFacets;
    stlwrite(['../reconstructionVoronoiCylindricalSegment/stlReconstruction/testCol' num2str(i) '.stl'],F,V,'FaceColor',cMap(i,:)) 
    
end

