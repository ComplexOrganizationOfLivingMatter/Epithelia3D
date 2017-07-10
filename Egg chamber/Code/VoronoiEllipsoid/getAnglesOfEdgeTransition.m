function [tableDataAngles,anglesPerRegion] = getAnglesOfEdgeTransition( ellipsoidInfo, ellipsoidInfoReducted, outputDir,cellsTransition )

cellsTransition = find(cellfun(@(x, y) size(setxor(x, y), 1), ellipsoidInfoReducted.neighbourhood, ellipsoidInfo.neighbourhood)>0);

%% Find vertices of transition edges
neighInitial=[];
neighReducted=[];
for i=1:length(cellsTransition)
      
    %cellsNeighbors in reducted and not initially
    neighCelTransition=intersect(cellsTransition,setxor(ellipsoidInfoReducted.neighbourhood{cellsTransition(i),1},ellipsoidInfo.neighbourhood{cellsTransition(i),1}))';
    if ~isempty(neighCelTransition)
        
        if length(neighCelTransition)>=2
            neighCelTransition=[neighCelTransition',ones(length(neighCelTransition),1)*cellsTransition(i)];
        else
            neighCelTransition=[neighCelTransition,cellsTransition(i)];
        end
            
        memberReduct=ismember(neighCelTransition(:, 1),ellipsoidInfoReducted.neighbourhood{cellsTransition(i),1});
        memberInit=1-memberReduct;
        % new neighs in reducted ellipsoid
        if any(memberReduct)
            neighReducted(end+1:end+sum(memberReduct),:)=neighCelTransition(find(memberReduct),:);
        end
        %older neighs in initial ellipsoid
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

if ~isempty(tableDataAngles.verticesOfEdge)
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

    [~]=paintHeatmapOfTransitions( ellipsoidInfo, ellipsoidInfoReducted, '' );
    axis equal

    endLimitRight=ellipsoidInfo.yRadius*2/3;
    endLimitLeft=-endLimitRight;

    numAnglesEndRight=0;
    numAnglesEndLeft=0;
    numAnglesCentralRegion=0;
    anglesEndLeft=[];
    anglesEndRight=[];
    anglesCentralRegion=[];
    for i=1:length(angles)
        edgeTran=tableDataAngles.verticesOfEdge{i};
        if (angles(i)<30)
            col='green';
        else if (angles(i) >=30 && angles(i)<60)
             col='blue';
            else
                col='red';
            end
        end

        plot3([edgeTran(1,1);edgeTran(2,1)],[edgeTran(1,2);edgeTran(2,2)],[edgeTran(1,3);edgeTran(2,3)],'LineStyle','-','Color',col,'LineWidth',5)

        if mean(edgeTran(:,2))>endLimitRight
            numAnglesEndRight=numAnglesEndRight+1;
            anglesEndRight(end+1)=angles(i);

        else if mean(edgeTran(:,2))<endLimitLeft
            numAnglesEndLeft=numAnglesEndLeft+1;
            anglesEndLeft(end+1)=angles(i);
            else
                numAnglesCentralRegion=numAnglesCentralRegion+1;
                anglesCentralRegion(end+1)=angles(i);
            end
        end
    end

    savefig(strcat(outputDir, '\angles_ellipsoid_x', num2str(ellipsoidInfo.xRadius), '_y', num2str(ellipsoidInfo.yRadius), '_z', num2str(ellipsoidInfo.zRadius), '_cellHeight', num2str(ellipsoidInfoReducted.cellHeight), '.fig'));


    anglesPerRegion.averageAnglesLess30EndRight=sum(anglesEndRight<30)/length(anglesEndRight);
    anglesPerRegion.averageAnglesBetw30_60EndRight=sum(anglesEndRight>=30 & anglesEndRight<60)/length(anglesEndRight);
    anglesPerRegion.averageAnglesMore60EndRight=sum(anglesEndRight>=60)/length(anglesEndRight);

    anglesPerRegion.averageAnglesLess30EndLeft=sum(anglesEndLeft<30)/length(anglesEndLeft);
    anglesPerRegion.averageAnglesBetw30_60EndLeft=sum(anglesEndLeft>=30 & anglesEndLeft<60)/length(anglesEndLeft);
    anglesPerRegion.averageAnglesMore60EndLeft=sum(anglesEndLeft>=60)/length(anglesEndLeft);

    anglesPerRegion.averageAnglesLess30EndGlobal=sum([anglesEndLeft,anglesEndRight]<30)/length([anglesEndLeft,anglesEndRight]);
    anglesPerRegion.averageAnglesBetw30_60EndGlobal=sum([anglesEndLeft,anglesEndRight]>=30 & [anglesEndLeft,anglesEndRight]<60)/length([anglesEndLeft,anglesEndRight]);
    anglesPerRegion.averageAnglesMore60EndGlobal=sum([anglesEndLeft,anglesEndRight]>=60)/length([anglesEndLeft,anglesEndRight]);


    anglesPerRegion.averageAnglesLess30CentralRegion=sum(anglesCentralRegion<30)/length(anglesCentralRegion);
    anglesPerRegion.averageAnglesBetw30_60CentralRegion=sum(anglesCentralRegion>=30 & anglesCentralRegion<60)/length(anglesCentralRegion);
    anglesPerRegion.averageAnglesMore60CentralRegion=sum(anglesCentralRegion>=60)/length(anglesCentralRegion);

    anglesPerRegion.numAnglesEndLeft=length(anglesEndLeft);
    anglesPerRegion.numAnglesEndRight=length(anglesEndRight);
    anglesPerRegion.numAnglesCentralRegion=length(anglesCentralRegion);
    
else
    tableDataAngles=[];
    anglesPerRegion=[];
end





end


