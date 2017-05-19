%%organize motif in sequence.mat

globalMotifsPath={'data\SegmentedMotifs\OR\Embryo4\','data\SegmentedMotifs\scribGFP\Embryo2\','data\SegmentedMotifs\scribGFP\Embryo3\','data\SegmentedMotifs\scribGFP\Embryo4\'};
saveMotifsSeqPath={'data\Image_Sequence_Embryo4OR.mat','data\Image_Sequence_Embryo2ScribGFP.mat','data\Image_Sequence_Embryo3ScribGFP.mat','data\Image_Sequence_Embryo4ScribGFP.mat'};

nMotif=25;

Img_Seq=cell(nMotif,1);
for j=1:length(globalMotifsPath)
    Img_Seq=cell(nMotif,1);
    for i=1:nMotif

       motifPath=[globalMotifsPath{j} 'segmentedMotif_' num2str(i) '.tif'];
       
       if exist(motifPath)~=0 
           Img=imread(motifPath) ;
           Img=im2bw(Img);
           Img=bwareaopen(Img,5,4);
           Img2=double(watershed(Img));
           Img2(Img2==1)=0;
           Img2(Img2==Img2(end,1))=0;
           Img2(Img2==Img2(end,end))=0;
           Img2(Img2==Img2(1,end))=0;
           Img_L=bwlabel(Img2);
           Img_Seq{i,1}=Img_L;
           unique(Img_L)
           if max(unique(Img_L))>4 || max(unique(Img_L))<4
              pause 
           end
       end
    end

    save(saveMotifsSeqPath{j},'Img_Seq');

end
