function [nMotif,hTransition,hTransitionPredict,hCell,beta,curvature,L12,L34,L12PostCurvature,L34PostCurvature,CoordA,CoordB,LEdgeTransition,Coord1,Coord2,Coord3,Coord4]=predictHeightTransitionGastrulation(pathStructure,nMotif,hTransition,curvature,alpha,hCell)


    addpath lib
    
    %Load label image
    load(pathStructure)
    Img=motifSequence{nMotif};
       
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
   
    CoordA=vertices{1,1};
    CoordB=vertices{1,2};
    

    %Distance edge centroid
    LCentroids3=pdist([cent3neigh(1,:);cent3neigh(2,:)]);
    LCentroids2=pdist([cent2neigh(1,:);cent2neigh(2,:)]);

    %Centroid coordinates in basal face
    Coord1=cent3neigh(1,:);
    Coord2=cent3neigh(2,:);
    Coord3=cent2neigh(1,:);
    Coord4=cent2neigh(2,:);
    
    %Calculate x=0, as reference to recalculate this coordenate for each
    %centroid. x=0, will be x coordenate between CoordAx y CoordBx.
    xyReference=[mean(CoordA(1,1),CoordB(1,1)),mean(CoordA(1,2),CoordB(2,2))];
    Coord1=Coord1-xyReference;
    Coord2=Coord2-xyReference;
    Coord3=Coord3-xyReference;
    Coord4=Coord4-xyReference;
    CoordA=CoordA-xyReference;
    CoordB=CoordB-xyReference;
    
    L34=pdist([Coord3;Coord4]);
    L12=pdist([Coord1;Coord2]);
    L12PostCurvature=pdist([[Coord1(1,1)*curvature Coord1(1,2)];[Coord2(1,1)*curvature Coord2(1,2)]]);
    L34PostCurvature=pdist([[Coord3(1,1)*curvature Coord3(1,2)];[Coord4(1,1)*curvature Coord4(1,2)]]);


    %Height transition. When L12 == L34
    %(Coord1(1,1)*X)^2 + Coord1(1,2)^2 = (Coord3(1,1)*X)^2 + Coord3(1,2)^2;
    % ((Coord1(1,1)^2)-(Coord3(1,1)^2))*X^2 = (Coord3(1,2)^2)-(Coord1(1,2)^2);
    % X = sqrt(((Coord3(1,2)^2)-(Coord1(1,2)^2))/((Coord1(1,1)^2)-(Coord3(1,1)^2)));

    curvTran = sqrt(abs((Coord3(1,2)^2)-(Coord1(1,2)^2))/abs((Coord1(1,1)^2)-(Coord3(1,1)^2)));
    
    %Calculate an imaginary D.      h=(D-c*D)/2   ->   D=(2*h)/(1-c)
    
    D=(2*hCell)/(1-curvature);
    
    
    %Prediction of height transition
    hTransitionPredict= (D - (curvTran * D))/2;
        
    beta=alpha*180/pi;
    