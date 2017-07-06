function [ ] = getAnglesOfEdgeTransition( initialDataPath, reducDataPath )

%load data of ellipsoid reducted
load(reducDataPath) %reducted ellipsoid ->ellipsoidInfo2
ellipsoidInfo2=ellipsoidInfo;
load(initialDataPath) %initial ellipsoid ->ellipsoidInfo

cellsTransition = find(cellfun(@(x, y) size(setxor(x, y), 1), ellipsoidInfo2.neighbourhood, ellipsoidInfo.neighbourhood)>0);

%% Find vertices of transition edges
neighInitial={};
neighReducted={};
for i=1:length(cellsTransition)
      
    %cellsNeighbors in reducted and not initially
    neighCelTransition=[intersect(cellsTransition,setxor(ellipsoidInfo2.neighbourhood{cellsTransition(i),1},ellipsoidInfo.neighbourhood{cellsTransition(i),1}))',cellsTransition(i)];
    if length(neighCelTransition)>1
        %unique
        %if (find(cellsTransition==neighCelTransition(1))>find(cellsTransition==neighCelTransition(2)))
        if any(cellfun(@(x) any(ismember(neighCelTransition, x)), [neighReducted(:); neighInitial(:)])) == 0
            %new neighs in reducted ellipsoid
            if ismember(neighCelTransition(1:end-1),ellipsoidInfo2.neighbourhood{cellsTransition(i),1})
                neighReducted{end+1,1}=sort(neighCelTransition);
            %older neighs in initial ellipsoid
            else
                neighInitial{end+1,1}=sort(neighCelTransition);
            end
        end
    end
    
end


%Look for edges pre transition.
cellsFormingEdgeTransition=cell(size(neighReducted,1),3);
for i=1:size(neighReducted,1)
    cellsFormingEdgeTransition{i,1}=neighReducted(i);
    cellsFormingEdgeTransition{i,2}=intersect(ellipsoidInfo.neighbourhood{neighReducted{i,1},1});
    cellsFormingEdgeTransition{i,3}=intersect(ellipsoidInfo.verticesPerCell{cellsFormingEdgeTransition{i,2}},'rows');
end
tableDataTran=cell2table(cellsFormingEdgeTransition);
tableDataTran.Properties.VariableNames = {'newNeighbors' 'cellsSharingEdge' 'verticesOfEdge'};


%% Compared edges against meridians of ellipsoid
[xVerGrid,yVerGrid,zVerGrid]=ellipsoid(ellipsoidInfo.xCenter, ellipsoidInfo.yCenter, ellipsoidInfo.zCenter, ellipsoidInfo.xRadius, ellipsoidInfo.yRadius, ellipsoidInfo.zRadius, ellipsoidInfo.resolutionEllipse);
[~,verGrid,~] = surf2patch(xVerGrid,yVerGrid,zVerGrid);

angle=cell(size(tableDataTran.verticesOfEdge,1),1);
for i=1:size(tableDataTran.verticesOfEdge,1)
    
    vertEdge=tableDataTran.verticesOfEdge{i,1};
    distVert=pdist2(vertEdge(1,:),verGrid);
    [~,gridVertIndex]=min(distVert);

    if mod(gridVertIndex,301)==0
        indexSuperiorVertex=gridVertIndex-1;
    else
        indexSuperiorVertex=gridVertIndex+1;
    end

    directorMeridianVector= verGrid(indexSuperiorVertex,:)-verGrid(gridVertIndex,:);
    directorEdgeTransitionVector=vertEdge(2,:)-vertEdge(1,:);

    %Calculate angle between vectors
    angle{i}=rad2deg(atan2(norm(cross(directorMeridianVector,directorEdgeTransitionVector)),dot(directorMeridianVector,directorEdgeTransitionVector)));
    if angle{i}>90
        angle{i}=180-angle{i};
    end
end
tableAngle=cell2table(angle);
tableAngle.Properties.VariableNames = {'angleEdgeTransition'};
tableDataTran=[tableDataTran tableAngle];
end