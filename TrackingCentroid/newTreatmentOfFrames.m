function [finalCentroid, varTracking] = newTreatmentOfFrames( FileName, photo, frameAnalysis, x,y, finalCentroid, varTracking, errors, errorCent,umbral )
%NEWTREATMENTOFFRAMES Re-analyze the frames to increase the tracking of the
%centroids that are set as input parameters.


%Load images
Img=imread(FileName{photo,1});
I=Img>umbral; %The threshold is raised so you can accept more information

%Deleting objects smaller than 5 pix
BW2= bwareaopen(I,5);

%Dilatation
se=strel('disk',2);
BW2=imdilate(BW2,se);

%Calculate area of objects
Area_ob = regionprops(BW2, 'area');
Area_ob = cat(1, Area_ob.Area);
area_mean=mean(Area_ob);

%Separation between cells according to size
L=bwlabel(BW2,8);
mask=zeros(size(BW2));
for i=1:max(max(L))
    M=zeros(size(BW2));
    M(L==i)=1;
    if Area_ob(i)> area_mean*2 %It erodes if it is 2 times bigger than the average.
        se = strel('disk',3);
        BWM = imerode(M,se);
    else
        BWM=M;
    end
    mask=mask+BWM;
end
maskBW=bwlabel(mask,8);

%Specify the center of mass of the region
newList= regionprops(maskBW, 'PixelList', 'Centroid');

%Once the intensity of the images of the front and back frames of the centroid that only 
%appears in one frame has been increased, the pixels and centroids have been recalculated.
%Then, it is checked if the centroid coincides with some pixel of the surrounding frames, 
%and if so, the centroid of that pixel is added.
for searchNews=1:size(newList,1)
    Ind=ismember(round([x y]),newList(searchNews).PixelList,'rows');
    if Ind==1
        id=errors{errorCent,1};
        layer=errors{errorCent,3};
        coordinates= horzcat(newList(searchNews).Centroid, frameAnalysis+(photo-6));
        
        finalCentroid{end+1,1}=id;
        finalCentroid{end,2}=coordinates;
        finalCentroid{end,3}=layer;
        
        varTracking{errorCent,1}(photo,1)=frameAnalysis+(photo-6);
        
    end
end
end

