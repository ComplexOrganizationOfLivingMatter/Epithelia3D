function [tableDataAngles,anglesPerRegion] = getAnglesOfEdgeTransition( ellipsoidInfo, ellipsoidInfoReducted, outputDir )

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
        
        if size(cellsFormingEdgeTransition{i,2}, 2) == 2
            cellsFormingEdgeTransition{i,3}=intersect(ellipsoidInfo.verticesPerCell{cellsFormingEdgeTransition{i,2}},'rows');
        else %2 transitios have ocurred
            disp('2 transitions have ocurred within the same motif')
%             cellsIntervining = [cellsFormingEdgeTransition{i, 1:2}];
%             intersection1 = intersect(ellipsoidInfo.verticesPerCell{cellsIntervining(1)}, ellipsoidInfo.verticesPerCell{cellsIntervining(3)}, 'rows');
%             intersection2 = intersect(ellipsoidInfo.verticesPerCell{cellsIntervining(2)}, ellipsoidInfo.verticesPerCell{cellsIntervining(3)}, 'rows');
%             neighboursBasal = ellipsoidInfo.neighbourhood{cellsFormingEdgeTransition{i, 2}};
%             neighboursApical = ellipsoidInfoReducted.neighbourhood{cellsFormingEdgeTransition{i, 2}};
        end
    end
    %Removing empty cells
    notEmptyCells = cellfun(@(x) isempty(x) == 0 , cellsFormingEdgeTransition(:, 3));
    tableDataAngles=cell2table(cellsFormingEdgeTransition(notEmptyCells, :));
    if isempty(tableDataAngles) == 0
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

            endLimitRight=ellipsoidInfo.xRadius*ellipsoidInfo.bordersSituatedAt;
            endLimitLeft=-endLimitRight;

            numAnglesEndRight=zeros(size(ellipsoidInfo.bordersSituatedAt, 2), 1);
            numAnglesEndLeft=zeros(size(ellipsoidInfo.bordersSituatedAt, 2), 1);
            numAnglesCentralRegion=zeros(size(ellipsoidInfo.bordersSituatedAt, 2), 1);
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

                isRightCentroid = mean(edgeTran(:,1))>endLimitRight;
                if any(isRightCentroid)
                    numAnglesEndRight(isRightCentroid) = numAnglesEndRight(isRightCentroid) + 1;
                    anglesEndRight(isRightCentroid, end+1)=angles(i);
                end
                
                isLeftCentroid = mean(edgeTran(:,1))<endLimitLeft;
                if any(isLeftCentroid)
                    numAnglesEndLeft(isLeftCentroid) = numAnglesEndLeft(isLeftCentroid) + 1;
                    anglesEndLeft(isLeftCentroid, end+1) = angles(i);
                end
                
                isCentralCentroid = mean(edgeTran(:,1)) >= endLimitLeft & mean(edgeTran(:,1)) <= endLimitRight;
                if any(isCentralCentroid)
                    numAnglesCentralRegion(isCentralCentroid) = numAnglesCentralRegion(isCentralCentroid) + 1;
                    anglesCentralRegion(isCentralCentroid, end+1) = angles(i);
                end
            end

            savefig(strcat(outputDir, '\angles_ellipsoid_x', num2str(ellipsoidInfo.xRadius), '_y', num2str(ellipsoidInfo.yRadius), '_z', num2str(ellipsoidInfo.zRadius), '_cellHeight', num2str(ellipsoidInfoReducted.cellHeight), '.fig'));

            anglesPerRegion.averageAnglesLess15Total=sum(angles<15)/length(angles);
            anglesPerRegion.averageAnglesBetw15_30Total=sum(angles>=15 & angles<30)/length(angles);
            anglesPerRegion.averageAnglesBetw30_45Total=sum(angles>=30 & angles<45)/length(angles);
            anglesPerRegion.averageAnglesBetw45_60Total=sum(angles>=45 & angles<60)/length(angles);
            anglesPerRegion.averageAnglesBetw60_75Total=sum(angles>=60 & angles<75)/length(angles);
            anglesPerRegion.averageAnglesMore75Total=sum(angles>=75)/length(angles);

            for numBorders = 1:size(ellipsoidInfo.bordersSituatedAt, 2)
                anglesPerRegion.averageAnglesLess15EndRight=sum(anglesEndRight(numBorders, :)<15)/length(anglesEndRight(numBorders, :));
                anglesPerRegion.averageAnglesBetw15_30EndRight=sum(anglesEndRight(numBorders, :)>=15 & anglesEndRight(numBorders, :)<30)/length(anglesEndRight(numBorders, :));
                anglesPerRegion.averageAnglesBetw30_45EndRight=sum(anglesEndRight(numBorders, :)>=30 & anglesEndRight(numBorders, :)<45)/length(anglesEndRight(numBorders, :));
                anglesPerRegion.averageAnglesBetw45_60EndRight=sum(anglesEndRight(numBorders, :)>=45 & anglesEndRight(numBorders, :)<60)/length(anglesEndRight(numBorders, :));
                anglesPerRegion.averageAnglesBetw60_75EndRight=sum(anglesEndRight(numBorders, :)>=60 & anglesEndRight(numBorders, :)<75)/length(anglesEndRight(numBorders, :));
                anglesPerRegion.averageAnglesMore75EndRight=sum(anglesEndRight(numBorders, :)>=75)/length(anglesEndRight(numBorders, :));

                anglesPerRegion.averageAnglesLess15EndLeft=sum(anglesEndLeft(numBorders, :)<15)/length(anglesEndLeft(numBorders, :));
                anglesPerRegion.averageAnglesBetw15_30EndLeft=sum(anglesEndLeft(numBorders, :)>=15 & anglesEndLeft(numBorders, :)<30)/length(anglesEndLeft(numBorders, :));
                anglesPerRegion.averageAnglesBetw30_45EndLeft=sum(anglesEndLeft(numBorders, :)>=30 & anglesEndLeft(numBorders, :)<45)/length(anglesEndLeft(numBorders, :));
                anglesPerRegion.averageAnglesBetw45_60EndLeft=sum(anglesEndLeft(numBorders, :)>=45 & anglesEndLeft(numBorders, :)<60)/length(anglesEndLeft(numBorders, :));
                anglesPerRegion.averageAnglesBetw60_75EndLeft=sum(anglesEndLeft(numBorders, :)>=60 & anglesEndLeft(numBorders, :)<75)/length(anglesEndLeft(numBorders, :));
                anglesPerRegion.averageAnglesMore75EndLeft=sum(anglesEndLeft(numBorders, :)>=75)/length(anglesEndLeft(numBorders, :));

                anglesPerRegion.averageAnglesLess15EndGlobal=sum([anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]<15)/length([anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]);
                anglesPerRegion.averageAnglesBetw15_30EndGlobal=sum([anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]>=15 & [anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]<30)/length([anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]);
                anglesPerRegion.averageAnglesBetw30_45EndGlobal=sum([anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]>=30 & [anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]<45)/length([anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]);
                anglesPerRegion.averageAnglesBetw45_60EndGlobal=sum([anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]>=45 & [anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]<60)/length([anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]);
                anglesPerRegion.averageAnglesBetw60_75EndGlobal=sum([anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]>=60 & [anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]<75)/length([anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]);
                anglesPerRegion.averageAnglesMore75EndGlobal=sum([anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]>=75)/length([anglesEndLeft(numBorders, :),anglesEndRight(numBorders, :)]);

                anglesPerRegion.averageAnglesLess15CentralRegion=sum(anglesCentralRegion(numBorders, :)<15)/length(anglesCentralRegion(numBorders, :));
                anglesPerRegion.averageAnglesBetw15_30CentralRegion=sum(anglesCentralRegion(numBorders, :)>=15 & anglesCentralRegion(numBorders, :)<30)/length(anglesCentralRegion(numBorders, :));
                anglesPerRegion.averageAnglesBetw30_45CentralRegion=sum(anglesCentralRegion(numBorders, :)>=30 & anglesCentralRegion(numBorders, :)<45)/length(anglesCentralRegion(numBorders, :));
                anglesPerRegion.averageAnglesBetw45_60CentralRegion=sum(anglesCentralRegion(numBorders, :)>=45 & anglesCentralRegion(numBorders, :)<60)/length(anglesCentralRegion(numBorders, :));
                anglesPerRegion.averageAnglesBetw60_75CentralRegion=sum(anglesCentralRegion(numBorders, :)>=60 & anglesCentralRegion(numBorders, :)<75)/length(anglesCentralRegion(numBorders, :));
                anglesPerRegion.averageAnglesMore75CentralRegion=sum(anglesCentralRegion(numBorders, :)>=75)/length(anglesCentralRegion(numBorders, :));

                anglesPerRegion.numAnglesEndLeft=length(anglesEndLeft(numBorders, :));
                anglesPerRegion.numAnglesEndRight=length(anglesEndRight(numBorders, :));
                anglesPerRegion.numAnglesCentralRegion=length(anglesCentralRegion(numBorders, :));
                
            end

        else
            tableDataAngles=[];
            anglesPerRegion=[];
        end
    else
        tableDataAngles=[];
        anglesPerRegion=[];
    end
end


