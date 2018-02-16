load('neighbours_layer_filter2.mat')

neighs_real=table2array(neigh_real);
basicInfos=table2array(basicInfo);
basicInfos=cell2mat(basicInfos);

outputDir = strcat('results\Graphics\'); 
mkdir(outputDir)

% Loop to obtain the information and thus be able to make the graphs of the basic information
acum=0;
acum1=1;
for numLayer=1:max(basicInfos(:,5))
    for numCell=1:size(basicInfos,1)
        if basicInfos(numCell,5)==numLayer
            acum=acum+1;
            Neigh{numLayer,1}(acum1,1)=basicInfos(numCell,2);%+sumNeigh;
            Area{numLayer,1}(acum1,1)=basicInfos(numCell,3);%+sumArea;
            Volumen{numLayer,1}(acum1,1)=basicInfos(numCell,4);%+sumVolumen;
            basicInfoByLayer{numLayer,1}(acum1,:)=basicInfos(numCell,1:4);
            acum1=acum1+1;
           
        end
    end
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


basicInfoLayer1=vertcat(basicInfoByLayer{1,1});
basicInfoLayer1=array2table(basicInfoLayer1);
basicInfoLayer1.Properties.VariableNames={'ID', 'numNeighbours', 'area', 'volumen'};

infoSharedLayers12=vertcat(basicInfoByLayer{2,1});
infoSharedLayers12=array2table(infoSharedLayers12);
infoSharedLayers12.Properties.VariableNames={'ID', 'numNeighbours', 'area', 'volumen'};

basicInfoLayer3=vertcat(basicInfoByLayer{3,1});
basicInfoLayer3=array2table(basicInfoLayer3);
basicInfoLayer3.Properties.VariableNames={'ID', 'numNeighbours', 'area', 'volumen'};

writetable(basicInfoLayer1, 'sample2.xlsx', 'Sheet','basicInfoLayer1');
writetable(infoSharedLayers12, 'sample2.xlsx', 'Sheet','basicInfoLayer2');
writetable(basicInfoLayer3, 'sample2.xlsx', 'Sheet','basicInfoLayer3');

save('basicInfoByLayer2.mat','basicInfoByLayer','Neigh','Area','Volumen','numCentroidByLayer','numNeighByLayer','stdNumNeighByLayer','areaByLayer', 'stdAreaByLayer', 'volumenByLayer', 'stdVolumenByLayer');



graphicBasicInfo=figure;
xNumLayer= 1:max(basicInfos(:,5))-1;

yNumCellByLayer = numCentroidByLayer(xNumLayer,1);
subplot(2,2,1), bar(xNumLayer,yNumCellByLayer), title('numCellByLayer')

yAreaByLayer=areaByLayer(xNumLayer,1);
subplot(2,2,2), bar(xNumLayer,yAreaByLayer), title('AverageAreaByLayer')

yVolumenByLayer=volumenByLayer(xNumLayer,1);
subplot(2,2,3), bar(xNumLayer,yVolumenByLayer), title('AverageVolumenByLayer')

yNumNeighByLayer=numNeighByLayer(xNumLayer,1);
subplot(2,2,4), bar(xNumLayer,yNumNeighByLayer), title('AverageNumNeighByLayer')


saveas(graphicBasicInfo,strcat(outputDir,'graphicBasicInfo.jpg'));



% Loop to obtain the information and thus be able to make the graphs of the information shared between layers


for numLayer=1:2
    acum=1;
    acum1=1;
    for numCell=1:size(basicInfos)
        if basicInfos(numCell,5)==numLayer 
            basicInfoLayer(acum1,:)=basicInfos(numCell,:);
            acum1=acum1+1;
            for numTrack=1:size(neighs_real,1)
                if (neighs_real(numTrack,1)==basicInfos(numCell,1)) && (neighs_real(numTrack,5)==(numLayer+1))
                    cellsSharedByLayers(acum,:)=neighs_real(numTrack,:);
                    acum=acum+1;
                end
            end
        end
    end
    
    acum=1;
    id=unique(cellsSharedByLayers(:,1),'rows');
    for numIds=1:size(id,1)
        for numTrack=1:size(cellsSharedByLayers,1)
            if cellsSharedByLayers(numTrack,1)==id(numIds,1)
                numNeigh(numIds,1)=acum;
                areaRealShared{numIds,1}(acum,1)=cellsSharedByLayers(numTrack,6);
                percentageShared{numIds,1}(acum,1)=cellsSharedByLayers(numTrack,4);
                acum=acum+1;
            end
        end
        totalAreaRealShared(numIds,1)=sum(vertcat(areaRealShared{numIds,1}(:,1)));
        averageAreaRealShared(numIds,1)=mean(vertcat(areaRealShared{numIds,1}(:,1)));
        averagePercentageShared(numIds,1)=mean(vertcat(percentageShared{numIds,1}(:,1)));
        
%         for numCellLayer=1:size(basicInfoLayer,1)
%             if basicInfoLayer(numCellLayer,1)==id(numIds,1)
%                 arealayer(numIds,1)=basicInfoLayer(numCellLayer,3);
%             end
%         end
        acum=1;
    end
    
    infoSharedLayers{numLayer,1}(:,1)=id(:,1);
    infoSharedLayers{numLayer,1}(:,2)=numNeigh(:,1);
    infoSharedLayers{numLayer,1}(:,3)=totalAreaRealShared(:,1);
    infoSharedLayers{numLayer,1}(:,4)=averageAreaRealShared(:,1);
    infoSharedLayers{numLayer,1}(:,5)=averagePercentageShared(:,1);
    
    
    
    xtotalAreaRealShared=vertcat(infoSharedLayers{numLayer,1}(:,3));
    nameTitleGraphic=['ComparasionBetweenLayers' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1)];
    
    graphicSharedInfoNumNeigh=figure;
    yNumNeigh = vertcat(infoSharedLayers{numLayer,1}(:,2));
    plot(xtotalAreaRealShared, yNumNeigh,'bo')
    title(nameTitleGraphic)
    xlabel('totalAreaRealShared')
    ylabel('NumNeigh')
    nameGraphicNumNeigh=[outputDir 'graphicSharedInfoNumNeighBetween' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1) '.jpg'];
    saveas(graphicSharedInfoNumNeigh, nameGraphicNumNeigh); 
        
    graphicSharedInfoAverageAreaRealShared=figure;
    yAverageAreaRealShared=vertcat(infoSharedLayers{numLayer,1}(:,4));
    plot(xtotalAreaRealShared,yAverageAreaRealShared,'bo')
    title(nameTitleGraphic)
    xlabel('totalAreaRealShared')
    ylabel('AverageAreaRealShared')
    nameGraphicAverageAreaRealShared=[outputDir 'graphicSharedInfoAverageAreaRealSharedBetween' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1) '.jpg'];
    saveas(graphicSharedInfoAverageAreaRealShared,nameGraphicAverageAreaRealShared);
    
    graphicSharedInfoAveragePercentageShared=figure;
    yAveragePercentageShared=vertcat(infoSharedLayers{numLayer,1}(:,5));
    plot(xtotalAreaRealShared,yAveragePercentageShared,'bo')
    title(nameTitleGraphic)
    xlabel('totalAreaRealShared')
    ylabel('AveragePercentageShared')
    nameGraphicAveragePercentageShared=[outputDir 'graphicSharedInfoAveragePercentageSharedBetween' sprintf('%d',numLayer) 'And' sprintf('%d',numLayer+1) '.jpg'];
    saveas(graphicSharedInfoAveragePercentageShared,nameGraphicAveragePercentageShared);
    
    
    clear  cellsSharedByLayers basicInfoLayer id
end

save('basicSharedByLayer2.mat','infoSharedLayers');

infoSharedLayers12=vertcat(infoSharedLayers{1,1});
infoSharedLayers12=array2table(infoSharedLayers12);
infoSharedLayers12.Properties.VariableNames={'ID', 'numNeighboursLayer2', 'totalAreaRealShared', 'AverageAreaRealShared', 'AveragePercentageShared'};

infoSharedLayers23=vertcat(infoSharedLayers{2,1});
infoSharedLayers23=array2table(infoSharedLayers23);
infoSharedLayers23.Properties.VariableNames={'ID', 'numNeighboursLayer3', 'totalAreaRealShared', 'AverageAreaRealShared', 'AveragePercentageShared'};


writetable(infoSharedLayers12, 'sample2.xlsx', 'Sheet','infoSharedLayers12');
writetable(infoSharedLayers23, 'sample2.xlsx', 'Sheet','infoSharedLayers23');

