function [ edgeLength, edgeAngle ] = comparisonEdgeOrietationWithMeridianOfEllipsoidGrid( verGrid, vertEdge,outerEllipsoidInfo)


        distVert=pdist2(vertEdge(1,:),verGrid);
        [~,gridVertIndex]=min(distVert);

        if mod(gridVertIndex,outerEllipsoidInfo.resolutionEllipse+1)==0
            indexSuperiorVertex=gridVertIndex-1;
        else
            indexSuperiorVertex=gridVertIndex+1;
        end

        directorMeridianVector= verGrid(indexSuperiorVertex,:)-verGrid(gridVertIndex,:);
        directorEdgeTransitionVector=vertEdge(2,:)-vertEdge(1,:);

        %Calculate angle between vectors
        edgeAngle =rad2deg(atan2(norm(cross(directorMeridianVector,directorEdgeTransitionVector)),dot(directorMeridianVector,directorEdgeTransitionVector)));
        edgeLength = pdist2(vertEdge(1, :), vertEdge(2, :));
        if edgeAngle>90
            edgeAngle=180-edgeAngle;
        end


end

