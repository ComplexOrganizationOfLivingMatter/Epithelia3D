function [centersOuter, centersInner, radiiOuter, radiiInner] = calculateCenterRadiusCylSection(img3d,name2save,layer2save)
  
    %Permute image axes
    img3d=permute(img3d,[1 3 2]);
    mask3d=false(size(img3d));
    
    %Get alpha shape of layer image
    [x,y,z]=ind2sub(size(img3d),find(img3d>0));
    shp=alphaShape(x,y,z,50);
%     plot(shp)
    [qx,qy,qz]=ind2sub(size(img3d),find(img3d>=0));
    
    %%reducing ram memory
    numPartitions = 100;
    partialPxs = ceil(length(qx)/numPartitions);
    tf = false(length(qx),1);
    for nPart = 1 : numPartitions
        subIndCoord = (1 + (nPart-1) * partialPxs) : (nPart * partialPxs);
        if nPart == numPartitions
            subIndCoord = (1 + (nPart-1) * partialPxs) : length(allX);
        end
        tf(subIndCoord) = shp.inShape([qx(subIndCoord),qy(subIndCoord),qz(subIndCoord)]);
    end
    
    
    indFilImg=sub2ind(size(mask3d),qx(tf),qy(tf),qz(tf));
    mask3d(indFilImg)=1;
    mask3dInvert = ~mask3d;
    innerSurface = bwlabeln(mask3dInvert,26) == 2;
    
    name2saveOuter = ['data\' name2save '\maskLayers\outerMask' layer2save '\'];
    name2saveInner = ['data\' name2save '\maskLayers\innerMask' layer2save '\'];
    
    
    [centersOuter, radiiOuter] = saveImageGettingCentroids(mask3d,name2saveOuter);
    [centersInner, radiiInner] = saveImageGettingCentroids(innerSurface,name2saveInner);

    
end










