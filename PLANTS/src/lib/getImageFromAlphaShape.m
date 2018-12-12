function mask3d = getImageFromAlphaShape(img3d,redFactor)
    
    mask3d=false(size(img3d));

    img3dRed = imresize3(img3d,redFactor,'nearest');
    
    %Get alpha shape of layer image
    [x,y,z]=ind2sub(size(img3dRed),find(img3dRed>0));
    shp=alphaShape(x,y,z,1);
    minAlpha = criticalAlpha(shp,'one-region');
    shp.Alpha = minAlpha;
    
    %trick to reduce the query points
    maskDilated = imdilate(bwperim(img3dRed>0),strel('sphere',ceil(minAlpha/2)));
    maskDilatedOriginalSize = imresize3(uint16(maskDilated),size(mask3d),'nearest');
    [qx,qy,qz]=ind2sub(size(maskDilatedOriginalSize),find(maskDilatedOriginalSize>0));
    
    %alpha shape of with original size
    [x,y,z]=ind2sub(size(img3d),find(bwperim(img3d>0)));
    shp=alphaShape(x,y,z,5*minAlpha/redFactor);

    
    %%loop to reduce ram memory
    numPartitions = max(size(img3d));
    partialPxs = ceil(length(qx)/numPartitions);
    tf = false(length(qx),1);
    for nPart = 1 : numPartitions
        subIndCoord = (1 + (nPart-1) * partialPxs) : (nPart * partialPxs);
        if nPart == numPartitions
            subIndCoord = (1 + (nPart-1) * partialPxs) : length(qx);
        end
        tf(subIndCoord) = shp.inShape([qx(subIndCoord),qy(subIndCoord),qz(subIndCoord)]);
    end
    
    indFilImg=sub2ind(size(mask3d),qx(tf),qy(tf),qz(tf));
    mask3d(indFilImg)=1;
    
end

