function [centers, radii] = saveImageGettingCentroids(mask3d,name2save)
    
    mkdir(name2save)

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

            imwrite(mask,[name2save num2str(i),'.bmp'])

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

