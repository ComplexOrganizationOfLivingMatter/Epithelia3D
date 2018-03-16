function [V1,V2,V1index]=checkVerticesBorder(numCell,L_img,V,W_projection)
    
    %check in which part of the divided cells are the vertices
    
    L_img(L_img~=numCell)=0;
    ratio=4;
    se=strel('disk',ratio);
    relab_img=bwlabel(L_img);
    difCells=unique(relab_img);
    difCells=difCells(difCells~=0);
    
    mask=zeros(size(L_img));
    for i=difCells'
        mask=mask+imdilate(relab_img==i,se)*i;
    end
    
    Vindex=zeros(size(V,1),1);
    for i=1:size(V,1)
        Vindex(i)=mask(V(i,1),V(i,2));
    end
       
    V1=V;
    V2=V;
    
    
    V1index = Vindex==1 ;
    V1(V1index,2)=V(V1index,2)+W_projection; 
    V2(~V1index,2)=V(~V1index,2)-W_projection; 
    
    
end

