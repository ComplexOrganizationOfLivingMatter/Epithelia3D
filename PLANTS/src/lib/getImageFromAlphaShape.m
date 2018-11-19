function mask3d = getImageFromAlphaShape(img3d)
    
    mask3d=false(size(img3d));
    
    %Get alpha shape of layer image
%     [x,y,z]=ind2sub(size(img3d),find(img3d>0));
%     shp=alphaShape(x,y,z);
%     plot(shp)
   
    [x,y,z]=ind2sub(size(img3d),find(img3d>0));
    [xq,yq,zq]=ind2sub(size(img3d),find(img3d>=0));
    
    inPoints = inhull([xq,yq,zq],[x,y,z]);
    
%     tri=convhull(x,y,z);
%     inPoints = ~isnan(tsearchn([x,y,z],tri,[xq,yq,zq]));
    
    mask3d(inPoints)=1;
    
%     %%reducing ram memory
%     numPartitions = 100;
%     partialPxs = ceil(length(qx)/numPartitions);
%     tf = false(length(qx),1);
%     for nPart = 1 : numPartitions
%         subIndCoord = (1 + (nPart-1) * partialPxs) : (nPart * partialPxs);
%         if nPart == numPartitions
%             subIndCoord = (1 + (nPart-1) * partialPxs) : length(qx);
%         end
%         tf(subIndCoord) = shp.inShape([qx(subIndCoord),qy(subIndCoord),qz(subIndCoord)]);
%     end
%     
%     indFilImg=sub2ind(size(mask3d),qx(tf),qy(tf),qz(tf));
%     mask3d(indFilImg)=1;
    
end

