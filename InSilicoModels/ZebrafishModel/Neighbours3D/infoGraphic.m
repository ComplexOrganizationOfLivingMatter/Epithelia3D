function [basicInfoByLayer, infoSharedLayers, boxPercentage ]=infoGraphic(neigh_real, basicInfo, folderNumber)
%INFOGRAPHIC function that combines the information according to how you
%want to get graphics and an excel with the final data.


%The tables are converted into matrices to be able to handle the values that are inside them more easily
neighs_real=table2array(neigh_real);
basicInfos=table2array(basicInfo);
basicInfos=cell2mat(basicInfos);

% %A directory is created to save the graphics that are going to be created later.
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
fileNameExcel=['results\sample' sprintf('%d',folderNumber) '.xlsx'];
writetable(basicInfoLayer1, fileNameExcel, 'Sheet','basicInfoLayer1');
writetable(infoSharedLayers12,fileNameExcel, 'Sheet','basicInfoLayer2');
writetable(basicInfoLayer3, fileNameExcel, 'Sheet','basicInfoLayer3');

fileNameBasicInfoMat=['results\basicInfoByLayer' sprintf('%d',folderNumber) '.mat'];
save(fileNameBasicInfoMat,'basicInfoByLayer','Neigh','Area','Volumen','numCentroidByLayer','numNeighByLayer','stdNumNeighByLayer','areaByLayer', 'stdAreaByLayer', 'volumenByLayer', 'stdVolumenByLayer');


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

fileNameGraphicInfoBasic=['graphicBasicInfo' sprintf('%d',folderNumber) '.jpg'];
saveas(graphicBasicInfo,strcat(outputDir,fileNameGraphicInfoBasic)); %The image is saved


% Loop to obtain the information and thus be able to make the graphs of the information shared between layers
for numLayer=1:2
   %Declaration of accumulated variables initialized
   percentage10Shared=0;
   percentage20Shared=0;
   percentage30Shared=0;
   percentage40Shared=0;
   percentage50Shared=0;
   percentage60Shared=0;
   percentage70Shared=0;
   percentage80Shared=0;
   percentage90Shared=0;
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
    %of neighbors that it has of the next layer, the real area that it shares with these and the percentage.
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
    
    %Loop to divide the variable of the shared percentages by the number of neighbors
    for numCellShared=1:size(sharedPercentageWithOnlyNextLayer,1)
        actualNumNeigh=size(sharedPercentageWithOnlyNextLayer{numCellShared,1},1);
        sharedPercentageByNumNeigh{actualNumNeigh,1}(:,numCellShared)=sharedPercentageWithOnlyNextLayer{numCellShared,1}(:);
    end
    
    sharedPercentageWithOnlyNextLayerByNumNeigh=cellfun(@(x) x(x~=0),sharedPercentageByNumNeigh, 'UniformOutput', false);
    
    sharedPercentageWithOnlyNextLayerByNumNeigh{1,1}=sharedPercentageWithOnlyNextLayerByNumNeigh{1,1}';
    
    %This loop is made to count the number of neighbors according to the percentage they share
    %with the current layer, that is between 0 and 10%, 11-20%, and so on 91-100%
    for numNeighShared=1:size(sharedPercentageWithOnlyNextLayerByNumNeigh,1)
        for percentageByNeigh=1:size(sharedPercentageWithOnlyNextLayerByNumNeigh{numNeighShared,1},1)
            
            actualP=sharedPercentageWithOnlyNextLayerByNumNeigh{numNeighShared,1}(percentageByNeigh,1);
            
            if actualP<=10
                percentage10Shared=percentage10Shared+1;
            elseif actualP>10 && actualP<=20
                percentage20Shared=percentage20Shared+1;
            elseif actualP>20 && actualP<=30
                percentage30Shared=percentage30Shared+1;
            elseif actualP>30 && actualP<=40
                percentage40Shared=percentage40Shared+1;
            elseif actualP>40 && actualP<=50
                percentage50Shared=percentage50Shared+1;
            elseif actualP>50 && actualP<=60
                percentage60Shared=percentage60Shared+1;
            elseif actualP>60 && actualP<=70
                percentage70Shared=percentage70Shared+1;
            elseif actualP>70 && actualP<=80
                percentage80Shared=percentage80Shared+1;
            elseif actualP>80 && actualP<=90
                percentage90Shared=percentage90Shared+1;
            elseif actualP>90
                percentage100Shared=percentage100Shared+1;
            end
 
        end
        
        boxPercentage{numLayer, numNeighShared}(1,1)=percentage10Shared;
        boxPercentage{numLayer, numNeighShared}(2,1)=percentage20Shared;
        boxPercentage{numLayer, numNeighShared}(3,1)=percentage30Shared;
        boxPercentage{numLayer, numNeighShared}(4,1)=percentage40Shared;
        boxPercentage{numLayer, numNeighShared}(5,1)=percentage50Shared;
        boxPercentage{numLayer, numNeighShared}(6,1)=percentage60Shared;
        boxPercentage{numLayer, numNeighShared}(7,1)=percentage70Shared;
        boxPercentage{numLayer, numNeighShared}(8,1)=percentage80Shared;
        boxPercentage{numLayer, numNeighShared}(9,1)=percentage90Shared;
        boxPercentage{numLayer, numNeighShared}(10,1)=percentage100Shared;
        
        %Graphics
        graphicSharedInfoPercentage=figure;
        xPercentage=10:10:100;
        bar(xPercentage, boxPercentage{numLayer, numNeighShared})
        title(['percentageBoxWith' sprintf('%d',numNeighShared) 'SharedNeighsBetweenLayers' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1)])
        xlabel('Percentage')
        ylabel('Quantity of neighbors')
        nameGraphicPercentage=[outputDir 'percentageBoxWith' sprintf('%d',numNeighShared) 'SharedNeighsBetweenLayers' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1) 'Sample' sprintf('%d',folderNumber) '.jpg'];
        saveas(graphicSharedInfoPercentage, nameGraphicPercentage);
        
        %Clean variables
        percentage10Shared=0;
        percentage20Shared=0;
        percentage30Shared=0;
        percentage40Shared=0;
        percentage50Shared=0;
        percentage60Shared=0;
        percentage70Shared=0;
        percentage80Shared=0;
        percentage90Shared=0;
        percentage100Shared=0;

    end
        
        
  for numCellShared=1:size(sharedPercentageWithOnlyNextLayer,1)      
        %The mean and the standard deviation of the percentage of shared area are calculated
         AveragePercentageAreaShared(numCellShared,1)=mean(sharedPercentageWithOnlyNextLayer{numCellShared,1}(:,1));
         stdPercentageAreaShared(numCellShared,1)=std(sharedPercentageWithOnlyNextLayer{numCellShared,1}(:,1));
  end
   
    %So many figures are created by shared layers, that is to say two (1-2 and 2-3), where the
    %number of neighbors they share with the current layer is shown according to the percentage
    %they share. Then, they are saved.
    ytotalAreaShared=vertcat(infoSharedLayers{numLayer,1}(:,3));
    nameTitleGraphic=['ComparasionBetweenLayers' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1)];
    Color=parula(10); %colorcube

    graphicSharedInfoNumNeigh=figure;
    for i=1:size(AveragePercentageAreaShared,1)
        numNeighbours(i,1)=round(100/AveragePercentageAreaShared(i,1));
        plot(numNeighbours(i,1),ytotalAreaShared(i,1),'o','MarkerEdgeColor', Color(numNeighbours(i,1),:), 'MarkerFaceColor', Color(numNeighbours(i,1),:));
        hold on
    end
    title(nameTitleGraphic)
    ylabel('totalAreaRealShared')
    xlabel('NumNeigh')
    nameGraphicNumNeigh=[outputDir 'graphicSharedInfoNumNeighBetween' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1) 'Sample' sprintf('%d',folderNumber) '.jpg'];
    saveas(graphicSharedInfoNumNeigh, nameGraphicNumNeigh); 

    
    %So many figures are created by shared layers, that is to say two (1-2 and 2-3), where the total of
    %the shared area of each cell of the current layer is shown with the average of the percentage of 
    %the shared area of its neighbors. Then, they are saved.
    graphicSharedInfoAverageAreaShared=figure;
    for i=1:size(AveragePercentageAreaShared,1)
        numNeighbours(i,1)=round(100/AveragePercentageAreaShared(i,1));
        plot(AveragePercentageAreaShared(i,1),ytotalAreaShared(i,1),'o','MarkerEdgeColor', Color(numNeighbours(i,1),:), 'MarkerFaceColor', Color(numNeighbours(i,1),:));
        hold on
    end
    title(nameTitleGraphic)
    ylabel('totalAreaShared')
    xlabel('AveragePercentageSharedArea')
    nameGraphicAverageAreaShared=[outputDir 'graphicSharedInfoAverageAreaSharedBetween' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1) 'Sample' sprintf('%d',folderNumber) '.jpg'];
    saveas(graphicSharedInfoAverageAreaShared,nameGraphicAverageAreaShared);

    
    %The same as the figures performed before, but instead of the mean with the standard deviation.
    graphicSharedInfoStdAreaShared=figure;  
    for i=1:size(stdPercentageAreaShared,1)
        numNeighbours(i,1)=round(100/AveragePercentageAreaShared(i,1));
        plot(stdPercentageAreaShared(i,1),ytotalAreaShared(i,1),'o','MarkerEdgeColor', Color(numNeighbours(i,1),:), 'MarkerFaceColor', Color(numNeighbours(i,1),:));
        hold on
    end
    title(nameTitleGraphic)
    ylabel('totalAreaShared')
    xlabel('StdPercentageSharedArea')
    nameGraphicStdAreaShared=[outputDir 'graphicSharedInfoStdAreaSharedBetween' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1) 'Sample' sprintf('%d',folderNumber) '.jpg'];
    saveas(graphicSharedInfoStdAreaShared,nameGraphicStdAreaShared);
    
    %Certain variables are eliminated so that they do not overlap with the values already stored
    clear stdPercentageAreaShared AveragePercentageAreaShared basicInfoLayer id sharedPercentageWithOnlyNextLayer numNeigh areaRealShared percentageShared averageAreaRealShared averagePercentageShared totalAreaRealShared
    clear actualNumNeigh sharedPercentageByNumNeigh sharedPercentageWithOnlyNextLayerByNumNeigh actualP
      
  
    

end

close all 

%The variables are saved with the basic information of each cell and the information shared both
%in an Excel and in a .mat file
fileNameSharedInfoMat=['results\SharedInfoByLayer' sprintf('%d',folderNumber) '.mat'];
save(fileNameSharedInfoMat,'infoSharedLayers', 'boxPercentage');

infoSharedLayers12=vertcat(infoSharedLayers{1,1});
infoSharedLayers12=array2table(infoSharedLayers12);
infoSharedLayers12.Properties.VariableNames={'ID', 'numNeighboursLayer2', 'totalAreaRealShared', 'AverageAreaRealShared', 'AveragePercentageShared'};

infoSharedLayers23=vertcat(infoSharedLayers{2,1});
infoSharedLayers23=array2table(infoSharedLayers23);
infoSharedLayers23.Properties.VariableNames={'ID', 'numNeighboursLayer3', 'totalAreaRealShared', 'AverageAreaRealShared', 'AveragePercentageShared'};

boxPercentage12=horzcat(boxPercentage{1,:});
boxPercentage12=array2table(boxPercentage12);

boxPercentage23=horzcat(boxPercentage{2,:});
boxPercentage23=array2table(boxPercentage23);

writetable(infoSharedLayers12, fileNameExcel, 'Sheet','infoSharedLayers12');
writetable(infoSharedLayers23, fileNameExcel, 'Sheet','infoSharedLayers23');

writetable(boxPercentage12, fileNameExcel, 'Sheet','boxPercentage12');
writetable(boxPercentage23, fileNameExcel, 'Sheet','boxPercentage23');

end