function [pairTotalVertices] = deleteJunctionIntermediateLayer(dataVertID,pairTotalVertices)
%DELETEJUNCTIONINTERMEDIATELAYER Summary of this function goes here
%   Detailed explanation goes here
    [~,~,c]=unique(vertcat(dataVertID{:,1}));
    vertInter=vertcat(dataVertID{c==2,2});
    join2Del=arrayfun(@(x,y) sum(ismember(vertInter,[x,y]))==2,pairTotalVertices(:,1),pairTotalVertices(:,2));
    pairTotalVertices(join2Del,:)=[];
end

