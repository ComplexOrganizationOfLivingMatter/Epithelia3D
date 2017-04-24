%%organize motif in sequence.mat

nMotif=25;
motifsPath='D:\Pedro\Epithelia3D\Gastrulation\';

Img_Seq=cell(nMotif,1);
for i=1:nMotif
    
   Img=imread([motifsPath 'selectedMotif\motif_' num2str(i) '.png']) ;
   Img=im2bw(Img);
   Img=bwareaopen(Img,5,4);
   Img_L=bwlabel(Img,4);
   Img_Seq{i,1}=Img_L;
   unique(Img_L)
end

save([motifsPath 'Image_Sequence.mat'],'Img_Seq');