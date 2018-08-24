function [imgLayer1,labelOuterSurface1,labelInnerSurface1,imgLayer2,labelOuterSurface2,labelInnerSurface2] = fillingLayersColHypocotyl(layer1,layer2,rangeY)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    tipValue=18;
    openValue=10;
    resizedFactor=0.3;
   
    layOut1Resized=imresize3(layer1.outerSurface,resizedFactor);
    layInn1Resized=imresize3(layer1.innerSurface,resizedFactor);
    layOut2Resized=imresize3(layer2.outerSurface,resizedFactor);
    layInn2Resized=imresize3(layer2.innerSurface,resizedFactor);

    rangeY=round(rangeY*resizedFactor);
    
    %% add zeros tips for possible 
    layOut1Resized=addTipsImg3D(tipValue,layOut1Resized);
    layInn1Resized=addTipsImg3D(tipValue,layInn1Resized);
    layOut2Resized=addTipsImg3D(tipValue,layOut2Resized);
    layInn2Resized=addTipsImg3D(tipValue,layInn2Resized);

    
    [imgLayer1,labelOuterSurface1,labelInnerSurface1] = getFilledMaskHyp(layOut1Resized,layInn1Resized,openValue,tipValue,rangeY,[]);
    [imgLayer2,labelOuterSurface2,labelInnerSurface2] = getFilledMaskHyp(layOut2Resized,layInn2Resized,tipValue,rangeY,labelInnerSurface1);

    
    
    
    
    
end

