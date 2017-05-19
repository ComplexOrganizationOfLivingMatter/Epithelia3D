function [cellsGroup,LEdgeTransition,angle,transition]=calculateLengthEdgeTransition(pathStructure,frame,cellsGroup,angle,transition)


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
    [neighs,sidesCells]=calculateNeighbours(Img);
        
    %Calculate vertices
    [vertices,~] = getVertices( Img, neighs );
       
    %Distance edge transition
    LEdgeTransition=pdist([vertices{1,1};vertices{1,2}]);


end

