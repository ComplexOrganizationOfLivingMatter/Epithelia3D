function [nMotif,hTransition,hTransitionPredict,hCell,beta,curvature,L12,L34,L12PostCurvature,L34PostCurvature,CoordA,CoordB,LEdgeTransition,Coord1,Coord2,Coord3,Coord4]=recalculateCentroidsGastrulationHeightTranPrediction(pathStructure,nMotif,hTransition,curvature,alpha,hCell,validCentroidCell)


    addpath lib
    
    %Load label image
    load(pathStructure)
    Img=Img_Seq{nMotif};
       
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
    
    %Calculate an imaginary D.      h=(D-c*D)/2   ->   D=(2*h)/(1-c)
    D=(2*hCell)/(1-curvature);
    
    %Distance edge transition
    LEdgeTransition=pdist([vertices{1,1};vertices{1,2}]);
    %Real coordinates vertices in transition edges, from 0,0 imaginary coordinates
    Ax=-asin(mod((cos(alpha)*LEdgeTransition)/D,1))*(D/2);         Ay=(sin(alpha)*LEdgeTransition)/2;
    Bx=-Ax;     By=-Ay;
    CoordA=[Ax,Ay];
    CoordB=[Bx,By];
    
    %CENTROID ARE CORRECT IN 3 NEIGHS CELLS
    if (validCentroidCell==3)
        %Distance edge centroid
        LCentroids=pdist([cent3neigh(1,:);cent3neigh(2,:)]);
        X1= asin(mod((sin(alpha)*LCentroids)/D,1))*(D/2); Y1=(cos(alpha)*LCentroids)/2;
        X2=-X1;    Y2=-Y1;
     
        
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

        
    end
    
    %CENTROID ARE CORRECT IN 2 NEIGHS CELLS
    if (validCentroidCell==2)
        %Distance edge centroid
        LCentroids=pdist([cent2neigh(1,:);cent2neigh(2,:)]);
        X3= -asin(mod((cos(alpha)*LCentroids)/D,1))*(D/2); Y3=(sin(alpha)*LCentroids)/2;
        X4=-X3;    Y4=-Y3;
        
        Coord3=[X3,Y3];
        Coord4=[X4,Y4];
        %get distances between vertices and centroids 
        distX=pdist([CoordA;Coord3]);
        distY=pdist([CoordB;Coord4]);

        angAux=acos((LEdgeTransition/2)/mean([distX,distY]));
        L_01=mean([distX,distY])*sin(angAux);
        L_02=L_01;
        
        X1=-L_01*sin(alpha);Y1=-L_01*cos(alpha);
        X2=L_02*sin(alpha);Y2=L_02*cos(alpha);
        
        Coord1=[X1,Y1];
        Coord2=[X2,Y2];
               
        L34=pdist([Coord3;Coord4]);
        L12=pdist([Coord1;Coord2]);
        
    end
   
    
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
    