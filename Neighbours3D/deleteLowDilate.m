

load('neighbours_layer2.mat')
load('trackingCentroidPruebafinal2.mat')

neighs_real=table2array(neigh_real);
basicInfos=table2array(basicInfo);

%Lo que esta comentado es para ver los errores que hay (celulas de capa 1
%vecinas de capa 3, etc

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

neighs_real(neighs_real(:,4) < 0.0051, :) = [];
acum=0;
for num=1:size(basicInfos,1)
    for numNeigh=1:size(neighs_real,1)
        if neighs_real(numNeigh,1)==basicInfos{num,1}(1,1)
            acum=acum+1;
        end        
    end
    basicInfos{num,2}(1,1)=acum;
    acum=0;
end

clear basicInfo neigh_real;
neigh_real=neighs_real;
basicInformation=basicInfos;

neigh_real=array2table(neigh_real);
neigh_real.Properties.VariableNames={'ID', 'neighbours', 'sharedDilateArea', 'percentageShared', 'LayerNeigh', 'sharedRealArea'};

basicInfo=array2table(basicInformation);
basicInfo.Properties.VariableNames={'ID', 'numNeighbours', 'area', 'volumen', 'layer'};

writetable(neigh_real, 'neighbours_layer_filter2.xlsx', 'Sheet','sharedInfo');
writetable(basicInfo, 'neighbours_layer_filter2.xlsx', 'Sheet','basicInfo');

save('neighbours_layer_filter2.mat','neigh_real', 'basicInfo');

