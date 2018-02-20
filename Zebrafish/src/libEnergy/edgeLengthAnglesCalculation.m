function [edgeLength, edgeAngle] = edgeLengthAnglesCalculation(vertsEdge)

    
%     if abs(vertsEdge(2,2)-vertsEdge(1,2)) > W/2
%         [~,index]=min(vertsEdge(:,2));
%         vertsEdge(index,2)=vertsEdge(index,2)+W;
%     end
%     
    
%     plot(vertsEdge(:,2),vertsEdge(:,1))
    
    directorEdgeVector=[vertsEdge(2,:)-vertsEdge(1,:),0];   
    %fixing axis X as director vector (axis X = columns)
    directorVectorInTrasverseAxis= [0,1,0];
    
    %Calculate angle between vectors. 
    edgeAngle =rad2deg(atan2(norm(cross(directorVectorInTrasverseAxis,directorEdgeVector)),dot(directorVectorInTrasverseAxis,directorEdgeVector)));
    edgeLength = pdist2(vertsEdge(1, :), vertsEdge(2, :));
    if edgeAngle>90
        edgeAngle=180-edgeAngle;
    end
    
end
