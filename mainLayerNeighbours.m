% load('E:\Tina\results\LayerAnalysis\Layer_all\layerAnalysisVoronoi_16-Oct-2017.mat');
% load('E:\Tina\Epithelia3D\Zebrafish\Results\Sample2\trackingLayer2.mat');
% 
% [neighs_real,sides_cells]=calculate_neighbours3D(img3DLabelled);
% save('neighbours_layer2.mat','neighs_real');
% 
% ratio=4;
% [xgrid, ygrid, zgrid] = meshgrid(-ratio:ratio);
% ball = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= ratio);
% ids=vertcat(finalCentroid{:,1});
% 
% for numCell=1:size(neighs_real,2)
%     numCell
%     volumen=sum(sum(sum(img3DLabelled==numCell)));
%     BW = bwperim(img3DLabelled==numCell);
%     area=sum(sum(sum(BW)));
%     
%     BW_dilate=imdilate(BW ,ball);
%     neighs=img3DLabelled(BW_dilate==1);
%     [C,ia,ic] = unique(neighs);
%     C=C(C~=0 & C~=numCell);
%     neighs= neighs( neighs~=0 & neighs~=numCell);
%     
%     basicDates(numCell+1,1)=numCell;
%     basicDates(numCell+1,2)=size(C,1);
%     basicDates(numCell+1,3)=area;
%     basicDates(numCell+1,4)=volumen;
%     
%     for numNeighs=1:size(C,1)           
%         areaShared=sum(neighs==C(numNeighs));
%         percentage=areaShared/size(neighs,1);
%         
%         neigh_real{1,numCell}(numNeighs,1)=numCell;
%         neigh_real{1,numCell}(numNeighs,2)=neighs_real{1,numCell}(numNeighs,1);
%         neigh_real{1,numCell}(numNeighs,3)=areaShared; 
%         neigh_real{1,numCell}(numNeighs,4)=percentage;
%         Ind = find(neighs_real{numCell}(numNeighs)==ids);
%         neigh_real{1,numCell}(numNeighs,5)=finalCentroid{Ind(1,1), 3};
%     end
%     
%     if isempty(neighs_real{1,numCell})==0
%         dilatedArea(1,numCell)=sum(neigh_real{1,numCell}(:,3)); 
%         
%         for numNeighs=1:size(neighs_real{1,numCell},1)
%             neigh_real{1,numCell}(numNeighs,6)= ((neigh_real{1,numCell}(numNeighs,3))*area)/ dilatedArea(1,numCell);
%         end
%     end
% end
% 
% clear neighs_real
% neighs_real=neigh_real;
% 
% save('neighbours_layer2.mat','neighs_real', 'basicDates');


acum=2;
for numCell=1:size(neighs_real,2)  
    for numNeigh=1:size(neighs_real{1,numCell})
            neigh_real(acum,:)=neighs_real{1,numCell}(numNeigh,:);
            acum=acum+1;
    end
end

% neigh_real(1,1)='ID';
% neigh_real(1,2)='neighbours';
% neigh_real(1,3)='sharedDilateArea';
% neigh_real(1,4)='%Shared';
% neigh_real(1,5)='Layers';
% neigh_real(1,6)='sharedRealArea';
% 
% basicDates(1,1)='ID';
% basicDates(1,2)='nºNeighbours';
% basicDates(1,3)='area';
% basicDates(1,4)='volumen';

clear neighs_real
neighs_real=neigh_real;


save('neighbours_layer2.mat','neighs_real', 'basicDates');
xlswrite('neighbours_layer2.xlsx',basicDates,'basicDates');
xlswrite('neighbours_layer2.xlsx',neighs_real,'neighs_real');

