function [neighs_real,sides_cells]=LayerNeighbours(img3DLabelled, finalCentroid)


[neighs_real,sides_cells]=calculate_neighbours3D(img3DLabelled);
% save('neighbours_layer_Medio2.mat','neighs_real');


%The structure (ball) of the dilation of the cells is created with a radius of 4.
ratio=4;
[xgrid, ygrid, zgrid] = meshgrid(-ratio:ratio);
ball = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= ratio);

%I keep in one variable the tracking IDs of all the cells.
ids=vertcat(finalCentroid{:,1});

%A new variable is created that contains the IDs of all the cells and with their 
%respective layers to which they belong. It becomes a matrix and, finally, it is
%filtered so that there are no values repeated by rows.
finalC(:,1)=finalCentroid(:,1);
finalC(:,2)=finalCentroid(:,3);
finalC=cell2mat(finalC);
finalC=unique(finalC,'rows');

%Loop that goes through all the cells to see the neighbors that it has, that is,
%it goes through the variable neighs_real, to get the basic information of each 
%cell and what they share between layers.
for numCell=1:size(neighs_real,2)
    numCell %to keep track of the cells
    volumen=sum(sum(sum(img3DLabelled==numCell))); %calculation of the volume of the cell
    BW = bwperim(img3DLabelled==numCell);
    area=sum(sum(sum(BW)));%calculation of the area of the cell
    
    %It dilates the cells with the structure created before and it takes the neighbors of
    %the cell that is being treated. 
    BW_dilate=imdilate(BW ,ball); 
    pixelsDilated=img3DLabelled(BW_dilate==1);
    [uniqueNeigh,ia,ic] = unique(pixelsDilated); 
    
    %the zero and the cell that is being analyzed are removed from the neighbor list
    uniqueNeigh=uniqueNeigh(uniqueNeigh~=0 & uniqueNeigh~=numCell);
    pixelsDilated= pixelsDilated( pixelsDilated~=0 & pixelsDilated~=numCell);
    
    %A variable is created with the layers.
    layer=finalC(numCell,2);
    
    %A variable is created with the basic information of each cell with its ID,
    %the number of neighbors it has, its area, its volume and the layer that belongs
    basicInformation{numCell,1}=numCell;
    basicInformation{numCell,2}=size(uniqueNeigh,1);
    basicInformation{numCell,3}=area;
    basicInformation{numCell,4}=volumen;
    basicInformation{numCell,5}=layer;
    
    %Now the neighbors of the cell that is being analyzed are traversed to obtain the information they share
    for numNeighs=1:size(uniqueNeigh,1)
        %The area that the analyzed cell shares with its neighbors and the percentage is calculated. 
        %Keep in mind that this measure is not the real one but the extended one.
        areaShared=sum(pixelsDilated==uniqueNeigh(numNeighs));
        percentage=areaShared/size(pixelsDilated,1);
        
        %A variable is created with the information shared between the cell that is being analyzed and its
        %neighbors, which will have the ID of the cell, the ID of the neighboring cell, the dilated area that
        %they share, the percentage they share and the layer to the which belongs to the neighboring cell.
        neigh_real{1,numCell}(numNeighs,1)=numCell;
        neigh_real{1,numCell}(numNeighs,2)=neighs_real{1,numCell}(numNeighs,1);
        neigh_real{1,numCell}(numNeighs,3)=areaShared; 
        neigh_real{1,numCell}(numNeighs,4)=percentage;
        Ind = find(neighs_real{numCell}(numNeighs)==ids);
        neigh_real{1,numCell}(numNeighs,5)=finalCentroid{Ind(1,1), 3};
    end
    
    %The real area shared by the cell that is being analyzed with its neighbors is also calculated and
    %stored in the shared information variable.
    if isempty(neighs_real{1,numCell})==0
        dilatedArea(1,numCell)=sum(neigh_real{1,numCell}(:,3)); 
        for numNeighs=1:size(neigh_real{1,numCell},1)
            neigh_real{1,numCell}(numNeighs,6)= ((neigh_real{1,numCell}(numNeighs,3))*area)/ dilatedArea(1,numCell);
        end
    end
end

clear neighs_real
neighs_real=neigh_real;


%The variables are saved with the basic information of each cell and the information shared both
%in an Excel and in a .mat file
neigh_real=vertcat(neighs_real{:});
neigh_real=array2table(neigh_real);
neigh_real.Properties.VariableNames={'ID', 'neighbours', 'sharedDilateArea', 'percentageShared', 'LayerNeigh', 'sharedRealArea'};

basicInfo=array2table(basicInformation);
basicInfo.Properties.VariableNames={'ID', 'numNeighbours', 'area', 'volumen', 'layer'};

writetable(neigh_real, 'neighbours_layer2.xlsx', 'Sheet','sharedInfo');
writetable(basicInfo, 'neighbours_layer2.xlsx', 'Sheet','basicInfo');

save('neighbours_layer2.mat','neigh_real', 'basicInfo');

%Function to filter the variables
[neigh_real, basicInfo]=deleteLowDilate(neigh_real, basicInfo, finalCentroid);

%Function that combines the information according to how you
%want to get graphics and an excel with the final data.
[neigh_real, basicInfo]=infoGraphic(neigh_real, basicInfo);

end
