function [centersOuter, centersInner, radiiOuter, radiiInner] = calculateCenterRadiusCylSection(img3d,auxLayer,folder,name2save,layer2save)
  
    redFactor = 1;
    %Permute image axes
    img3d = imresize3(img3d,redFactor,'nearest');
    auxLayer = imresize3(auxLayer,redFactor,'nearest');
    
    %defining permuting axes
    axesLength = regionprops3(img3d>0,'PrincipalAxisLength');
    [~,maxLeng] = max(cat(1,axesLength.PrincipalAxisLength));
    [~,orderLengAxis] = sort(cat(1,axesLength.PrincipalAxisLength(maxLeng(1),:)));
    
    img3d=permute(img3d,orderLengAxis);
    auxLayer=permute(auxLayer,orderLengAxis);

    %perim outer layer
    maskOuter3d = getImageFromAlphaShape(img3d+auxLayer);
    perimOuterLayer3D = maskOuter3d - imerode(maskOuter3d,strel('sphere',1));
    perimOuterLayer3DSmoothOriginalSize = smooth3(imresize3(uint16(perimOuterLayer3D),1/redFactor,'nearest'),'box',5) > 0.2;
    
    %perim inner layer
    maskInner3d = getImageFromAlphaShape(auxLayer);
    perimInnerLayer3D = imdilate(maskInner3d,strel('sphere',1)) - maskInner3d;
    perimInnerLayer3DSmoothOriginalSize = smooth3(imresize3(uint16(perimInnerLayer3D),1/redFactor,'nearest'),'box',5) > 0.2;
    
    name2saveOuter = [folder name2save '\maskLayers\outerMask' layer2save '\'];
    name2saveInner = [folder name2save '\maskLayers\innerMask' layer2save '\'];
    
    [centersOuter, radiiOuter] = saveImageGettingCentroids(perimOuterLayer3DSmoothOriginalSize,name2saveOuter);
    [centersInner, radiiInner] = saveImageGettingCentroids(perimInnerLayer3DSmoothOriginalSize,name2saveInner);

end










