function [angleScaled,angleWithoutScaled]=mainLocalAngleFromRealHeightTransitionIncludingEdges(pathStructure,frame,cellsGroup,hTransition,curvature,frameTran,pairToCheck)

addpath lib
    
    %Load label image
    load(pathStructure)
    
    %load basal motif
    if frame=='end'
        Img1=Seq_Img_L{end};
    else
        Img1=Seq_Img_L{frame};
    end
    
    %load motif after transition
    if frameTran=='end'
        Img2=Seq_Img_L{end};
    else
        Img2=Seq_Img_L{frameTran};
    end
    
    %Get only 4 cells neighborhood image
    mask=Img1;
    mask1=mask;mask2=mask;mask3=mask;mask4=mask;
    mask1(mask~=cellsGroup(1))=0;mask2(mask~=cellsGroup(2))=0;mask3(mask~=cellsGroup(3))=0;mask4(mask~=cellsGroup(4))=0;
    mask=mask1+mask2+mask3+mask4;
    Img1=mask;   
    
    mask=Img2;
    mask1=mask;mask2=mask;mask3=mask;mask4=mask;
    mask1(mask~=cellsGroup(1))=0;mask2(mask~=cellsGroup(2))=0;mask3(mask~=cellsGroup(3))=0;mask4(mask~=cellsGroup(4))=0;
    mask=mask1+mask2+mask3+mask4;
    Img2=mask; 
    
    %Calculate neighbors 1
    [neighs,sidesCells]=calculateNeighbours(Img1);
    neigh2sides=find(sidesCells==2);
    neigh3sides=find(sidesCells==3);
    
    %Calculate edge distance 1
    [vertices1,~] = getVertices( Img1, neighs );
    edge1Dist=pdist([vertices1{1};vertices1{2}]);
    
    %Calculate neighbors 2
    [neighs,~]=calculateNeighbours(Img2);
    
    %Calculate edge distance 2
    [vertices2,~] = getVertices( Img2, neighs );
    edge2Dist=pdist([vertices2{1};vertices2{2}]);
    
    %calculate distance between 2 cells non neighs between them
    centr=regionprops(Img1,'Centroid');
    centr=cat(1,centr.Centroid);
    cent2neigh=centr(neigh2sides,:);
    cent3neigh=centr(neigh3sides,:);

    cent2Dist=pdist(cent2neigh);
    cent3Dist=pdist(cent3neigh);

    
    
    switch pairToCheck
        
        case {'loss'}
            %Scaled angle
            angleScaled=atand((cent3Dist*curvature*edge2Dist)/(2*hTransition*edge1Dist));
            %angleWithoutScaled
            angleWithoutScaled=atand((cent3Dist*edge2Dist)/(2*hTransition*edge1Dist));

        case {'gain'}
            %Scaled angle
            angleScaled=atand((cent2Dist*curvature*edge2Dist)/(2*hTransition*edge1Dist));
            %angleWithoutScaled
            angleWithoutScaled=atand((cent2Dist*edge2Dist)/(2*hTransition*edge1Dist));
    end
    
    

end