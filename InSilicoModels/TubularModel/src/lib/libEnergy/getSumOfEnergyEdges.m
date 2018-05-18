function sumEdgesOfEnergy = getSumOfEnergyEdges(lengthCentralEdge,verticesCell_1_2,verticesCell_3,verticesCell_4,verticesTotal,borderCells,verticesBorderLeft,verticesBorderRight,fourCellsMotif,W,numberOfCellsTrasversalSection)


        indexVertEdge1=ismember(verticesCell_3(:,1),verticesCell_1_2(:,:));
        indexVertEdge2=ismember(verticesCell_4(:,1),verticesCell_1_2(:,:));
        
        %vertices of edge
        vertEdge1=verticesTotal.verticesPerCell{verticesCell_3(indexVertEdge1)};
        vertEdge2=verticesTotal.verticesPerCell{verticesCell_4(indexVertEdge2)};

        %vertices neighbouring the edge vertices
        vertsNeighEdge1=vertcat(verticesTotal.verticesPerCell{verticesCell_3(~indexVertEdge1)});
        vertsNeighEdge2=vertcat(verticesTotal.verticesPerCell{verticesCell_4(~indexVertEdge2)});
   
        edge1=[vertEdge1;vertsNeighEdge1(1,:)];
        edge2=[vertEdge1;vertsNeighEdge1(2,:)];
        edge3=[vertEdge2;vertsNeighEdge2(1,:)];
        edge4=[vertEdge2;vertsNeighEdge2(2,:)];
        
        
        [length1,~]=edgeLengthAnglesCalculation(edge1,borderCells,verticesBorderLeft,verticesBorderRight,verticesTotal,fourCellsMotif,W,numberOfCellsTrasversalSection);
        [length2,~]=edgeLengthAnglesCalculation(edge2,borderCells,verticesBorderLeft,verticesBorderRight,verticesTotal,fourCellsMotif,W,numberOfCellsTrasversalSection);
        [length3,~]=edgeLengthAnglesCalculation(edge3,borderCells,verticesBorderLeft,verticesBorderRight,verticesTotal,fourCellsMotif,W,numberOfCellsTrasversalSection);
        [length4,~]=edgeLengthAnglesCalculation(edge4,borderCells,verticesBorderLeft,verticesBorderRight,verticesTotal,fourCellsMotif,W,numberOfCellsTrasversalSection);       
       
        sumEdgesOfEnergy=lengthCentralEdge+length1+length2+length3+length4;
  
end
        