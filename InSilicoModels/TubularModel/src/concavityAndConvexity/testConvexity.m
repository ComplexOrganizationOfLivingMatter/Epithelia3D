function [propConvexity,propStraightEdges] = testConvexity(img,listSeeds)
    
    %%  Testing convexity of concavity of each edge

    %get all pairs of neighbours (all edges)
    [neighs,~]=calculate_neighbours(img);
    pairOfNeighs=(cellfun(@(x, y) [y*ones(length(x),1),x],neighs',num2cell(1:size(neighs,2))','UniformOutput',false));
    pairOfNeighs=vertcat(pairOfNeighs{:,:});
    pairOfNeighs=[min(pairOfNeighs,[],2),max(pairOfNeighs,[],2)];
    pairOfNeighs=unique(pairOfNeighs,'rows');
        
    %applying the condicition of convexity
    distanXY=cell2mat(arrayfun(@(x,y) abs(listSeeds(x,end-1:end)-listSeeds(y,end-1:end)),pairOfNeighs(:,1),pairOfNeighs(:,2),'UniformOutput',false));
    convexLogical=distanXY(:,2)>distanXY(:,1);
    straightEdges=distanXY(:,2)==distanXY(:,1);
    
    convexityOfCellEdges=[pairOfNeighs(:,1),convexLogical;pairOfNeighs(:,2),1-convexLogical];
    
    propConvexity=zeros(1,size(listSeeds,1));
    for i=1:size(listSeeds,1)
        sidesCell=sum(convexityOfCellEdges(:,1)==i);
        propConvexity(1,i)=sum(convexityOfCellEdges(convexityOfCellEdges(:,1)==i,2))/sidesCell;
    end

    propStraightEdges=sum(straightEdges)/size(straightEdges,1);
end

