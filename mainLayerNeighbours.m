load('E:\Tina\results\LayerAnalysis\Layer_all\layerAnalysisVoronoi_10-Oct-2017.mat');
load('E:\Tina\Epithelia3D\Zebrafish\Results\Sample2\trackingLayer2.mat');

[neighs_real,sides_cells]=calculate_neighbours3D(img3DLabelled);

ratio=4;
[xgrid, ygrid, zgrid] = meshgrid(-ratio:ratio);
ball = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= ratio);
ids=vertcat(finalCentroid{:,1});

for numCell=1:size(neighs_real,2)
    
    BW = bwperim(img3DLabelled==numCell);
    BW_dilate=imdilate( BW ,ball);
    neighs=img3DLabelled(BW_dilate==1);
    [C,ia,ic] = unique(neighs);
    C=C(C~=0 & C~=numCell);
    neighs= neighs( neighs ~=0 &  neighs~=numCell);
    
    for numNeighs=1:size(C,1)    
        percentage=sum(neighs==C(numNeighs))/size(neighs,1);    
        neighs_real{1,numCell}(numNeighs,2)=percentage; 

        Ind = find(neighs_real{numCell}(numNeighs)==ids);
        neighs_real{1,numCell}(numNeighs,3)=finalCentroid{Ind(1,1), 3};
        
    end
    
end
save('neighbours_layer2.mat','neighs_real');

xlswrite('neighbours_layer2.xlsx','neighs_real');




