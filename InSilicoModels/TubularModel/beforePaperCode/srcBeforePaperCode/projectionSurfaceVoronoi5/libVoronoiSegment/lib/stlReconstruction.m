function stlReconstruction(info3DCell,path2save,numImage)
    addpath lib
    cMap=round(jet(100)*255);

    %%load info3DCell 

    for i=1:size(info3DCell,1)
        [x,y,z]=findND(info3DCell{i}.region);
        coord=[x,y,z];
        shp=alphaShape(coord,5);
        [F,V]=shp.boundaryFacets;
        stlwrite([path2save 'Image_' num2str(numImage) 'sltCell' num2str(i) '.stl'],F,V,'FaceColor',cMap(i,:)) 
    end

end

