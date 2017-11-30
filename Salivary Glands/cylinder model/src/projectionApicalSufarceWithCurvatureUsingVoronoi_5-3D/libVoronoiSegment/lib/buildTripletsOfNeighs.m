function [ tripletsOfNeighs ] = buildTripletsOfNeighs( neighbours )
%This method return triangles of neighs

    tripletsOfNeighs=[];
    for i=1:length(neighbours)
        
        neigh_cell=neighbours{i};
        for j=1:length(neigh_cell)
            if neigh_cell(j) > i
                neigh_J=neighbours{neigh_cell(j)};
                for k=1:length(neigh_J)
                    if (neigh_J(k)>neigh_cell(j))
                        common_cell=intersect(i,intersect(neigh_J,neighbours{neigh_J(k)}));
                        if(isempty(common_cell)==0)
                            triangleSeed=sort([i,neigh_cell(j),neigh_J(k)]);
                            tripletsOfNeighs=[tripletsOfNeighs;triangleSeed];
                        end
                    end
                end
            end
        end
        

    end
    tripletsOfNeighs=unique(tripletsOfNeighs,'rows');
    tripletsOfNeighs=sortrows(tripletsOfNeighs);



end