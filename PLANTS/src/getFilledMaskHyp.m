function [imgLayer,maskFillLayer] = getFilledMaskHyp(imgLayer,openValue,tipValue,rangeY)
    
    mask2open=false( size( imgLayer ));
    maskLayerCleanCells=uint16(zeros(size( imgLayer )));
    labCells=unique(imgLayer);
    for nCell=labCells(2:end)'
        mask=imgLayer==nCell;
        mask2open=imerode(mask,strel('sphere',1));
        maskOpen=bwareaopen(mask2open,openValue);
        maskOpen=imdilate(maskOpen,strel('sphere',1));
        
        if sum(maskOpen(:))>0
            volumeRegions = regionprops3(maskOpen,'Volume');
            [~,idx]=max(volumeRegions.Volume);
            idCell= find(bwlabeln(maskOpen)==idx);
            maskLayerCleanCells(idCell)=nCell;
        end
    end
    maskLayerCleanCells=imfill(maskLayerCleanCells,'holes');  

    maskFillLayer=imdilate(maskLayerCleanCells>0,strel('sphere',tipValue));  
    maskFillLayer=imerode(maskFillLayer,strel('sphere',tipValue+3));
    maskFillLayerWithoutTip=maskFillLayer(:,tipValue:end-tipValue,:);
    maskFillLayer=maskFillLayerWithoutTip(:,rangeY(1):rangeY(2),:);
    volumeRegions = regionprops3(maskFillLayer,'Volume');
    [~,idx]=max(volumeRegions.Volume);
    maskFillLayer= bwlabeln(maskFillLayer)==idx;
    maskFillLayer=imdilate(maskFillLayer,strel('sphere',3));

    maskFillLayerInvert =  bwlabeln(1-maskFillLayer);
    maskFillLayerDilated=imdilate(maskFillLayer,strel('sphere',1));
    surfacesLayer=maskFillLayerDilated-maskFillLayer;
    
    surfacesLayer =  maskFillLayerInvert.*surfacesLayer;
    outerSurface = surfacesLayer==1;
    innerSurface = surfacesLayer==2;
    
    
    imgLayerLimited=maskLayerCleanCells(:,tipValue+rangeY(1):tipValue+rangeY(2),:);
    labelOuterFilledSurface=assignLabelPixelsSurface(outerSurface,imgLayerLimited);
    labelInnerFilledSurface=assignLabelPixelsSurface(innerSurface,imgLayerLimited);
    
    [x,y,z] = ind2sub(size(maskFillLayer),find(outerSurface>0));
    figure;
    pcshow([x,y,z]);

    [x,y,z] = ind2sub(size(maskFillLayer),find(innerSurface>0));
    figure;
    pcshow([x,y,z]);
    
%     [x,y,z] = ind2sub(size(imgLayer),find(WaterLayer==6));
%     figure;
%     pcshow([x,y,z]);

end

