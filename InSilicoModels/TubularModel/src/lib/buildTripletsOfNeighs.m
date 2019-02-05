function [ tripletsOfNeighs ] = buildTripletsOfNeighs( neighbours )
%This method return triangles of neighs

    tripletsOfNeighs=[];
    for i=1:length(neighbours)
        
        neigh_cell=neighbours{i};
        for j=1:length(neigh_cell)
            if neigh_cell(j) > i
               try
                    neigh_J=neighbours{neigh_cell(j)};
                    for k=1:length(neigh_J)
                        if (neigh_J(k)>neigh_cell(j))
                            try
                                common_cell=intersect(i,intersect(neigh_J,neighbours{neigh_J(k)}));
                            catch
                                common_cell = [];
                            end
                            if(~isempty(common_cell))
                                triangleSeed=sort([i,neigh_cell(j),neigh_J(k)]);
                                tripletsOfNeighs=[tripletsOfNeighs;triangleSeed];
                            end
                        end
                    end
               catch
               end
            end
        end
        

    end
    tripletsOfNeighs=unique(tripletsOfNeighs,'rows');
    tripletsOfNeighs=sortrows(tripletsOfNeighs);



end