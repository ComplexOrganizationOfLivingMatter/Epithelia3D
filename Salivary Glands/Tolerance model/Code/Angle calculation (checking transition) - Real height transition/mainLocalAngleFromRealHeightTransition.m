function [angleScaled,angleScaled2,angleWithoutScaled,angleWithoutScaled2]=mainLocalAngleFromRealHeightTransition(pathStructure,frame,cellsGroup,hTransition,curvature)

addpath lib
    
    %Load label image
    load(pathStructure)
    
    if frame=='end'
        Img=Seq_Img_L{end};
    else
        Img=Seq_Img_L{frame};
    end
    
    %Get only 4 cells neighborhood image
    mask=Img;
    mask1=mask;mask2=mask;mask3=mask;mask4=mask;
    mask1(mask~=cellsGroup(1))=0;mask2(mask~=cellsGroup(2))=0;mask3(mask~=cellsGroup(3))=0;mask4(mask~=cellsGroup(4))=0;
    mask=mask1+mask2+mask3+mask4;
    Img=mask;
    
    %Calculate neighbors
    [~,sidesCells]=calculateNeighbours(Img);
    neigh2sides=find(sidesCells==2);
    neigh3sides=find(sidesCells==3);
    
    %calculate distance between 2 cells non neighs between them
    centr=regionprops(Img,'Centroid');
    centr=cat(1,centr.Centroid);
    cent2neigh=centr(neigh2sides,:);
    cent3neigh=centr(neigh3sides,:);

    cent2Dist=pdist(cent2neigh);
    cent3Dist=pdist(cent3neigh);

    
    %Scaled angle
    angleScaled=atand((cent2Dist*curvature)/(2*hTransition));
    angleScaled2=atand((cent3Dist*curvature)/(2*hTransition));
    %angleWithoutScaled
    angleWithoutScaled=atand((cent2Dist)/(2*hTransition));
    angleWithoutScaled2=atand((cent3Dist)/(2*hTransition));

    
    

end