function [layer1OuterSurface,layer1InnerSurface,layer2OuterSurface,layer2InnerSurface,setOfCellsLayer1,setOfCellsLayer2]=getMeristemPerSurfaces(img3d,name)
    
    [H,W,c]=size(img3d);
    maskProjectionOuterLayer=uint16(zeros(H,W));

    if contains(lower(name),'katanin')
        orderLayer=1:c;
    else
        orderLayer=c:-1:1;
    end
    
    for i=orderLayer
        maskZ=img3d(:,:,i);
        maskProjectionOuterLayer(maskProjectionOuterLayer==0)=maskZ(maskProjectionOuterLayer==0);
        
    end
    
    relabelImage=bwlabel(maskProjectionOuterLayer);
    areaImg=regionprops(relabelImage,'Area');
    [~,indexMax]=max(cat(1,areaImg.Area));
    
    maskProjectionOuterLayer(relabelImage~=indexMax)=0;
    
    cellsFirstLayer=unique(maskProjectionOuterLayer);
    cellsFirstLayer=cellsFirstLayer(cellsFirstLayer~=0);
    
    outerLayer3d=uint16(zeros(H,W,c));
    img3dWithoutOuterLayer=img3d;

    %delete outer layer from the outer layer
    for nCell=cellsFirstLayer'
        outerLayer3d(img3d==nCell)=img3d(img3d==nCell);
        img3dWithoutOuterLayer(img3d==nCell)=0;
    end
    
    %project 2nd layer of cells
    maskProjectionOuterLayer2=uint16(zeros(H,W));
    for i=orderLayer
        maskZ=img3dWithoutOuterLayer(:,:,i);
        maskProjectionOuterLayer2(maskProjectionOuterLayer2==0)=maskZ(maskProjectionOuterLayer2==0);
    end
    
    %project inner part Of 1st layer of cells
    maskProjectionInnerLayer1=uint16(zeros(H,W));
    for i=wrev(orderLayer)
        maskZ=outerLayer3d(:,:,i);
        maskProjectionInnerLayer1(maskProjectionInnerLayer1==0)=maskZ(maskProjectionInnerLayer1==0);
    end
    
end