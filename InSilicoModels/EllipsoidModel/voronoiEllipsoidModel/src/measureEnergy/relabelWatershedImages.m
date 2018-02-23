function [maskOuter,maskInner]=relabelWatershedImages(acumCellProjectionsOuter,acumCellProjectionsInner,projOuterWat,projInnerWat)


    %outer relabel
    centProjOuter=regionprops(acumCellProjectionsOuter,'Centroid');
    centProjOuter=round(cat(1,centProjOuter.Centroid));
    centProjOuter=[centProjOuter(:,2),centProjOuter(:,1)];
    maskOuter=zeros(size(acumCellProjectionsOuter));
    cellsOuter=unique(acumCellProjectionsOuter);
    cellsOuter=cellsOuter(2:end);
        
    for i=1:length(cellsOuter)   
       maskOuter(projOuterWat==projOuterWat(centProjOuter(cellsOuter(i),1),centProjOuter(cellsOuter(i),2)))=acumCellProjectionsOuter(centProjOuter(cellsOuter(i),1),centProjOuter(cellsOuter(i),2));       
    end
    
    %inner relabel
    centProjInner=regionprops(acumCellProjectionsInner,'Centroid');
    centProjInner=round(cat(1,centProjInner.Centroid));
    centProjInner=[centProjInner(:,2),centProjInner(:,1)];
    
    maskInner=zeros(size(acumCellProjectionsInner));

    cellsInner=unique(acumCellProjectionsInner);
    cellsInner=cellsInner(2:end);    
    for i=1:length(cellsInner)
       maskInner(projInnerWat==projInnerWat(centProjInner(cellsInner(i),1),centProjInner(cellsInner(i),2)))=acumCellProjectionsInner(centProjInner(cellsInner(i),1),centProjInner(cellsInner(i),2));       
    end
    
end

