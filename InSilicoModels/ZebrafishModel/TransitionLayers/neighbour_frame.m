function [ isNeighbours, sum ] = neighbour_frame( neighs_Z, trans, cellTrans )

%Check that the cells are neighbors in the same frame
isNeighbours=1;
sum=0;
neighsNow=neighs_Z{trans(cellTrans,1)};
if size(neighsNow,1) >= 2
    for numNeighsNow=1:size(neighsNow,1)
        if any(neighsNow(numNeighsNow,1) == trans)==1
            sum=sum+1;
        end   
    end
    
    if sum>=2
        isNeighbours=1;
    else
        isNeighbours=0;
    end
else
    isNeighbours=0;
end
end

