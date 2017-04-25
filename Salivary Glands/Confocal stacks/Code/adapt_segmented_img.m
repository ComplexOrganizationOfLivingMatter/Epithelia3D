function adapt_segmented_img(folder,name)

Img_list=dir(['..\Segmented images\' folder '\' name '\resultsFinal\gland*.tif']);

    for i=1:numel(Img_list)
        
        L_skel=[];
        skel=[];
        tube=[];L_tube=[];
        names_list{i}={Img_list(i).name};
        na=cell2mat(names_list{i});
        Img=imread(['..\Segmented images\' folder '\' name '\resultsFinal\' na]);
        
        [H,W,c]=size(Img);
        
        if c==3
            r=Img(:,:,1);
            b=Img(:,:,3);
            tube=logical(b-r);
            tube=bwareaopen(tube,30);
            tube_labels=unique(bwlabel(tube));
            tube_labels(tube_labels==0)=[];
            Img=r;
        end
        
        
        
        
        Img=im2bw(Img);
        Img=double(Img);
        %%delete small artifacts
        Img2=bwareaopen(Img,100);
        Img3=1-logical(Img2);
        Img3=bwareaopen(Img3,100);
        
        se=strel('disk',3);
        Img4=imerode(Img3,se);
        
        %Get skeleton
        skel=watershed(1-bwareaopen(Img4,15),8);
        
        skel(skel>0)=1;
        skel=1-logical(skel);
        
        %Paint tube in white color
        if c==3 && isempty(tube_labels)~=1
            skel=logical(1-skel);
            L_skel=bwlabel(skel);
            
            L_tube=bwlabel(tube);
            
            n_tubes=length(unique(L_tube))-1;
        
            for k=1:n_tubes
            
        
                L_skel(L_skel==mode(L_skel(L_tube==k)))=0;
            
            end
            
            skel=1-logical(L_skel);
        end
        
        if exist(['..\Segmented images\' folder '\' name '\Skeleton_images'])==0
            mkdir(['..\Segmented images\' folder '\' name '\Skeleton_images']);
        end    
            
        
        numFrame = num2str(str2num(na(8:end-4)),'%02d');
        
        if length(na(8:end-4)) < 2
            nameSplitted = strsplit(na, '_');
            numFrame = nameSplitted{2};
            numFrame = numFrame(1:end-4);
        end
        
        imwrite(skel, ['..\Segmented images\' folder '\' name '\Skeleton_images\Skel_' numFrame '.tif'])
    end
    
end
    