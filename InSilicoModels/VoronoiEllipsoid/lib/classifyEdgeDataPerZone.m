function [outerSurfaceDataTransition,outerSurfaceDataNoTransition]=classifyEdgeDataPerZone(uniquePairOfNeighsOuterSurface,outerSurfaceTotalData,indexesEdgesTransition,indexesEdgesNoTransition,numCells)  

  

    for i=1:size(indexesEdgesTransition,2)
        
        if ~sum(indexesEdgesTransition(:,i))==0
        
            %define transition edge length, angle and vertices
            outerSurfaceDataTransition(:,i).edgeLength=cat(1,outerSurfaceTotalData(indexesEdgesTransition(:,i)).edgeLength);
            outerSurfaceDataTransition(:,i).edgeAngle=abs(cat(1,outerSurfaceTotalData(indexesEdgesTransition(:,i)).edgeAngle));
            outerSurfaceDataTransition(:,i).edgeVertices=cat(1,{outerSurfaceTotalData(indexesEdgesTransition(:,i)).edgeVertices});
            
            %outerSurfaceDataTransition
            outerSurfaceDataTransition(:,i).cellularMotifs=uniquePairOfNeighsOuterSurface(indexesEdgesTransition(:,i),:);
            outerSurfaceDataTransition(:,i).numOfEdges=size(outerSurfaceDataTransition(:,i).edgeAngle,1);
            outerSurfaceDataTransition(:,i).numOfEdgesPerCell=outerSurfaceDataTransition(:,i).numOfEdges/numCells(i);
            
            outerSurfaceDataTransition(:,i).proportionAnglesLess15deg=sum([outerSurfaceDataTransition(:,i).edgeAngle]<=15)/outerSurfaceDataTransition(:,i).numOfEdges;
            outerSurfaceDataTransition(:,i).proportionAnglesBetween15_30deg=sum([outerSurfaceDataTransition(:,i).edgeAngle]>15 & [outerSurfaceDataTransition(:,i).edgeAngle] <= 30)/outerSurfaceDataTransition(:,i).numOfEdges;
            outerSurfaceDataTransition(:,i).proportionAnglesBetween30_45deg=sum([outerSurfaceDataTransition(:,i).edgeAngle]>30 & [outerSurfaceDataTransition(:,i).edgeAngle] <= 45)/outerSurfaceDataTransition(:,i).numOfEdges;
            outerSurfaceDataTransition(:,i).proportionAnglesBetween45_60deg=sum([outerSurfaceDataTransition(:,i).edgeAngle]>45 & [outerSurfaceDataTransition(:,i).edgeAngle] <= 60)/outerSurfaceDataTransition(:,i).numOfEdges;
            outerSurfaceDataTransition(:,i).proportionAnglesBetween60_75deg=sum([outerSurfaceDataTransition(:,i).edgeAngle]>60 & [outerSurfaceDataTransition(:,i).edgeAngle] <= 75)/outerSurfaceDataTransition(:,i).numOfEdges;
            outerSurfaceDataTransition(:,i).proportionAnglesBetween75_90deg=sum([outerSurfaceDataTransition(:,i).edgeAngle]>75 & [outerSurfaceDataTransition(:,i).edgeAngle] <= 90)/outerSurfaceDataTransition(:,i).numOfEdges;
            
            
            outerSurfaceDataTransition(:,i).numCellsInRegion=numCells(i);
            
            
        else
            outerSurfaceDataTransition(:,i).edgeLength=[];
            outerSurfaceDataTransition(:,i).edgeAngle=[];
            outerSurfaceDataTransition(:,i).edgeVertices=[];
            outerSurfaceDataTransition(:,i).cellularMotifs=[];
            outerSurfaceDataTransition(:,i).numOfEdges=[];
            outerSurfaceDataTransition(:,i).numOfEdgesPerCell=[];
            outerSurfaceDataTransition(:,i).proportionAnglesLess15deg=[];
            outerSurfaceDataTransition(:,i).proportionAnglesBetween15_30deg=[];
            outerSurfaceDataTransition(:,i).proportionAnglesBetween30_45deg=[];
            outerSurfaceDataTransition(:,i).proportionAnglesBetween45_60deg=[];
            outerSurfaceDataTransition(:,i).proportionAnglesBetween60_75deg=[];
            outerSurfaceDataTransition(:,i).proportionAnglesBetween75_90deg=[];
            outerSurfaceDataTransition(:,i).numCellsInRegion=numCells(i);
            
        end

        %define no transition edge length, angle and vertices
        outerSurfaceDataNoTransition(:,i).edgeLength=cat(1,outerSurfaceTotalData(indexesEdgesNoTransition(:,i)).edgeLength);
        outerSurfaceDataNoTransition(:,i).edgeAngle=abs(cat(1,outerSurfaceTotalData(indexesEdgesNoTransition(:,i)).edgeAngle));
        outerSurfaceDataNoTransition(:,i).edgeVertices=cat(1,{outerSurfaceTotalData(indexesEdgesNoTransition(:,i)).edgeVertices});


        %outerSurfaceDataNoTransition
        outerSurfaceDataNoTransition(:,i).cellularMotifs=uniquePairOfNeighsOuterSurface(indexesEdgesNoTransition(:,i),:);
        outerSurfaceDataNoTransition(:,i).numOfEdges=size(outerSurfaceDataNoTransition(:,i).edgeAngle,1);
        outerSurfaceDataNoTransition(:,i).numOfEdgesPerCell=outerSurfaceDataNoTransition(:,i).numOfEdges/numCells(i);
        %angles
        outerSurfaceDataNoTransition(:,i).proportionAnglesLess15deg=sum([outerSurfaceDataNoTransition(:,i).edgeAngle]<=15)/outerSurfaceDataNoTransition(:,i).numOfEdges;
        outerSurfaceDataNoTransition(:,i).proportionAnglesBetween15_30deg=sum([outerSurfaceDataNoTransition(:,i).edgeAngle]>15 & [outerSurfaceDataNoTransition(:,i).edgeAngle] <= 30)/outerSurfaceDataNoTransition(:,i).numOfEdges;
        outerSurfaceDataNoTransition(:,i).proportionAnglesBetween30_45deg=sum([outerSurfaceDataNoTransition(:,i).edgeAngle]>30 & [outerSurfaceDataNoTransition(:,i).edgeAngle] <= 45)/outerSurfaceDataNoTransition(:,i).numOfEdges;
        outerSurfaceDataNoTransition(:,i).proportionAnglesBetween45_60deg=sum([outerSurfaceDataNoTransition(:,i).edgeAngle]>45 & [outerSurfaceDataNoTransition(:,i).edgeAngle] <= 60)/outerSurfaceDataNoTransition(:,i).numOfEdges;
        outerSurfaceDataNoTransition(:,i).proportionAnglesBetween60_75deg=sum([outerSurfaceDataNoTransition(:,i).edgeAngle]>60 & [outerSurfaceDataNoTransition(:,i).edgeAngle] <= 75)/outerSurfaceDataNoTransition(:,i).numOfEdges;
        outerSurfaceDataNoTransition(:,i).proportionAnglesBetween75_90deg=sum([outerSurfaceDataNoTransition(:,i).edgeAngle]>75 & [outerSurfaceDataNoTransition(:,i).edgeAngle] <= 90)/outerSurfaceDataNoTransition(:,i).numOfEdges;
        %numCells
        outerSurfaceDataNoTransition(:,i).numCellsInRegion=numCells(i);
    end


end

