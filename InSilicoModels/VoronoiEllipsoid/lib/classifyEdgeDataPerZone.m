function [outerSurfaceDataTransition,outerSurfaceDataNoTransition]=classifyEdgeDataPerZone(outerEllipsoidInfo,outerSurfaceTotalData,indexesEdgesTransition,indexesEdgesNoTransition,numCells)  

    for i=1:size(indexesEdgesTransition,2)
        %define transition edge length, angle and vertices
        outerSurfaceDataTransition(:,i).edgeLength=cat(1,outerSurfaceTotalData(indexesEdgesTransition(:,i)).edgeLength);
        outerSurfaceDataTransition(:,i).edgeAngle=abs(cat(1,outerSurfaceTotalData(indexesEdgesTransition(:,i)).edgeAngle));
        outerSurfaceDataTransition(:,i).edgeVertices=cat(1,{outerSurfaceTotalData(indexesEdgesTransition(:,i)).edgeVertices});

        %define no transition edge length, angle and vertices
        outerSurfaceDataNoTransition(:,i).edgeLength=cat(1,outerSurfaceTotalData(indexesEdgesNoTransition(:,i)).edgeLength);
        outerSurfaceDataNoTransition(:,i).edgeAngle=abs(cat(1,outerSurfaceTotalData(indexesEdgesNoTransition(:,i)).edgeAngle));
        outerSurfaceDataNoTransition(:,i).edgeVertices=cat(1,{outerSurfaceTotalData(indexesEdgesNoTransition(:,i)).edgeVertices});

        %outerSurfaceDataTransition
        outerSurfaceDataTransition(:,i).cellularMotifs=outerEllipsoidInfo(indexesEdgesTransition(:,i)).neighbourhood;
        outerSurfaceDataTransition(:,i).numOfEdges=size(outerSurfaceDataTransition.edgeAngle,1);
        outerSurfaceDataTransition(:,i).numOfEdgesPerCell=outerSurfaceDataTransition(:,i).numOfEdges/numCells;
        if size(outerSurfaceDataTransition.edgeAngle,1)>0
            outerSurfaceDataTransition(:,i).proportionAnglesLess15deg=sum(anglesTransition<=15)/length(outerSurfaceDataTransition.numOfEdges);
            outerSurfaceDataTransition(:,i).proportionAnglesBetween15_30deg=sum(anglesTransition>15 & anglesTransition <= 30)/length(outerSurfaceDataTransition.numOfEdges);
            outerSurfaceDataTransition(:,i).proportionAnglesBetween30_45deg=sum(anglesTransition>30 & anglesTransition <= 45)/length(outerSurfaceDataTransition.numOfEdges);
            outerSurfaceDataTransition(:,i).proportionAnglesBetween45_60deg=sum(anglesTransition>45 & anglesTransition <= 60)/length(outerSurfaceDataTransition.numOfEdges);
            outerSurfaceDataTransition(:,i).proportionAnglesBetween60_75deg=sum(anglesTransition>60 & anglesTransition <= 75)/length(outerSurfaceDataTransition.numOfEdges);
            outerSurfaceDataTransition(:,i).proportionAnglesBetween75_90deg=sum(anglesTransition>75 & anglesTransition <= 90)/length(outerSurfaceDataTransition.numOfEdges);
        end
        %outerSurfaceDataNoTransition
        outerSurfaceDataNoTransition(:,i).cellularMotifs=outerEllipsoidInfo(indexesEdgesNoTransition(:,i)).neighbourhood;
        outerSurfaceDataNoTransition(:,i).numOfEdges=size(outerSurfaceDataNoTransition.edgeAngle,1);
        outerSurfaceDataNoTransition(:,i).numOfEdgesPerCell=outerSurfaceDataNoTransition(:,i).numOfEdges/numCells;
        outerSurfaceDataNoTransition(:,i).proportionAnglesLess15deg=sum(anglesNoTransition<=15)/length(outerSurfaceDataNoTransition.numOfEdges);
        outerSurfaceDataNoTransition(:,i).proportionAnglesBetween15_30deg=sum(anglesNoTransition>15 & anglesNoTransition <= 30)/length(outerSurfaceDataNoTransition.numOfEdges);
        outerSurfaceDataNoTransition(:,i).proportionAnglesBetween30_45deg=sum(anglesNoTransition>30 & anglesNoTransition <= 45)/length(outerSurfaceDataNoTransition.numOfEdges);
        outerSurfaceDataNoTransition(:,i).proportionAnglesBetween45_60deg=sum(anglesNoTransition>45 & anglesNoTransition <= 60)/length(outerSurfaceDataNoTransition.numOfEdges);
        outerSurfaceDataNoTransition(:,i).proportionAnglesBetween60_75deg=sum(anglesNoTransition>60 & anglesNoTransition <= 75)/length(outerSurfaceDataNoTransition.numOfEdges);
        outerSurfaceDataNoTransition(:,i).proportionAnglesBetween75_90deg=sum(anglesNoTransition>75 & anglesNoTransition <= 90)/length(outerSurfaceDataNoTransition.numOfEdges);
    end 


end

