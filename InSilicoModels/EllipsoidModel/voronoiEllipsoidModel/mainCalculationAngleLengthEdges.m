
neighs=ellipsoidInfo.neighbourhood;

totalPairs=cellfun(@(x, y) [y*ones(length(x),1),x],neighs,num2cell(1:length(neighs))','UniformOutput',false);
totalPairs=unique(vertcat(totalPairs{:}),'rows');
totalPairs=unique([min(totalPairs,[],2),max(totalPairs,[],2)],'rows');   

angleLengthEdge = cell(size(totalPairs,1),3);

for i = 1 : size(totalPairs,1)
    
    [ anglesEdge , lengthEdge ] = calculateAngleLength( totalPairs(i,1) , totalPairs(i,2) );
    
    angleLengthEdge{i,1}=totalPairs;
    angleLengthEdge{i,2}=anglesEdge;
    angleLengthEdge{i,3}=lengthEdge;
end

