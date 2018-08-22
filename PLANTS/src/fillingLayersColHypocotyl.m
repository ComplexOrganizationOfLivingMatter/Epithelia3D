function [layer1OuterSurface,layer1InnerSurface,layer2OuterSurface,layer2InnerSurface] = fillingLayersColHypocotyl(img3d,setOfCells,rangeY)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    tipValue=20;
    openValue=10;
    resizedFactor=0.3;
    img3dResized=imresize3(img3d,resizedFactor);
    
    rangeY=round(rangeY*resizedFactor);
    
    %% add zeros tips for possible 
    img3dResized=addTipsImg3D(tipValue,img3dResized);


    imgLayer1=uint16(zeros(size(img3dResized)));
    imgLayer2=uint16(zeros(size(img3dResized)));
    
    for cellId=setOfCells.Layer1'
        imgLayer1(img3dResized==cellId)=cellId;
    end
    
    for cellId=setOfCells.Layer2'
        imgLayer2(img3dResized==cellId)=cellId;
    end
    
    [imgLayer1,maskFillLayer1] = getFilledMaskHyp(imgLayer1,openValue,tipValue,rangeY);
    [imgLayer2,maskFillLayer2] = getFilledMaskHyp(imgLayer2,openValue,tipValue,rangeY);

    
    
    
    
    
end

