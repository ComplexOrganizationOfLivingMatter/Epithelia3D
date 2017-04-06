for i=8:23, 
    mask=imread(['..\Segmented images\Wild type\10-11-16\gland 1 (sqhgfp pha sqhgfp dapi 20X 1a)\Skeleton_images\Skel_' num2str(i+13,'%02d') '.tif']);
    mask=1-mask;
    mask_L=bwlabel(mask);
    mask_L2=mask_L;
    c=regionprops(mask_L,'Centroid');
    centroids=round(cat(1,c.Centroid));
    Img=Seq_Img_L{i,1};
    mask_L(mask_L2==1)=0;
    for j=2:size(centroids,1)
        mask_L(mask_L2==mask_L(centroids(j,2),(centroids(j,1))))=Img(centroids(j,2),(centroids(j,1)));
    end
    Seq_Img_L{i,1}=mask_L;
end


%for i=8:23, Img=Seq_Img_L{i,1}; Img(Img==31)=26; Seq_Img_L{i,1}=Img; end