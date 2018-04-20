function [edgeLength, edgeAngle] = edgeLengthAnglesCalculation(vertsEdge,borderCells,verticesBorderLeft,verticesBorderRight,verticesTotal,fourCellMotif,W)

    indexCellsEdge=ismember(vertcat(verticesTotal.verticesPerCell{:}),vertsEdge,'rows');
    CellsEdge=verticesTotal.verticesConnectCells(indexCellsEdge,:);
    cellsEdge=intersect(CellsEdge(1,:),CellsEdge(2,:));
    cellsToStudy=intersect(cellsEdge,fourCellMotif);
    
    indexBorderCells=ismember(cellsToStudy,borderCells);
    indexVertexBorderLeft=ismember(vertsEdge,vertcat(verticesBorderLeft{:}),'rows');
    indexVertexBorderRight=ismember(vertsEdge,vertcat(verticesBorderRight{:}),'rows');
        
    if sum(indexVertexBorderLeft)==1 && sum(indexVertexBorderRight)==1 && sum(indexBorderCells)>=1
        vertsEdge(indexVertexBorderLeft,2)=vertsEdge(indexVertexBorderLeft,2)+W;
    end
      
    
%       plot(vertsEdge(:,2),vertsEdge(:,1))
    
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
