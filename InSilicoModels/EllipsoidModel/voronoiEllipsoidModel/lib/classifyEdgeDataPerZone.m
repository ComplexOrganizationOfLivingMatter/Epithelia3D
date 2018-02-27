function [outerSurfaceDataTransition,outerSurfaceDataNoTransition]=classifyEdgeDataPerZone(uniquePairOfNeighsOuterSurface,outerSurfaceTotalData,indexesEdgesTransition,indexesEdgesNoTransition,numCells, numUniqueScutoid,region)   

    for i=1:size(indexesEdgesTransition,2)
        
        if ~sum(indexesEdgesTransition(:,i))==0
        
            outerSurfaceDataTransition(:,i).(['numCellsInRegion' region])=numCells(i);
            %define transition edge length, angle and vertices
            outerSurfaceDataTransition(:,i).edgeLength=cat(1,outerSurfaceTotalData(indexesEdgesTransition(:,i)).edgeLength);
            outerSurfaceDataTransition(:,i).edgeAngle=abs(cat(1,outerSurfaceTotalData(indexesEdgesTransition(:,i)).edgeAngle));
            outerSurfaceDataTransition(:,i).edgeVertices=cat(1,{outerSurfaceTotalData(indexesEdgesTransition(:,i)).edgeVertices});
            
            %outerSurfaceDataTransition
            outerSurfaceDataTransition(:,i).cellularMotifs=uniquePairOfNeighsOuterSurface(indexesEdgesTransition(:,i),:);
            outerSurfaceDataTransition(:,i).(['numOfScutoids' region])=numUniqueScutoid(i);
            outerSurfaceDataTransition(:,i).(['numOfScutoids' region])=numUniqueScutoid(i) / numCells(i);
            outerSurfaceDataTransition(:,i).(['numOfEdges' region])=size(outerSurfaceDataTransition(:,i).edgeAngle,1);
            outerSurfaceDataTransition(:,i).(['numOfEdgesPerCell' region])=outerSurfaceDataTransition(:,i).(['numOfEdges' region])/numCells(i);
            
            outerSurfaceDataTransition(:,i).(['proportionAnglesLess15deg' region])=sum([outerSurfaceDataTransition(:,i).edgeAngle]<=15)/outerSurfaceDataTransition(:,i).(['numOfEdges' region]);
            outerSurfaceDataTransition(:,i).(['proportionAnglesBetween15_30deg' region])=sum([outerSurfaceDataTransition(:,i).edgeAngle]>15 & [outerSurfaceDataTransition(:,i).edgeAngle] <= 30)/outerSurfaceDataTransition(:,i).(['numOfEdges' region]);
            outerSurfaceDataTransition(:,i).(['proportionAnglesBetween30_45deg' region])=sum([outerSurfaceDataTransition(:,i).edgeAngle]>30 & [outerSurfaceDataTransition(:,i).edgeAngle] <= 45)/outerSurfaceDataTransition(:,i).(['numOfEdges' region]);
            outerSurfaceDataTransition(:,i).(['proportionAnglesBetween45_60deg' region])=sum([outerSurfaceDataTransition(:,i).edgeAngle]>45 & [outerSurfaceDataTransition(:,i).edgeAngle] <= 60)/outerSurfaceDataTransition(:,i).(['numOfEdges' region]);
            outerSurfaceDataTransition(:,i).(['proportionAnglesBetween60_75deg' region])=sum([outerSurfaceDataTransition(:,i).edgeAngle]>60 & [outerSurfaceDataTransition(:,i).edgeAngle] <= 75)/outerSurfaceDataTransition(:,i).(['numOfEdges' region]);
            outerSurfaceDataTransition(:,i).(['proportionAnglesBetween75_90deg' region])=sum([outerSurfaceDataTransition(:,i).edgeAngle]>75 & [outerSurfaceDataTransition(:,i).edgeAngle] <= 90)/outerSurfaceDataTransition(:,i).(['numOfEdges' region]);
            
            
            
            
            
        else
            outerSurfaceDataTransition(:,i).(['numCellsInRegion' region])=numCells(i);
            outerSurfaceDataTransition(:,i).edgeLength=NaN;
            outerSurfaceDataTransition(:,i).edgeAngle=NaN;
            outerSurfaceDataTransition(:,i).edgeVertices=NaN;
            outerSurfaceDataTransition(:,i).cellularMotifs=NaN;
            outerSurfaceDataTransition(:,i).(['numOfScutoids' region])=numUniqueScutoid(i);
            outerSurfaceDataTransition(:,i).(['numOfScutoids' region])=numUniqueScutoid(i) / numCells(i);
            outerSurfaceDataTransition(:,i).(['numOfEdges' region])=NaN;
            outerSurfaceDataTransition(:,i).(['numOfEdgesPerCell' region])=NaN;
            outerSurfaceDataTransition(:,i).(['proportionAnglesLess15deg' region])=NaN;
            outerSurfaceDataTransition(:,i).(['proportionAnglesBetween15_30deg' region])=NaN;
            outerSurfaceDataTransition(:,i).(['proportionAnglesBetween30_45deg' region])=NaN;
            outerSurfaceDataTransition(:,i).(['proportionAnglesBetween45_60deg' region])=NaN;
            outerSurfaceDataTransition(:,i).(['proportionAnglesBetween60_75deg' region])=NaN;
            outerSurfaceDataTransition(:,i).(['proportionAnglesBetween75_90deg' region])=NaN;
            
            
        end

        %numCells
        outerSurfaceDataNoTransition(:,i).(['numCellsInRegion' region])=numCells(i);
        
        %define no transition edge length, angle and vertices
        outerSurfaceDataNoTransition(:,i).edgeLength=cat(1,outerSurfaceTotalData(indexesEdgesNoTransition(:,i)).edgeLength);
        outerSurfaceDataNoTransition(:,i).edgeAngle=abs(cat(1,outerSurfaceTotalData(indexesEdgesNoTransition(:,i)).edgeAngle));
        outerSurfaceDataNoTransition(:,i).edgeVertices=cat(1,{outerSurfaceTotalData(indexesEdgesNoTransition(:,i)).edgeVertices});


        %outerSurfaceDataNoTransition
        outerSurfaceDataNoTransition(:,i).cellularMotifs=uniquePairOfNeighsOuterSurface(indexesEdgesNoTransition(:,i),:);
        outerSurfaceDataNoTransition(:,i).(['numOfEdges' region])=size(outerSurfaceDataNoTransition(:,i).edgeAngle,1);
        outerSurfaceDataNoTransition(:,i).(['numOfEdgesPerCell' region])=outerSurfaceDataNoTransition(:,i).(['numOfEdges' region])/numCells(i);
        %angles
        outerSurfaceDataNoTransition(:,i).(['proportionAnglesLess15deg' region])=sum([outerSurfaceDataNoTransition(:,i).edgeAngle]<=15)/outerSurfaceDataNoTransition(:,i).(['numOfEdges' region]);
        outerSurfaceDataNoTransition(:,i).(['proportionAnglesBetween15_30deg' region])=sum([outerSurfaceDataNoTransition(:,i).edgeAngle]>15 & [outerSurfaceDataNoTransition(:,i).edgeAngle] <= 30)/outerSurfaceDataNoTransition(:,i).(['numOfEdges' region]);
        outerSurfaceDataNoTransition(:,i).(['proportionAnglesBetween30_45deg' region])=sum([outerSurfaceDataNoTransition(:,i).edgeAngle]>30 & [outerSurfaceDataNoTransition(:,i).edgeAngle] <= 45)/outerSurfaceDataNoTransition(:,i).(['numOfEdges' region]);
        outerSurfaceDataNoTransition(:,i).(['proportionAnglesBetween45_60deg' region])=sum([outerSurfaceDataNoTransition(:,i).edgeAngle]>45 & [outerSurfaceDataNoTransition(:,i).edgeAngle] <= 60)/outerSurfaceDataNoTransition(:,i).(['numOfEdges' region]);
        outerSurfaceDataNoTransition(:,i).(['proportionAnglesBetween60_75deg' region])=sum([outerSurfaceDataNoTransition(:,i).edgeAngle]>60 & [outerSurfaceDataNoTransition(:,i).edgeAngle] <= 75)/outerSurfaceDataNoTransition(:,i).(['numOfEdges' region]);
        outerSurfaceDataNoTransition(:,i).(['proportionAnglesBetween75_90deg' region])=sum([outerSurfaceDataNoTransition(:,i).edgeAngle]>75 & [outerSurfaceDataNoTransition(:,i).edgeAngle] <= 90)/outerSurfaceDataNoTransition(:,i).(['numOfEdges' region]);
        
    end


end

