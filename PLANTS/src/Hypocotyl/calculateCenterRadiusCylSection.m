function [centers, radii] = calculateCenterRadiusCylSection(img3d,name2save)
    mkdir(name2save)
  
    img3d=permute(img3d,[1 3 2]);
    mask3d=false(size(img3d));
    mask3d(img3d>0)=1;
    [x,y,z]=ind2sub(size(mask3d),find(mask3d==1));
    shp=alphaShape(x,y,z,200);
%     plot(shp)
    [qx,qy,qz]=ind2sub(size(mask3d),find(mask3d>=0));
    tf = inShape(shp,qx,qy,qz);
    
    mask3d=zeros(size(mask3d));
    indFilImg=sub2ind(size(mask3d),qx(tf),qy(tf),qz(tf));
    mask3d(indFilImg)=1;
    
    centers=cell(size(mask3d,3),1);
    radii=cell(size(mask3d,3),1);
    for i=1:size(mask3d,3)
        mask=false(size(mask3d(:,:,i)));
        [xq,yq]=find(~mask);
        mask(mask3d(:,:,i)>0)=1;

        if sum(sum(ismember(mask,1)))>20
            [x,y]=find(mask);
            k = convhull(x,y);
            [in,on] = inpolygon(xq,yq,x(k),y(k));

            mask(in)=1;
            mask(on)=1;
            imwrite(mask,[name2save '\' num2str(i),'.bmp'])

            propsMask=regionprops(mask,'Centroid','MajorAxisLength','MinorAxisLength','Area');
            area=cat(1,propsMask.Area);
            [~,indMax]=max(area);
            centroid=cat(1,propsMask.Centroid);
            majAxis=cat(1,propsMask.MajorAxisLength);
            minAxis=cat(1,propsMask.MinorAxisLength);
            centers{i}=[centroid(indMax,1),i,centroid(indMax,2)];
            radii{i}=mean([majAxis(indMax,:),minAxis(indMax,:)])/2;
        end
    end
end










