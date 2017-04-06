function [ cellTolerances,trianTolerances ] = calculatedToleranceForEachCell( tripletsData,new_seeds_values )
%Filtering minimum tolerance from triangles to cell

totalTriplets=cat(1,tripletsData.Triplets);
totalTriplets=mod(totalTriplets,size(new_seeds_values,1));
totalTriplets(totalTriplets==0)=size(new_seeds_values,1);
trianTolerances=cat(1,tripletsData.ToleranceTriangle);

    cellTolerances=zeros(size(new_seeds_values,1),1);
    for i=1:size(new_seeds_values,1)
        pos=totalTriplets==i;
        tolerances=unique(pos.*[trianTolerances,trianTolerances,trianTolerances]);
        tolerances=tolerances(tolerances~=0);
        toleranceCell=min(tolerances);
        cellTolerances(i)=toleranceCell;
    end
end

