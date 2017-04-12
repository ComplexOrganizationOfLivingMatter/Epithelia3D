function [cellsGroup,hTransition,hTransitionPredict,hCell,beta,curvature,L12,L34,L12PostCurvature,L34PostCurvature,CoordA,CoordB,LEdgeTransition,Coord1,Coord2,Coord3,Coord4]=recalculateCentroids(pathStructure,frame,cellsGroup,hTransition,curvature,D,alpha,hCell)


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
    neigh2sides=find(sidesCells==2);
    neigh3sides=find(sidesCells==3);
    
    %Calculate vertices
    [vertices,~] = getVertices( Img, neighs );
    
    %Get centroids
    centr=regionprops(Img,'Centroid');
    centr=cat(1,centr.Centroid);
    cent2neigh=centr(neigh2sides,:);
    cent3neigh=centr(neigh3sides,:);
    
    %Distance edge transition
    LEdgeTransition=pdist([vertices{1,1};vertices{1,2}]);
    LCentroids=pdist([cent3neigh(1,:);cent3neigh(2,:)]);
    
    
    %Real coordinates in cylinder projection, from 0,0 imaginary coordinates
    Ax=-asin((cos(alpha)*LEdgeTransition)/D)*(D/2);         Ay=(sin(alpha)*LEdgeTransition)/2;
    Bx=-Ax;     By=-Ay;
    X1= asin((sin(alpha)*LCentroids)/D)*(D/2); Y1=(cos(alpha)*LCentroids)/2;
    X2=-X1;    Y2=-Y1;
    
    
    
    CoordA=[Ax,Ay];
    CoordB=[Bx,By];
    Coord1=[X1,Y1];
    Coord2=[X2,Y2];
    
    
    
    %get distances between vertices and centroids 
    distX=mean([pdist([CoordA;Coord1]),pdist([CoordA;Coord2])]);
    distY=mean([pdist([CoordB;Coord1]),pdist([CoordB;Coord2])]);
    
    L_03=distX+LEdgeTransition/2;
    L_04=distY+LEdgeTransition/2;
    X3=-L_03*cos(alpha);Y3=L_03*sin(alpha);
    X4=L_04*cos(alpha);Y4=-L_04*sin(alpha);
    Coord3=[X3,Y3];
    Coord4=[X4,Y4];
    
    L34=pdist([Coord3;Coord4]);
    L12=pdist([Coord1;Coord2]);
    L12PostCurvature=pdist([[Coord1(1,1)*curvature Coord1(1,2)];[Coord2(1,1)*curvature Coord2(1,2)]]);
    L34PostCurvature=pdist([[Coord3(1,1)*curvature Coord3(1,2)];[Coord4(1,1)*curvature Coord4(1,2)]]);
    
    
    %Height transition. When L12 == L34
    %(Coord1(1,1)*X)^2 + Coord1(1,2)^2 = (Coord3(1,1)*X)^2 + Coord3(1,2)^2;
    % ((Coord1(1,1)^2)-(Coord3(1,1)^2))*X^2 = (Coord3(1,2)^2)-(Coord1(1,2)^2);
    % X = sqrt(((Coord3(1,2)^2)-(Coord1(1,2)^2))/((Coord1(1,1)^2)-(Coord3(1,1)^2)));
    
    curvTran = sqrt(abs((Coord3(1,2)^2)-(Coord1(1,2)^2))/abs((Coord1(1,1)^2)-(Coord3(1,1)^2)));
    hTransitionPredict= (D - (curvTran * D))/2;
   
    
    beta=alpha*180/pi;
    