function [neigh_real, basicInfo]=deleteLowDilate(neigh_real, basicInfo, finalCentroid)
%DELETELOWDILATE %A filter is made to eliminate the shared information if the percentage that the
%cells share among each other is less than 0.0051

%load necessary variables
%load('neighbours_layer2.mat')
%load('trackingCentroidPruebafinal2.mat')

%Convert the variable tables into matrices
neigh_real=table2array(neigh_real);
basicInfo=table2array(basicInfo);

%What is commented is to see the errors that there are (layer 1 cells neighboring layer 3, etc.)

% neighsLayers(:,1)=neighs_real(:,1);
% neighsLayers(:,3)=neighs_real(:,5);
% neighsLayers(:,4)=neighs_real(:,3);
% neighsLayers(:,5)=neighs_real(:,4);
% 
% for num=1:size(basicInfos,1)
%     for numCellT=1:size(neighsLayers,1)
%         if neighsLayers(numCellT,1)==basicInfos{num,1}(1,1)
%             neighsLayers(numCellT,2)=basicInfos{num,5}(1,1);
%         end
%         
%     end
% end
% 
% acum=1;
% for numCell=1:size(neighsLayers,1)  
%     if neighsLayers(numCell,3)==(neighsLayers(numCell,2))+2 || neighsLayers(numCell,3)==(neighsLayers(numCell,2))+3
%         errors(acum,:)=neighsLayers(numCell,:);
%         acum=acum+1;
%     end
% end
% 
% % AFTER FILTER
% 
% neighs_real(neighs_real(:,4) < 0.0051, :) = [];
% neighsLayersAfter(:,1)=neighs_real(:,1);
% neighsLayersAfter(:,3)=neighs_real(:,5);
% neighsLayersAfter(:,4)=neighs_real(:,3);
% neighsLayersAfter(:,5)=neighs_real(:,4);
% 
% for num=1:size(basicInfos,1)
%     for numCellT=1:size(neighsLayersAfter,1)
%         if neighsLayersAfter(numCellT,1)==basicInfos{num,1}(1,1)
%             neighsLayersAfter(numCellT,2)=basicInfos{num,5}(1,1);
%         end
%         
%     end
% end
% 
% acum=1;
% for numCell=1:size(neighsLayersAfter,1)  
%     if neighsLayersAfter(numCell,3)==(neighsLayersAfter(numCell,2))+3 || neighsLayersAfter(numCell,3)==(neighsLayersAfter(numCell,2))+2
%         errorsAfterT(acum,:)=neighsLayersAfter(numCell,:);
%         acum=acum+1;
%     end
% end


%A filter is made to eliminate the shared information if the percentage that the
%cells share among each other is less than 0.0051
neigh_real(neigh_real(:,4) < 0.0051, :) = [];
acum=0;

%This loop modifies the number of neighbors that each cell of the variable has
%with the basic information according to the filter made before.
for num=1:size(basicInfo,1)
    for numNeigh=1:size(neigh_real,1)
        if neigh_real(numNeigh,1)==basicInfo{num,1}(1,1)
            acum=acum+1;
        end        
    end
    basicInfo{num,2}(1,1)=acum;
    acum=0;
end

% clear basicInfo neigh_real;
% neigh_real=neighs_real;
% basicInformation=basicInfos;

%These variables are saved again both in excel and in .mat file with a new name
neigh_real=array2table(neigh_real);
neigh_real.Properties.VariableNames={'ID', 'neighbours', 'sharedDilateArea', 'percentageShared', 'LayerNeigh', 'sharedRealArea'};

basicInfo=array2table(basicInformation);
basicInfo.Properties.VariableNames={'ID', 'numNeighbours', 'area', 'volumen', 'layer'};

writetable(neigh_real, 'neighbours_layer_filter2.xlsx', 'Sheet','sharedInfo');
writetable(basicInfo, 'neighbours_layer_filter2.xlsx', 'Sheet','basicInfo');

save('neighbours_layer_filter2.mat','neigh_real', 'basicInfo');

end