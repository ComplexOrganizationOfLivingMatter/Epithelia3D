function labelledSurface = assignLabelPixelsSurface (surfaceMask,imgLayer)

    idMask=find(surfaceMask);
    [xMask,yMask,zMask]=ind2sub(size(surfaceMask),idMask);
    
    idImgLayer=find(imgLayer>0);
    [xImg,yImg,zImg]=ind2sub(size(imgLayer),idImgLayer);
    
    labelledSurface=uint16(zeros(size(surfaceMask)));
    idMin=zeros(1,length(xMask));
    for nPx = 1 : length(xMask)
        distPxs=pdist2([xMask(nPx),yMask(nPx),zMask(nPx)],[xImg,yImg,zImg]);
        [~,idMin(Px)]=min(distPxs);
        
%        disp(['Coord Img: ' num2str([xMask(nPx),yMask(nPx),zMask(nPx)])])
%        disp(['Coord Img: ' num2str([xImg(idMin),yImg(idMin),zImg(idMin)])])
%        disp(['distance : ' num2str(distPx)])
%        disp(['label    : ' num2str(imgLayer(xImg(idMin),yImg(idMin),zImg(idMin)))])
    end
    
    labelledSurface(idMask)= imgLayer(idImgLayer(idMin));

    
    [x,y,z] = ind2sub(size(labelledSurface),find(imgLayer==2));%find(labelledSurface>0));
    figure;
    pcshow([x,y,z]);
end