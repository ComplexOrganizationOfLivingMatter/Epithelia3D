load('neighbours_layer_filter2.mat')

neighs_real=table2array(neigh_real);
basicInfos=table2array(basicInfo);
basicInfos=cell2mat(basicInfos);

% Loop to obtain the information and thus be able to make the graphs of the basic information
% acum=0;
% acum1=1;
% for numLayer=1:max(basicInfos(:,5))
%     for numCell=1:size(basicInfos,1)
%         if basicInfos(numCell,5)==numLayer
%             acum=acum+1;
%             Neigh{numLayer,1}(acum1,1)=basicInfos(numCell,2);%+sumNeigh;
%             Area{numLayer,1}(acum1,1)=basicInfos(numCell,3);%+sumArea;
%             Volumen{numLayer,1}(acum1,1)=basicInfos(numCell,4);%+sumVolumen;
%             acum1=acum1+1;
%         end
%     end
%     numCentroidByLayer(numLayer,1)=acum;
%     numNeighByLayer(numLayer,1)=mean(vertcat(Neigh{numLayer,1}(:,1)));
%     stdNumNeighByLayer(numLayer,1)=std(vertcat(Neigh{numLayer,1}(:,1)));
%     areaByLayer(numLayer,1)=mean(vertcat(Area{numLayer,1}(:,1)));
%     stdAreaByLayer(numLayer,1)=std(vertcat(Area{numLayer,1}(:,1)));
%     volumenByLayer(numLayer,1)=mean(vertcat(Volumen{numLayer,1}(:,1)));
%     stdVolumenByLayer(numLayer,1)=std(vertcat(Volumen{numLayer,1}(:,1)));
% 
%     acum=0;
%     acum1=1;
% end
% 
% 
% graphicBasicInfo=figure;
% xNumLayer= 1:max(basicInfos(:,5))-1;
% 
% yNumCellByLayer = numCentroidByLayer(xNumLayer,1);
% subplot(2,2,1), bar(xNumLayer,yNumCellByLayer), title('numCellByLayer')
% 
% yAreaByLayer=areaByLayer(xNumLayer,1);
% subplot(2,2,2), bar(xNumLayer,yAreaByLayer), title('AverageAreaByLayer')
% 
% yVolumenByLayer=volumenByLayer(xNumLayer,1);
% subplot(2,2,3), bar(xNumLayer,yVolumenByLayer), title('AverageVolumenByLayer')
% 
% yNumNeighByLayer=numNeighByLayer(xNumLayer,1);
% subplot(2,2,4), bar(xNumLayer,yNumNeighByLayer), title('AverageNumNeighByLayer')
% 
% saveas(graphicBasicInfo,'graphicBasicInfo.jpg');



% Loop to obtain the information and thus be able to make the graphs of the information shared between layers

%Start by analyzing the shared data between layer 1 and layer 2.
acum=1;
acum1=1;
%Podria ponerse aquí dos bucle modificando capa actual y capa venica a
%analizar del buble de abajo "Proyecto futuro si estuviera bien hasta ahora"
for numCell=1:size(basicInfos)
    if basicInfos(numCell,5)==2 %SE HA QUITADO EL 1
        basicInfoLayer1(acum1,:)=basicInfos(numCell,:);
        acum1=acum1+1;
        for numTrack=1:size(neighs_real,1)
            if neighs_real(numTrack,1)==basicInfos(numCell,1) && neighs_real(numTrack,5)==3 %SE HA QUITADO EL 2
                layers12(acum,:)=neighs_real(numTrack,:);
                acum=acum+1;
            end
        end
    end 
end

acum=1;
id=unique(layers12(:,1),'rows');
for numIds=1:size(id,1)
    for numTrack12=1:size(layers12,1)
        if layers12(numTrack12,1)==id(numIds,1)
            numNeigh12(numIds,1)=acum;
            areaRealShared{numIds,1}(acum,1)=layers12(numTrack12,6);
            percentageShared{numIds,1}(acum,1)=layers12(numTrack12,4);
            acum=acum+1;
        end
    end
    
    averageAreaRealShared(numIds,1)=mean(vertcat(areaRealShared{numIds,1}(:,1)));
    averagePercentageShared(numIds,1)=mean(vertcat(percentageShared{numIds,1}(:,1)));
    
    for numCellLayer1=1:size(basicInfoLayer1,1)
        if basicInfoLayer1(numCellLayer1,1)==id(numIds,1)
            arealayer1(numIds,1)=basicInfoLayer1(numCellLayer1,3);
        end
    end
    acum=1;
end

infoSharedLayers12(:,1)=id(:,1);
infoSharedLayers12(:,2)=numNeigh12(:,1);
infoSharedLayers12(:,3)=arealayer1(:,1);
infoSharedLayers12(:,4)=averageAreaRealShared(:,1);
infoSharedLayers12(:,5)=averagePercentageShared(:,1);




xArea=infoSharedLayers12(:,3);

graphicSharedInfoNumNeigh12=figure;
yNumNeigh12 = infoSharedLayers12(:,2);
plot(xArea, yNumNeigh12,'bo')
xlabel('Area')
ylabel('NumNeighBetweenLayers23')%SE HA MODIFICADO
saveas(graphicSharedInfoNumNeigh12,'graphicSharedInfoNumNeigh23.jpg'); %SE HA MODIFICADO

graphicSharedInfoAverageRealShared=figure;
yAverageRealShared=infoSharedLayers12(:,4);
plot(xArea,yAverageRealShared,'bo')
xlabel('Area')
ylabel('AverageRealSharedBetweenLayers23')%SE HA MODIFICADO
saveas(graphicSharedInfoAverageRealShared,'graphicSharedInfoAverageRealShared23.jpg');%SE HA MODIFICADO

graphicSharedInfoAveragePercentageShared=figure;
yAveragePercentageShared=infoSharedLayers12(:,5);
plot(xArea,yAveragePercentageShared,'bo')
xlabel('Area')
ylabel('AveragePercentageSharedBetweenLayers23')%SE HA MODIFICADO

saveas(graphicSharedInfoAveragePercentageShared,'graphicSharedInfoAveragePercentageShared23.jpg');%SE HA MODIFICADO




