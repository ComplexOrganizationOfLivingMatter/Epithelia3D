function [centersOuter, centersInner, radiiOuter, radiiInner] = calculateCenterRadiusCylSection(img3d,auxLayer,folder,name2save,layer2save)
  
    redFactor = 0.5;
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
    maskOuter3d = getImageFromAlphaShape(img3d);
    perimOuterLayer3D = maskOuter3d - imerode(maskOuter3d,strel('sphere',1));
    
    %perim inner layer
    maskInner3d = getImageFromAlphaShape(auxLayer);
    perimInnerLayer3D = imdilate(maskInner3d,strel('sphere',1)) - maskInner3d;
    
    name2saveOuter = [folder name2save '\maskLayers\outerMask' layer2save '\'];
    name2saveInner = [folder name2save '\maskLayers\innerMask' layer2save '\'];
    
    [centersOuter, radiiOuter] = saveImageGettingCentroids(imresize3(uint16(perimOuterLayer3D),1/redFactor,'nearest'),name2saveOuter);
    [centersInner, radiiInner] = saveImageGettingCentroids(imresize3(uint16(perimInnerLayer3D),1/redFactor,'nearest'),name2saveInner);

end










