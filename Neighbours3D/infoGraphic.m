function [basicInfoByLayer, infoSharedLayers, boxPercentage]=infoGraphic(neigh_real, basicInfo)
%INFOGRAPHIC function that combines the information according to how you
%want to get graphics and an excel with the final data.

%Filtered data is loaded
%load('results\neighbours_layer_filter2.mat')

%The tables are converted into matrices to be able to handle the values that are inside them more easily
neighs_real=table2array(neigh_real);
basicInfos=table2array(basicInfo);
basicInfos=cell2mat(basicInfos);

%A directory is created to save the graphics that are going to be created later.
outputDir = strcat('results\Graphics\'); 
mkdir(outputDir)

% Loop to obtain the information and thus be able to make the graphs of the basic information
acum=0;
acum1=1;
for numLayer=1:max(basicInfos(:,5))
    %With this loop you divide the basic information such as the number of neighbors, area and volume by layers
    for numCell=1:size(basicInfos,1)
        if basicInfos(numCell,5)==numLayer
            acum=acum+1;
            Neigh{numLayer,1}(acum1,1)=basicInfos(numCell,2);
            Area{numLayer,1}(acum1,1)=basicInfos(numCell,3);
            Volumen{numLayer,1}(acum1,1)=basicInfos(numCell,4);
            basicInfoByLayer{numLayer,1}(acum1,:)=basicInfos(numCell,1:4);
            acum1=acum1+1;
           
        end
    end
    %It calculates the number of cells there are by layers and the means and their standard 
    %deviations of the number of neighbors, area and volume by layers
    numCentroidByLayer(numLayer,1)=acum;
    numNeighByLayer(numLayer,1)=mean(vertcat(Neigh{numLayer,1}(:,1)));
    stdNumNeighByLayer(numLayer,1)=std(vertcat(Neigh{numLayer,1}(:,1)));
    areaByLayer(numLayer,1)=mean(vertcat(Area{numLayer,1}(:,1)));
    stdAreaByLayer(numLayer,1)=std(vertcat(Area{numLayer,1}(:,1)));
    volumenByLayer(numLayer,1)=mean(vertcat(Volumen{numLayer,1}(:,1)));
    stdVolumenByLayer(numLayer,1)=std(vertcat(Volumen{numLayer,1}(:,1)));

    acum=0;
    acum1=1;
end

%The basic information is compiled and it is obtained in three sheets of an excel, one per
%layer, where the ID, the number of neighbors, the area and the volume that each of them has is found.
basicInfoLayer1=vertcat(basicInfoByLayer{1,1});
basicInfoLayer1=array2table(basicInfoLayer1);
basicInfoLayer1.Properties.VariableNames={'ID', 'numNeighbours', 'area', 'volumen'};

infoSharedLayers12=vertcat(basicInfoByLayer{2,1});
infoSharedLayers12=array2table(infoSharedLayers12);
infoSharedLayers12.Properties.VariableNames={'ID', 'numNeighbours', 'area', 'volumen'};

basicInfoLayer3=vertcat(basicInfoByLayer{3,1});
basicInfoLayer3=array2table(basicInfoLayer3);
basicInfoLayer3.Properties.VariableNames={'ID', 'numNeighbours', 'area', 'volumen'};

%Apart from saving the data in an excel it is saved in a .mat
writetable(basicInfoLayer1, 'sample2.xlsx', 'Sheet','basicInfoLayer1');
writetable(infoSharedLayers12, 'sample2.xlsx', 'Sheet','basicInfoLayer2');
writetable(basicInfoLayer3, 'sample2.xlsx', 'Sheet','basicInfoLayer3');

save('results\basicInfoByLayer2.mat','basicInfoByLayer','Neigh','Area','Volumen','numCentroidByLayer','numNeighByLayer','stdNumNeighByLayer','areaByLayer', 'stdAreaByLayer', 'volumenByLayer', 'stdVolumenByLayer');


%A figure is created that will have 4 graphs.
graphicBasicInfo=figure;
xNumLayer= 1:max(basicInfos(:,5))-1;

yNumCellByLayer = numCentroidByLayer(xNumLayer,1);%Graph of the number of cells that there are by layers.
subplot(2,2,1), bar(xNumLayer,yNumCellByLayer), title('numCellByLayer')

yAreaByLayer=areaByLayer(xNumLayer,1); %Graph of the average of the areas of the cells of each layer.
subplot(2,2,2), bar(xNumLayer,yAreaByLayer), title('AverageAreaByLayer')

yVolumenByLayer=volumenByLayer(xNumLayer,1);%Graph of the average of the volumes of the cells of each layer.
subplot(2,2,3), bar(xNumLayer,yVolumenByLayer), title('AverageVolumenByLayer')

yNumNeighByLayer=numNeighByLayer(xNumLayer,1);%Graph of the average of the number of neighbors that has the cells of each layer.
subplot(2,2,4), bar(xNumLayer,yNumNeighByLayer), title('AverageNumNeighByLayer')


saveas(graphicBasicInfo,strcat(outputDir,'graphicBasicInfo.jpg')); %The image is saved


% Loop to obtain the information and thus be able to make the graphs of the information shared between layers
for numLayer=1:2
    %Declaration of accumulated variables initialized
    percentage25Shared=0;
    percentage50Shared=0;
    percentage75Shared=0;
    percentage100Shared=0;
    
    acum=1;
    acum1=1;
    
    %Loop that separates the variable with the information shared between layers and the neighbors of the next
    %layer. So it would be the cells of the current layer that have at least one neighbor in the next layer.
    for numCell=1:size(basicInfos)
        if basicInfos(numCell,5)==numLayer 
            basicInfoLayer(acum1,:)=basicInfos(numCell,:);
            acum1=acum1+1;
            for numTrack=1:size(neighs_real,1)
                if (neighs_real(numTrack,1)==basicInfos(numCell,1)) && (neighs_real(numTrack,5)==(numLayer+1))
                    cellsSharedByLayers{numLayer,1}(acum,:)=neighs_real(numTrack,:);
                    acum=acum+1;
                end
            end
        end
    end
    
    acum=1;
    %it takes the IDs of the cells of the current layer that have at least one neighbor in the next layer
    id=unique(vertcat(cellsSharedByLayers{numLayer,1}(:,1)),'rows'); 
    
    %The variable created in the previous loop is traversed to obtain the following information: the number
    %of neighbors that it has of the next layer, the Real area that it shares with these and the percentage.
    for numIds=1:size(id,1)
        for numTrack=1:size(cellsSharedByLayers{numLayer,1},1)
            if cellsSharedByLayers{numLayer,1}(numTrack,1)==id(numIds,1)
                numNeigh(numIds,1)=acum;
                areaRealShared{numIds,1}(acum,1)=cellsSharedByLayers{numLayer,1}(numTrack,6);
                percentageShared{numIds,1}(acum,1)=cellsSharedByLayers{numLayer,1}(numTrack,4);
                acum=acum+1;
            end
        end
        %The average of the shared area of the neighbors of each cell and its percentage is calculated  
        averageAreaRealShared(numIds,1)=mean(vertcat(areaRealShared{numIds,1}(:,1)));
        averagePercentageShared(numIds,1)=mean(vertcat(percentageShared{numIds,1}(:,1)));
        
        %The total area shared by each cell of the current layer is calculated with the next one
        %and the percentage occupied by the neighboring cells of the next layer with each cell of
        %the current layer
        totalAreaRealShared(numIds,1)=sum(vertcat(areaRealShared{numIds,1}(:,1)));
        sharedPercentageWithOnlyNextLayer{numIds,1}(:,1)=(areaRealShared{numIds,1}(:,1)*100)/totalAreaRealShared(numIds,1);
        
        acum=1;
    end
    
    %The information obtained in the loop is stored in this new variable
    infoSharedLayers{numLayer,1}(:,1)=id(:,1);
    infoSharedLayers{numLayer,1}(:,2)=numNeigh(:,1);
    infoSharedLayers{numLayer,1}(:,3)=totalAreaRealShared(:,1);
    infoSharedLayers{numLayer,1}(:,4)=averageAreaRealShared(:,1);
    infoSharedLayers{numLayer,1}(:,5)=averagePercentageShared(:,1);
    
    %This loop is made to count the number of neighbors according to the percentage they share
    %with the current layer, that is between 0 and 25%, 25-50%, 50-75% and 75-100%
   for numCellShared=1:size(sharedPercentageWithOnlyNextLayer,1)
        for numNeigh=1:size(sharedPercentageWithOnlyNextLayer{numCellShared,1},1)
            actualP=sharedPercentageWithOnlyNextLayer{numCellShared,1}(numNeigh,1);
            if actualP<=25
                percentage25Shared=percentage25Shared+1;
            elseif actualP>25 && actualP<=50
                percentage50Shared=percentage50Shared+1;
            elseif actualP>50 && actualP<=75
                percentage50Shared=percentage50Shared+1;
            elseif actualP>75 
                percentage100Shared=percentage100Shared+1;
            end
        end
        %The mean and the standard deviation of the percentage of shared area are calculated
         AveragePercentageAreaShared(numCellShared,1)=mean(sharedPercentageWithOnlyNextLayer{numCellShared,1}(:,1));
         stdPercentageAreaShared(numCellShared,1)=std(sharedPercentageWithOnlyNextLayer{numCellShared,1}(:,1));
   end
    %The result of the previous loop is stored by layers
    boxPercentage(numLayer,1)=percentage25Shared;
    boxPercentage(numLayer,2)=percentage50Shared;
    boxPercentage(numLayer,3)=percentage75Shared;
    boxPercentage(numLayer,4)=percentage100Shared;
    
    %So many figures are created by shared layers, that is to say two (1-2 and 2-3), where the
    %number of neighbors they share with the current layer is shown according to the percentage
    %they share. Then, they are saved.
    graphicSharedInfoPercentage=figure;
    yPercentage=boxPercentage(numLayer,:);
    xPercentage=25:25:100;
    bar(xPercentage, yPercentage)
    nameGraphicPercentage=[outputDir 'SharedInfoPercentageBetween' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1) '.jpg'];
    saveas(graphicSharedInfoPercentage, nameGraphicPercentage);
       
    ytotalAreaShared=vertcat(infoSharedLayers{numLayer,1}(:,3));
    nameTitleGraphic=['ComparasionBetweenLayers' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1)];
    
%     graphicSharedInfoNumNeigh=figure;
%     yNumNeigh = vertcat(infoSharedLayers{numLayer,1}(:,2));
%     plot(xtotalAreaRealShared, yNumNeigh,'bo')
%     title(nameTitleGraphic)
%     xlabel('totalAreaRealShared')
%     ylabel('NumNeigh')
%     nameGraphicNumNeigh=[outputDir 'graphicSharedInfoNumNeighBetween' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1) '.jpg'];
%     saveas(graphicSharedInfoNumNeigh, nameGraphicNumNeigh); 
    
    %So many figures are created by shared layers, that is to say two (1-2 and 2-3), where the total of
    %the shared area of each cell of the current layer is shown with the average of the percentage of 
    %the shared area of its neighbors. Then, they are saved.
    graphicSharedInfoAverageAreaShared=figure;
    plot(AveragePercentageAreaShared,ytotalAreaShared,'bo')
    title(nameTitleGraphic)
    ylabel('totalAreaShared')
    xlabel('AveragePercentageSharedArea')
    nameGraphicAverageAreaShared=[outputDir 'graphicSharedInfoAverageAreaSharedBetween' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1) '.jpg'];
    saveas(graphicSharedInfoAverageAreaShared,nameGraphicAverageAreaShared);
    
    %The same as the figures performed before, but instead of the mean with the standard deviation.
    graphicSharedInfoStdAreaShared=figure;
    plot(stdPercentageAreaShared,ytotalAreaShared,'bo')
    title(nameTitleGraphic)
    ylabel('totalAreaShared')
    xlabel('StdPercentageSharedArea')
    nameGraphicStdAreaShared=[outputDir 'graphicSharedInfoStdAreaSharedBetween' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1) '.jpg'];
    saveas(graphicSharedInfoStdAreaShared,nameGraphicStdAreaShared);
        
       
%     graphicSharedInfoAveragePercentageShared=figure;
%     yAveragePercentageShared=vertcat(infoSharedLayers{numLayer,1}(:,5));
%     plot(xtotalAreaRealShared,yAveragePercentageShared,'bo')
%     title(nameTitleGraphic)
%     xlabel('totalAreaRealShared')
%     ylabel('AveragePercentageShared')
%     nameGraphicAveragePercentageShared=[outputDir 'graphicSharedInfoAveragePercentageSharedBetween' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1) '.jpg'];
%     saveas(graphicSharedInfoAveragePercentageShared,nameGraphicAveragePercentageShared);
    
    %Certain variables are eliminated so that they do not overlap with the values already stored
    clear stdPercentageAreaShared AveragePercentageAreaShared basicInfoLayer id sharedPercentageWithOnlyNextLayer numNeigh areaRealShared percentageShared averageAreaRealShared averagePercentageShared totalAreaRealShared
end


%The variables are saved with the basic information of each cell and the information shared both
%in an Excel and in a .mat file

save('results\basicSharedByLayer2.mat','infoSharedLayers', 'boxPercentage');

infoSharedLayers12=vertcat(infoSharedLayers{1,1});
infoSharedLayers12=array2table(infoSharedLayers12);
infoSharedLayers12.Properties.VariableNames={'ID', 'numNeighboursLayer2', 'totalAreaRealShared', 'AverageAreaRealShared', 'AveragePercentageShared'};

infoSharedLayers23=vertcat(infoSharedLayers{2,1});
infoSharedLayers23=array2table(infoSharedLayers23);
infoSharedLayers23.Properties.VariableNames={'ID', 'numNeighboursLayer3', 'totalAreaRealShared', 'AverageAreaRealShared', 'AveragePercentageShared'};


writetable(infoSharedLayers12, 'sample2.xlsx', 'Sheet','infoSharedLayers12');
writetable(infoSharedLayers23, 'sample2.xlsx', 'Sheet','infoSharedLayers23');

end