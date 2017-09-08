%Created by Pablo Vicente-Munuera helped by Pedro Gómez-Gálvez

% Script to create all the hexagonal grids that we'll be using 
% in all the functions creating the adjacencyMatrixHexagonalGrid... file
% We vary the radius (apothem) of the hexagon from 4 to 100, getting
% 94 different masks.

H = 1024;
W = 512;
listNhexagons=[2 4 8 16 32];
for j = 1:length(listNhexagons)
    %%Elegimos el diametro de los hexágonos
    gridStep = round(W/listNhexagons(j));
        
    %%Con meshgrid obtenemos puntos equidistantes en una matriz cuadrada
    [X Y] = meshgrid(1:gridStep:W,1:gridStep:H);
    numColumns=size(X,2);
    if (mod(W,gridStep)==0)
        for i=1:round(numColumns/2-0.001)
            if i==1
                X(end+1,2*i-1)=1;
                Y(end+1,2*i-1)=H;
            else
                X(end,2*i-1)=X(end-1,2*i-1);
                Y(end,2*i-1)=H;
            end
        end
    end
    Xprim=X;Yprim=Y;
    n = size(X,1);
    
    %%Rad3Over2 se utiliza para adquirir la forma hexagonal
%     Rad3Over2=sqrt(3)/2;
%     X = Rad3Over2 * X;
%     X = round(X);
    
    %%Obtenemos las coordenadas Y de las semillas
    mat2sum=repmat([0 ((X(1,2)-X(1,1))/2)],n,n);
    Y = Y + mat2sum(1:n,1:size(X,2));
    Y = round(Y);
    Y=reshape(Y,[],1);
    X=reshape(X,[],1);
    Y(X==0)=0;
    X(Y>H)=0;
    Y(Y>H)=0;
    X(X==0)=[];Y(Y==0)=[];
%     voronoi(X,Y)
%     axis equal, axis([0 W 0 H])
    
     seeds=[Y,X];
     seeds(seeds(:,2)>W,:)=[];
    
     seeds_values_before=0;
     Folder2save=['cylinderOfHexagons\' num2str(size(seeds,1)) '_seeds\'];
     Voronoi_salivary_gland_generator(1,1,H,W,seeds,seeds_values_before,Folder2save);
 
     
end