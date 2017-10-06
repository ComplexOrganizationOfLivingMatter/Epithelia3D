function [finalCentroid, varTracking] = newTreatment( FileName, photo, frameAnalysis, x,y, finalCentroid, varTracking, errors, errorCent )

Img=imread(FileName{photo,1});
I=Img>70; %Se aumena el umbral para que pueda capar más información
BW2= bwareaopen(I,5);
se=strel('disk',2);
BW2=imdilate(BW2,se);
Area_ob = regionprops(BW2, 'area');
Area_ob = cat(1, Area_ob.Area);
area_mean=mean(Area_ob);
L=bwlabel(BW2,8);
mask=zeros(size(BW2));
for i=1:max(max(L))
    M=zeros(size(BW2));
    M(L==i)=1;
    if Area_ob(i)> area_mean*2 %Se erosiona si es 2 veces mas grande que la media.
        se = strel('disk',3);
        BWM = imerode(M,se);
    else
        BWM=M;
    end
    mask=mask+BWM;
end
maskBW=bwlabel(mask,8);


%             D = bwdist(~BW2);
%             D = -D;
%             L = watershed(D);
%             L(~BW2) = 0;
%             maskBW=double(L);


newList= regionprops(maskBW, 'PixelList', 'Centroid');

for searchNews=1:size(newList,1)
    Ind=ismember(round([x y]),newList(searchNews).PixelList,'rows');
    if Ind==1
        id=errors{errorCent,1};
        layer=errors{errorCent,3};
        coordinates= horzcat(newList(searchNews).Centroid, frameAnalysis+(photo-6));
        
        finalCentroid{end+1,1}=id;
        finalCentroid{end,2}=coordinates;
        finalCentroid{end,3}=layer;
        
        varTracking{6,1}=frameAnalysis;
        varTracking{photo,1}=frameAnalysis+(photo-6);
        
    end
end
end

