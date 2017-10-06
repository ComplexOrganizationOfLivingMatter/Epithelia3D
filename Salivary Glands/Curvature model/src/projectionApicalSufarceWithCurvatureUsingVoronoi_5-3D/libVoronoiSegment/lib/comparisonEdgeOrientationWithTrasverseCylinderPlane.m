function [edgeLength, edgeAngle] = comparisonEdgeOrientationWithTrasverseCylinderPlane( vertsEdge)


    directorEdgeVector=vertsEdge(2,:)-vertsEdge(1,:);

    %fixing z direction to 0
    directorVectorInTrasversePlane= [directorEdgeVector(1:2),0];
    
    %Calculate angle between vectors. 
    edgeAngle =rad2deg(atan2(norm(cross(directorVectorInTrasversePlane,directorEdgeVector)),dot(directorVectorInTrasversePlane,directorEdgeVector)));
    edgeLength = pdist2(vertsEdge(1, :), vertsEdge(2, :));
    if edgeAngle>90
        edgeAngle=180-edgeAngle;
    end
    
end

