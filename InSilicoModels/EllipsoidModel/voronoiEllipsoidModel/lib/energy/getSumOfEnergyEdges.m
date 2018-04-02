function sumEdgesOfEnergy = getSumOfEnergyEdges(verticesCell_1_2,verticesCell_3,verticesCell_4,verticesTotal)


        indexVertEdge1=ismember(verticesCell_3(:,1),verticesCell_1_2(:,:));
        indexVertEdge2=ismember(verticesCell_4(:,1),verticesCell_1_2(:,:));
        
        %vertices of edge
        vertEdge1=verticesTotal.verticesPerCell{verticesCell_3(indexVertEdge1)};
        vertEdge2=verticesTotal.verticesPerCell{verticesCell_4(indexVertEdge2)};

        %vertices neighbouring the edge vertices
        vertsNeighEdge1=vertcat(verticesTotal.verticesPerCell{verticesCell_3(~indexVertEdge1)});
        vertsNeighEdge2=vertcat(verticesTotal.verticesPerCell{verticesCell_4(~indexVertEdge2)});
           
        %distance between edge vertices and its neighbours
        distVertEdge1 = pdist2(vertEdge1,vertsNeighEdge1);
        distVertEdge2 = pdist2(vertEdge2,vertsNeighEdge2);
        
        sumEdgesOfEnergy=sum([distVertEdge1,distVertEdge2]);
end
        