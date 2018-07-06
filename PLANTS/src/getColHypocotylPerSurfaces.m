function [outerSurfaceLayer1,innerSurfaceLayer1,outerSurfaceLayer2,innerSurfaceLayer2,cellsLayer1,cellsLayer2]=getColHypocotylPerSurfaces(neighbourhoodInfo,img3d,cellCorrectLayer1)

    minCellSize=500;
    
    %calculate outer surface of layer 1 of Col_hypocotyl
    mask3d=false(size(img3d));
    mask3d(img3d>0)=1;
        
    mask3dFilled=imfill(mask3d,'holes');
    
    zerosMask=logical(1-mask3dFilled);
    se=strel('sphere',1);
    zerosMaskDilated=imdilate(zerosMask,se);
    maskCellsOuter=zerosMaskDilated-zerosMask;
    outerSurfaceLayer1=zeros(size(img3d));
    outerSurfaceLayer1(maskCellsOuter==1)=img3d(maskCellsOuter==1);
    volumeReg=regionprops3(outerSurfaceLayer1,'Volume');
    volumeCells=cat(1,volumeReg.Volume);
    cells2delete=find(volumeCells>0 & volumeCells<minCellSize);

    for nCell=cells2delete'
        outerSurfaceLayer1(outerSurfaceLayer1==nCell)=0;
    end
    %calculate cells in Layer 1 (outerLayer)
    cellsLayer1=unique(outerSurfaceLayer1);
    cellsLayer1=cellsLayer1(cellsLayer1~=0);
    
    if ~isempty(cellCorrectLayer1)
        cells2delete=setdiff(cellsLayer1,cellCorrectLayer1);
        for nCell=cells2delete'
            outerSurfaceLayer1(outerSurfaceLayer1==nCell)=0;
        end
        cellsLayer1 = intersect(cellsLayer1,cellCorrectLayer1);        
    end

    
    neighsGlobal=neighbourhoodInfo.neighbourhood;
    neighsOuterCells=neighsGlobal(cellsLayer1);
    
    %calculate cells in layer 2
    neighsCellsLayer1=cellfun(@(x) x(~ismember(x,cellsLayer1)),neighsOuterCells,'UniformOutput',false); 
    cellsLayer2=unique(vertcat(neighsCellsLayer1{:}));   
    
    %calculate cells in layer 3
    neighsSecondlayerCells=neighsGlobal(cellsLayer2);
    innerNeighsCellsLayer2=cellfun(@(x) x(~ismember(x,[cellsLayer1;cellsLayer2])),neighsSecondlayerCells,'UniformOutput',false);
    cellsLayer3=unique(vertcat(innerNeighsCellsLayer2{:}));   

    
    %layer 1
    mask3dLayer1=false(size(img3d));
    for i = cellsLayer1'
        mask3dLayer1 = mask3dLayer1 | (img3d==i);
    end
    
    %layer 1 with dilated cells
    mask3dLayer1Dilated=false(size(img3d));
    for i = cellsLayer1'
        indDilated=sub2ind(size(img3d),neighbourhoodInfo.cellDilated{i}(:,1),...
            neighbourhoodInfo.cellDilated{i}(:,2),neighbourhoodInfo.cellDilated{i}(:,3));
        mask3dLayer1Dilated(indDilated)=1;
    end
    
    %layer 2
    mask3dLayer2=false(size(img3d));
    for i = cellsLayer2'
        mask3dLayer2 = mask3dLayer2 | (img3d==i);
    end
    
    %layer 2 with dilated cells
    mask3dLayer2Dilated=false(size(img3d));
    for i = cellsLayer2'
        indDilated=sub2ind(size(img3d),neighbourhoodInfo.cellDilated{i}(:,1),...
            neighbourhoodInfo.cellDilated{i}(:,2),neighbourhoodInfo.cellDilated{i}(:,3));
        mask3dLayer2Dilated(indDilated)=1;
    end
    
    %layer 3 with dilated cells
    mask3dLayer3Dilated=false(size(img3d));
    for i = cellsLayer3'
        indDilated=sub2ind(size(img3d),neighbourhoodInfo.cellDilated{i}(:,1),...
            neighbourhoodInfo.cellDilated{i}(:,2),neighbourhoodInfo.cellDilated{i}(:,3));
        mask3dLayer3Dilated(indDilated)=1;
    end
    
    %calculate inner surface - Layer 1
    innerSurfaceLayer1=uint16(zeros(size(img3d)));
    innerLayer1Indices=mask3dLayer1 & mask3dLayer2Dilated;
    innerSurfaceLayer1(innerLayer1Indices)=img3d(innerLayer1Indices);
    
    volumeReg=regionprops3(innerSurfaceLayer1,'Volume');
    volumeCells=cat(1,volumeReg.Volume);
    cells2delete=find(volumeCells>0 & volumeCells<minCellSize);
    for nCell=cells2delete'
        innerSurfaceLayer1(innerSurfaceLayer1==nCell)=0;
    end
        
    cellLayer1Inn=unique(innerSurfaceLayer1);
    cellsLayer1 = intersect(cellsLayer1,cellLayer1Inn);
    
    %calculate outer surface - Layer 2
    outerSurfaceLayer2=uint16(zeros(size(img3d)));
    outerLayer2Indices=mask3dLayer1Dilated & mask3dLayer2;
    outerSurfaceLayer2(outerLayer2Indices)=img3d(outerLayer2Indices);
    volumeReg=regionprops3(outerSurfaceLayer2,'Volume');
    volumeCells=cat(1,volumeReg.Volume);
    cells2delete=find(volumeCells>0 & volumeCells<minCellSize);
    for nCell=cells2delete'
        outerSurfaceLayer2(outerSurfaceLayer2==nCell)=0;
    end
    
    %calculate inner surface - Layer 2
    innerSurfaceLayer2=uint16(zeros(size(img3d)));
    innerLayer2Indices=mask3dLayer3Dilated & mask3dLayer2;
    innerSurfaceLayer2(innerLayer2Indices)=img3d(innerLayer2Indices);
    volumeReg=regionprops3(innerSurfaceLayer2,'Volume');
    volumeCells=cat(1,volumeReg.Volume);
    cells2delete=find(volumeCells>0 & volumeCells<minCellSize);
    for nCell=cells2delete'
        innerSurfaceLayer2(innerSurfaceLayer2==nCell)=0;
    end

    
    cellsLayer2Out=unique(outerSurfaceLayer2);
    cellsLayer2Inn=unique(innerSurfaceLayer2);
    cellsLayer2=intersect(cellsLayer2Out,cellsLayer2Inn);
    cellsLayer2=cellsLayer2(cellsLayer2~=0);
end
