function [labelOuterFilledSurface,labelInnerFilledSurface] = getFilledMaskHyp(imgLayerOuter,imgLayerInner,tipValueInn,tipValueOut,rangeY)
    
    maskFillLayerOuter=imdilate(imgLayerOuter>0,strel('sphere',tipValueOut));  
    maskFillLayerOuter=imerode(maskFillLayerOuter,strel('sphere',tipValueOut-4));
    maskFillLayerOuterWithoutTip=maskFillLayerOuter(:,tipValueOut:end-tipValueOut,:);
    maskFillLayerOuter=maskFillLayerOuterWithoutTip(:,rangeY(1):rangeY(2),:);
    
    [x,y,z] = ind2sub(size(maskFillLayerOuter),find(maskFillLayerOuter>0));
    figure
    pcshow([x,y,z])
    
    disImg=bwdist(1-maskFillLayerOuter);
    maskFillLayerOuter=watershed(disImg)==0;
    [x,y,z] = ind2sub(size(maskFillLayerOuter),find(maskFillLayerOuter>0));
    figure
    pcshow([x,y,z]);
    
    maskFillLayerInner=imdilate(imgLayerInner>0,strel('sphere',tipValueInn));  
    maskFillLayerInner=imerode(maskFillLayerInner,strel('sphere',tipValueInn-4));
    maskFillLayerInnerWithoutTip=maskFillLayerInner(:,tipValueInn:end-tipValueInn,:);
    maskFillLayerInner=maskFillLayerInnerWithoutTip(:,rangeY(1):rangeY(2),:);
      
    [x,y,z] = ind2sub(size(maskFillLayerInner),find(maskFillLayerInner>0));
    figure
    pcshow([x,y,z]);
    disImg=bwdist(1-maskFillLayerInner);
    maskFillLayerInner=watershed(disImg)==0;
    [x,y,z] = ind2sub(size(maskFillLayerInner),find(maskFillLayerInner>0));
    figure
    pcshow([x,y,z]);

    imgLayerOuterLimited=imgLayerOuter(:,tipValueOut+rangeY(1):tipValueOut+rangeY(2),:);
    imgLayerInnerLimited=imgLayerInner(:,tipValueInn+rangeY(1):tipValueInn+rangeY(2),:);
    
    labelOuterFilledSurface=assignLabelPixelsSurface(maskFillLayerOuter,imgLayerOuterLimited);
    labelInnerFilledSurface=assignLabelPixelsSurface(maskFillLayerInner,imgLayerInnerLimited);


end

