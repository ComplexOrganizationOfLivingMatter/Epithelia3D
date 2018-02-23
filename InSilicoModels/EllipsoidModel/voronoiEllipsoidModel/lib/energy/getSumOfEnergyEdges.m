function sumEdgesOfEnergy = getSumOfEnergyEdges(verticesCell_1_2,verticesCell_3,verticesCell_4,verticesTotal,W)


        indexVertEdge1=ismember(verticesCell_3(:,1),verticesCell_1_2(:,:));
        indexVertEdge2=ismember(verticesCell_4(:,1),verticesCell_1_2(:,:));
        
        %vertices of edge
        vertEdge1=verticesTotal.verticesPerCell{verticesCell_3(indexVertEdge1)};
        vertEdge2=verticesTotal.verticesPerCell{verticesCell_4(indexVertEdge2)};

        %vertices neighbouring the edge vertices
        vertsNeighEdge1=vertcat(verticesTotal.verticesPerCell{verticesCell_3(~indexVertEdge1)});
        vertsNeighEdge2=vertcat(verticesTotal.verticesPerCell{verticesCell_4(~indexVertEdge2)});
   

        
        %modify coordinate X of vertices if they are in both extremes of the images.
        
        if sum(abs(vertEdge1(1,2) - vertsNeighEdge1(:,2)) > W/2)  > 0
            vert2modify= abs(vertEdge1(:,2) - vertsNeighEdge1(:,2)) > W/2;
            
            if vertsNeighEdge1(vert2modify,2) < vertEdge1(:,2)
                vertsNeighEdge1(vert2modify,2)=vertsNeighEdge1(vert2modify,2)+W;
            else
                vertsNeighEdge1(vert2modify,2)=vertsNeighEdge1(vert2modify,2)-W;
            end
            
        end
        
        
        if sum(abs(vertEdge2(1,2) - vertsNeighEdge2(:,2)) > W/2)  > 0
            vert2modify= abs(vertEdge2(:,2) - vertsNeighEdge2(:,2)) > W/2;
            
            if vertsNeighEdge2(vert2modify,2) < vertEdge2(:,2)
                vertsNeighEdge2(vert2modify,2)=vertsNeighEdge2(vert2modify,2)+W;
            else
                vertsNeighEdge2(vert2modify,2)=vertsNeighEdge2(vert2modify,2)-W;
            end
            
        end
        
        %distance between edge vertices and its neighbours
        distVertEdge1 = pdist2(vertEdge1,vertsNeighEdge1);
        distVertEdge2 = pdist2(vertEdge2,vertsNeighEdge2);
        
        sumEdgesOfEnergy=sum([distVertEdge1,distVertEdge2]);
end
        