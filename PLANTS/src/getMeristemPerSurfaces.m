function [layer1OuterSurface,layer1InnerSurface,layer2OuterSurface,layer2InnerSurface,setOfCellsLayer1,setOfCellsLayer2]=getMeristemPerSurfaces(img3d,name)
    
    [H,W,c]=size(img3d);
    layer1OuterSurface=uint16(zeros(H,W));

    if contains(lower(name),'katanin')
        orderLayer=1:c;
    else
        orderLayer=c:-1:1;
    end
    
    for i=orderLayer
        maskZ=img3d(:,:,i);
        layer1OuterSurface(layer1OuterSurface==0)=maskZ(layer1OuterSurface==0);
        
    end
    
    %delete isolated cells
    relabelImage=bwlabel(layer1OuterSurface);
    areaImg=regionprops(relabelImage,'Area');
    [~,indexMax]=max(cat(1,areaImg.Area));  
    layer1OuterSurface(relabelImage~=indexMax)=0;
    
    setOfCellsLayer1=unique(layer1OuterSurface);
    setOfCellsLayer1=setOfCellsLayer1(setOfCellsLayer1~=0);
    
    outerLayer3d=uint16(zeros(H,W,c));
    img3dWithoutOuterLayer=img3d;

    %delete outer layer
    for nCell=setOfCellsLayer1'
        outerLayer3d(img3d==nCell)=img3d(img3d==nCell);
        img3dWithoutOuterLayer(img3d==nCell)=0;
    end
    
    
    
    %project inner part Of 1st layer of cells
    layer1InnerSurface=uint16(zeros(H,W));
    for i=wrev(orderLayer)
        maskZ=outerLayer3d(:,:,i);
        layer1InnerSurface(layer1InnerSurface==0)=maskZ(layer1InnerSurface==0);
    end
    
    %% Second layer of cells
    
    %project 2nd layer of cells
    layer2OuterSurface=uint16(zeros(H,W));
    for i=orderLayer
        maskZ=img3dWithoutOuterLayer(:,:,i);
        layer2OuterSurface(layer2OuterSurface==0)=maskZ(layer2OuterSurface==0);
    end
    
    %delete isolated cells
    relabelImage=bwlabel(layer2OuterSurface);
    areaImg=regionprops(relabelImage,'Area');
    [~,indexMax]=max(cat(1,areaImg.Area));
    layer2OuterSurface(relabelImage~=indexMax)=0;
    
    %get 2nd layer of cells
    setOfCellsLayer2=unique(layer2OuterSurface);
    setOfCellsLayer2=setOfCellsLayer2(setOfCellsLayer2~=0);
    img3dLayer2=uint16(zeros(H,W,c));
    for nCell=setOfCellsLayer2'
        img3dLayer2(img3d==nCell)=img3d(img3d==nCell);
    end
    %project 2nd layer of cells
    layer2InnerSurface=uint16(zeros(H,W));
    for i=wrev(orderLayer)
        maskZ=img3dLayer2(:,:,i);
        layer2InnerSurface(layer2InnerSurface==0)=maskZ(layer2InnerSurface==0);
    end
    
end