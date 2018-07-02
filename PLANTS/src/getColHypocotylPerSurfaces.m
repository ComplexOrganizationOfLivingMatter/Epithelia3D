function [surfacesHypocotyl]=getColHypocotylPerSurfaces(neighbourhoodInfo,img3d)

    %calculate outer layer of Col_hypocotyl
    mask3d=false(size(img3d));
    mask3d(img3d>0)=1;
    mask3dFilled=imfill(mask3d,'holes');
    zerosMask=logical(1-mask3dFilled);
    zerosMaskDilated=imdilate(zerosMask,strel('sphere',1));
    maskCellsOuter=zerosMaskDilated-zerosMask;
    maskOuterCellsOuterSurface=zeros(size(img3d));
    maskOuterCellsOuterSurface(maskCellsOuter==1)=img3d(maskCellsOuter==1);

    %calculate cells in Layer 1 (outerLayer)
    cellsOuter=unique(maskOuterCellsOuterSurface);
    cellsOuter=cellsOuter(cellsOuter~=0);
    
    neighsGlobal=neighbourhoodInfo.neighbourhood;
    neighsOuterCells=neighsGlobal(cellsOuter);
    
    %calculate cells in layer 2
    neighsCellsLayer1=cellfun(@(x) x(~ismember(x,cellsOuter)),neighsOuterCells,'UniformOutput',false); 
    cellsLayer2=unique(vertcat(neighsCellsLayer1{:}));   
    
    %calculate cells in layer 3
    neighsSecondlayerCells=neighsGlobal(cellsLayer2);
    innerNeighsCellsLayer2=cellfun(@(x) x(~ismember(x,[cellsOuter;cellsLayer2])),neighsSecondlayerCells,'UniformOutput',false);
    cellsLayer3=unique(vertcat(innerNeighsCellsLayer2{:}));   

    
end
