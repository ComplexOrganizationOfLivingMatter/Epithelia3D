function [labelOuterSurface1,labelInnerSurface1,labelOuterSurface2,labelInnerSurface2] = fillingLayersColHypocotyl(layer1,layer2,rangeY,resizedFactor,path2save)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    tipValueInn=24;
    
    tipValueOut=37;
%     openValue=10;
   
    layOut1Resized=imresize3(layer1.outerSurface,resizedFactor);
    layInn1Resized=imresize3(layer1.innerSurface,resizedFactor);
    layOut2Resized=imresize3(layer2.outerSurface,resizedFactor);
    layInn2Resized=imresize3(layer2.innerSurface,resizedFactor);

   
    %% add zeros tips for possible 
    layOut1Resized=addTipsImg3D(tipValueOut,layOut1Resized);
    layInn1Resized=addTipsImg3D(tipValueInn,layInn1Resized);
    layOut2Resized=addTipsImg3D(tipValueOut,layOut2Resized);
    layInn2Resized=addTipsImg3D(tipValueInn,layInn2Resized);

    if exist([path2save 'surfacesLayer1ClosestPoint.mat'],'file')
        load([path2save 'surfacesLayer1ClosestPoint.mat'],'labelOuterSurface1','labelInnerSurface1')
    else
        [labelOuterSurface1,labelInnerSurface1] = getFilledMaskHyp(layOut1Resized,layInn1Resized,tipValueInn,tipValueOut,rangeY);
        save([path2save 'surfacesLayer1ClosestPoint.mat'],'labelOuterSurface1','labelInnerSurface1')
    end

    if exist([path2save 'surfacesLayer2ClosestPoint.mat'],'file')
        load([path2save 'surfacesLayer2ClosestPoint.mat'],'labelOuterSurface2','labelInnerSurface2')
    else
        [labelOuterSurface2,labelInnerSurface2] = getFilledMaskHyp(layOut2Resized,layInn2Resized,tipValueInn,tipValueOut,rangeY);
        save([path2save 'surfacesLayer2ClosestPoint.mat'],'labelOuterSurface2','labelInnerSurface2')
    end
    
    
end

