function [tableDataAngles] = getAnglesOfEdgeTransition( initialDataPath, reducDataPath )

%load data of ellipsoid reducted
load(reducDataPath) %reducted ellipsoid ->ellipsoidInfo2
ellipsoidInfo2=ellipsoidInfo;
load(initialDataPath) %initial ellipsoid ->ellipsoidInfo

cellsTransition = find(cellfun(@(x, y) size(setxor(x, y), 1), ellipsoidInfo2.neighbourhood, ellipsoidInfo.neighbourhood)>0);

%% Find vertices of transition edges
neighInitial=[];
neighReducted=[];
for i=1:length(cellsTransition)
      
    %cellsNeighbors in reducted and not initially
    neighCelTransition=intersect(cellsTransition,setxor(ellipsoidInfo2.neighbourhood{cellsTransition(i),1},ellipsoidInfo.neighbourhood{cellsTransition(i),1}))';
    if length(neighCelTransition)
        
        if length(neighCelTransition)>=2
            neighCelTransition=[neighCelTransition',ones(length(neighCelTransition),1)*cellsTransition(i)];
        else
            neighCelTransition=[neighCelTransition,cellsTransition(i)];
        end
            
        memberReduct=ismember(neighCelTransition(:, 1),ellipsoidInfo2.neighbourhood{cellsTransition(i),1});
        memberInit=1-memberReduct;
        % new neighs in reducted ellipsoid
        if any(memberReduct)
            neighReducted(end+1:end+sum(memberReduct),:)=neighCelTransition(find(memberReduct),:);
        end
        %older neighs in initial ellipsoid
%         if i==69
%             'a'
%         end

        if any(memberInit)
            neighInitial(end+1:end+sum(memberInit),:)=neighCelTransition(find(memberInit),:);
        end
        
    end
    
end
neighReducted=unique([min(neighReducted,[],2),max(neighReducted,[],2)],'rows');
neighInitial=unique([min(neighInitial,[],2),max(neighInitial,[],2)],'rows');

%Look for edges pre transition.
cellsFormingEdgeTransition=cell(size(neighReducted,1),3);
for i=1:size(neighReducted,1)
    cellsFormingEdgeTransition{i,1}=neighReducted(i,:);
    cellsFormingEdgeTransition{i,2}=intersect(ellipsoidInfo.neighbourhood{neighReducted(i,:),1})';
    cellsFormingEdgeTransition{i,3}=intersect(ellipsoidInfo.verticesPerCell{cellsFormingEdgeTransition{i,2}},'rows');
end
tableDataAngles=cell2table(cellsFormingEdgeTransition);
tableDataAngles.Properties.VariableNames = {'newNeighbors' 'cellsSharingEdge' 'verticesOfEdge'};


%% Compared edges against meridians of ellipsoid
[xVerGrid,yVerGrid,zVerGrid]=ellipsoid(ellipsoidInfo.xCenter, ellipsoidInfo.yCenter, ellipsoidInfo.zCenter, ellipsoidInfo.xRadius, ellipsoidInfo.yRadius, ellipsoidInfo.zRadius, ellipsoidInfo.resolutionEllipse);
[~,verGrid,~] = surf2patch(xVerGrid,yVerGrid,zVerGrid);

angles=zeros(size(tableDataAngles.verticesOfEdge,1),1);
for i=1:size(tableDataAngles.verticesOfEdge,1)
    
    vertEdge=tableDataAngles.verticesOfEdge{i,1};
    distVert=pdist2(vertEdge(1,:),verGrid);
    [~,gridVertIndex]=min(distVert);

    if mod(gridVertIndex,ellipsoidInfo.resolutionEllipse+1)==0
        indexSuperiorVertex=gridVertIndex-1;
    else
        indexSuperiorVertex=gridVertIndex+1;
    end

    directorMeridianVector= verGrid(indexSuperiorVertex,:)-verGrid(gridVertIndex,:);
    directorEdgeTransitionVector=vertEdge(2,:)-vertEdge(1,:);

    %Calculate angle between vectors
    angles(i)=rad2deg(atan2(norm(cross(directorMeridianVector,directorEdgeTransitionVector)),dot(directorMeridianVector,directorEdgeTransitionVector)));
    if angles(i)>90
        angles(i)=180-angles(i);
    end
end
tableAngle=array2table(angles);
tableAngle.Properties.VariableNames = {'angleEdgeTransition'};
tableDataAngles=[tableDataAngles tableAngle];



%Paint initial ellipsoid and transition edges
figure('Visible', 'on');
clmap = gray();
ncl = size(clmap,1);
for cellIndexCrossHead = 1:size(ellipsoidInfo.verticesPerCell, 1)
    cl = clmap(mod(cellIndexCrossHead,ncl)+1,:);
    VertCell = ellipsoidInfo.verticesPerCell{cellIndexCrossHead};
    KVert = convhulln([VertCell; ellipsoidInfo.finalCentroids(cellIndexCrossHead, :)]);
    patch('Vertices',[VertCell; ellipsoidInfo.finalCentroids(cellIndexCrossHead, :)],'Faces', KVert,'FaceColor', cl ,'FaceAlpha', 1, 'EdgeColor', 'none')
    hold on;
end
axis equal



for i=1:length(angles)
    edgeTran=tableDataAngles.verticesOfEdge{i};
    if (angles(i)<30)
        col='green';
    else if (angles(i) >=30 && angles(i)<60)
         col='yellow';
        else
            col='red';
        end
    end

    plot3([edgeTran(1,1);edgeTran(2,1)],[edgeTran(1,2);edgeTran(2,2)],[edgeTran(1,3);edgeTran(2,3)],'LineStyle','-','Color',col,'LineWidth',5)
    
end