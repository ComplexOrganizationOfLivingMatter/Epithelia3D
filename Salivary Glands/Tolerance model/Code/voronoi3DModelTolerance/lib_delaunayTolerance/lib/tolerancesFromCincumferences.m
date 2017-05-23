function [tripletsData]=tolerancesFromCincumferences(tripletsData)


%% This was the first method implemented using concentric circunferences from triangles
%     tolerances={};
%     for i=1:size(tripletsData,1)
%         xy1=tripletsData(i).first_node_XY;
%         xy2=tripletsData(i).second_node_XY;
%         xy3=tripletsData(i).third_node_XY;
%         nodeSquare1=tripletsData(i).CoordNode1ToSquare;
%         nodeSquare2=tripletsData(i).CoordNode2ToSquare;
%         nodeSquare3=tripletsData(i).CoordNode3ToSquare;
%         %trriangulation
%         tri_aux=delaunayTriangulation([xy1(1);xy2(1);xy3(1)],[xy1(2);xy2(2);xy3(2)]);
%         %get center and ratio from circunscrited circumference
%         [circentXY,ratioCir]=circumcenter(tri_aux);
%         
%         listTolerances=squareform( pdist([circentXY;nodeSquare1;nodeSquare2;nodeSquare3]));
%         listTolerances=listTolerances(1,2:end)-ratioCir;
%         tolerances{i,1}=listTolerances;
%     end

    toleranceTriangles=cell(size(tripletsData,1),1);
    toleranceFirstEdge=cell(size(tripletsData,1),1);
    toleranceSecondEdge=cell(size(tripletsData,1),1);
    toleranceThirdEdge=cell(size(tripletsData,1),1);
    
    for i=1:size(tripletsData,1)
        
        distanceBetweenFirstEdge=tripletsData(i).distanceFirstEdge;
        distanceBetweenSecondEdge=tripletsData(i).distanceSecondEdge;         
        distanceBetweenThirdEdge=tripletsData(i).distanceThirdEdge;
        firstNodeXY=tripletsData(i).first_node_XY;
        secondNodeXY=tripletsData(i).second_node_XY;
        thirdNodeXY=tripletsData(i).third_node_XY;
        neighFirstEdgeCoord=tripletsData(i).CoordNode1ToSquare;
        neighSecondEdgeCoord=tripletsData(i).CoordNode2ToSquare;
        neighThirdEdgeCoord=tripletsData(i).CoordNode3ToSquare;
        
        distThirdNodeToNeighFirstEdge=pdist([thirdNodeXY;neighFirstEdgeCoord]);
        distSecondNodeToNeighSecondEdge=pdist([secondNodeXY;neighSecondEdgeCoord]);
        distFirstNodeToNeighThirdEdge=pdist([firstNodeXY;neighThirdEdgeCoord]);
        
        %Tolerance edges % triangle calculation
        toleranceFirstEdge{i,1}=abs(distThirdNodeToNeighFirstEdge-distanceBetweenFirstEdge)/2;
        toleranceSecondEdge{i,1}=abs(distSecondNodeToNeighSecondEdge-distanceBetweenSecondEdge)/2;
        toleranceThirdEdge{i,1}=abs(distFirstNodeToNeighThirdEdge-distanceBetweenThirdEdge)/2;

        toleranceTriangles{i,1}=min([toleranceFirstEdge{i,1},toleranceSecondEdge{i,1},toleranceThirdEdge{i,1}]);
        
        
    end
    
    [tripletsData.ToleranceFirstEdge]=toleranceFirstEdge{:,1};
    [tripletsData.ToleranceSecondEdge]=toleranceSecondEdge{:,1};
    [tripletsData.ToleranceThirdEdge]=toleranceThirdEdge{:,1};
    [tripletsData.ToleranceTriangle]=toleranceTriangles{:,1};

end

