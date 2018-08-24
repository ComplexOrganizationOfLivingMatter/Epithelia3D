function [imgLayerLimited,labelOuterFilledSurface,labelInnerFilledSurface] = getFilledMaskHyp(imgLayerOuter,imgLayerInner,openValue,tipValue,rangeY,repeatedSurface)
   
    %         figure;
%         [x,y,z] = ind2sub(size(maskLayerCleanCells),find(maskLayerCleanCells>0));
%         pcshow([x,y,z]);
    
    maskFillLayerOuter=imdilate(imgLayerOuter>0,strel('sphere',tipValue));  
    maskFillLayerOuter=imerode(maskFillLayerOuter,strel('sphere',tipValue));
    maskFillLayerOuterWithoutTip=maskFillLayerOuter(:,tipValue:end-tipValue,:);
    maskFillLayerOuter=maskFillLayerOuterWithoutTip(:,rangeY(1):rangeY(2),:);
    
    [x,y,z] = ind2sub(size(maskFillLayerOuter),find(maskFillLayerOuter>0));
    figure
    pcshow([x,y,z]);
    
    maskFillLayerInner=imdilate(imgLayerInner>0,strel('sphere',tipValue));  
    maskFillLayerInner=imerode(maskFillLayerInner,strel('sphere',tipValue));
    maskFillLayerInnerWithoutTip=maskFillLayerInner(:,tipValue:end-tipValue,:);
    maskFillLayerInner=maskFillLayerInnerWithoutTip(:,rangeY(1):rangeY(2),:);
    
    [x,y,z] = ind2sub(size(maskFillLayerInner),find(maskFillLayerInner>0));
    figure
    pcshow([x,y,z]);
    
    volumeRegions = regionprops3(maskFillLayer,'Volume');
    [~,idx]=max(volumeRegions.Volume);
    maskFillLayer= bwlabeln(maskFillLayer)==idx;
    maskFillLayer=imdilate(maskFillLayer,strel('sphere',3));

    maskFillLayerInvert =  bwlabeln(1-maskFillLayer);
    maskFillLayerDilated=imdilate(maskFillLayer,strel('sphere',1));
    surfacesLayer=maskFillLayerDilated-maskFillLayer;

    surfacesLayer =  maskFillLayerInvert.*surfacesLayer;
    if isempty(repeatedSurface)
    
        outerSurface = surfacesLayer==1;
        innerSurface = surfacesLayer==2;
    else
        
        outerSurface = repeatedSurface>0;
        mask2Del=imdilate(outerSurface,strel('sphere',6));      
        surfacesLayer(mask2Del>0)=0;
        innerSurface = surfacesLayer>0;
    end
    
    
    imgLayerLimited=imgLayer(:,tipValue+rangeY(1):tipValue+rangeY(2),:);
    [x,y,z] = ind2sub(size(outerSurface),find(outerSurface>0));
    figure;
    pcshow([x,y,z]);
    
    [x,y,z] = ind2sub(size(outerSurface),find(innerSurface>0));
    figure;
    pcshow([x,y,z]);
    
    labelOuterFilledSurface=outerSurface;
    labelInnerFilledSurface=innerSurface;
    
%     labelOuterFilledSurface=assignLabelPixelsSurface(outerSurface,imgLayerLimited);
%     labelInnerFilledSurface=assignLabelPixelsSurface(innerSurface,imgLayerLimited);

%     [x,y,z] = ind2sub(size(imgLayer),find(WaterLayer==6));
%     figure;
%     pcshow([x,y,z]);

end

