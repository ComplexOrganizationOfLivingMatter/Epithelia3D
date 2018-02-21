function [finalCentroid] = deleteUniqueCentroids( finalCentroid )
%DELETEUNIQUECENTROIDS Eliminates centroids that only appear in a frame


acum=1;
[C,ia,ic] = unique(vertcat(finalCentroid{:,1}));

%The number of times that each cell appears 
for numCell=1:size(C,1)
    for numCent=1:size(ic,1)
        if ic(numCent)==numCell
            numRepCell(numCell,1)=numCell;
            numRepCell(numCell,2)=acum;
            acum=acum+1;
        end
    end
    acum=1;
end

acum=1;
for numRep=1:size(numRepCell,1)
    if numRepCell(numRep,2)==1
        varID(acum,1)=numRepCell(numRep,1);
        acum=acum+1;
    end
end

%The cells of our final variable are deleted.
numError=1;
acum=1;
for numCellT=1:size(finalCentroid,1)
    
    if finalCentroid{numCellT,1}(1,1)~=varID(numError,1)
        finalC{acum,1}=finalCentroid{numCellT,1};
        finalC{acum,2}=finalCentroid{numCellT,2};
        finalC{acum,3}=finalCentroid{numCellT,3};
        acum=acum+1;
    else
        numError=numError+1;
        
    end
    
end

clear finalCentroid
finalCentroid=finalC;
finalCentroid=sortrows(finalCentroid,1);
[C,ia,ic] = unique(vertcat(finalCentroid{:,1}));

%Re-label the cells.
for numRep=1:size(vertcat(finalCentroid{:,1}),1)
    finalCentroid{numRep,1} = ic(numRep);
end

end