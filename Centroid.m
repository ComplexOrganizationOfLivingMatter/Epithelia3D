function [centroidsC, pixel, maskBW] = Centroid( photoPath,name )


%%Load images
Img=imread(photoPath);
I=Img>80;  %Convert image to binary image, based on threshold
           %(>80 in this case, but this will change according to the sample) 

%%Deleting objects smaller than 5 pix
BW2= bwareaopen(I,5);



% D = bwdist(~BW2);
% D = -D;
% L = watershed(D);
% L(~BW2) = 0;
% maskBW=double(L);
% imshow(maskBW)


 
%%Dilatation
se=strel('disk',2);
BW2=imdilate(BW2,se);




%%Calculate area of objects
Area_ob = regionprops(BW2, 'area');
Area_ob = cat(1, Area_ob.Area);
area_mean=mean(Area_ob);


%%Separation between cells according to size
L=bwlabel(BW2,8);
mask=zeros(size(BW2));

for i=1:max(max(L))
 M=zeros(size(BW2));
 M(L==i)=1;
 if Area_ob(i)> area_mean*1.5
   se = strel('disk',7); %With 7 in the sample 5, it works. Usually
   BWM = imerode(M,se);
 else
    BWM=M;
 end
 mask=mask+BWM;
end

maskBW=bwlabel(mask,8);

 
%%Specify the center of mass of the region
centroids = regionprops(maskBW, 'Centroid', 'PixelList');
centroidsC = vertcat(centroids.Centroid);
pixel = vertcat(centroids.PixelList);


%%Show the created image along with the image of the centroids and Voronoi
% f=figure('Visible', 'on');
% imshow(Img);
% hold on;
% 
% [m,n] = size(centroids);
% 
% for i=1:m
%    plot(centroidsC(i,1), centroidsC(i, 2), 'b*');
% end


end

