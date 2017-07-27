function [tableDataAngles,anglesPerRegion, ellipsoidInfoReducted] = getAnglesOfEdgeTransition( ellipsoidInfo, ellipsoidInfoReducted, outputDir )

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
            %% transforming 2 transitions into two edge length
            neighbourhood1 = ellipsoidInfo.neighbourhood{neighReducted(i,1)};
            neighbourhood2 = ellipsoidInfo.neighbourhood{neighReducted(i,2)};
            neighbourhood3 = ellipsoidInfo.neighbourhood{cellsFormingEdgeTransition{i,2}};
            
            
            neighbourhood1Red = ellipsoidInfoReducted.neighbourhood{neighReducted(i,1)};
            neighbourhood2Red = ellipsoidInfoReducted.neighbourhood{neighReducted(i,2)};
            neighbourhood3Red = ellipsoidInfoReducted.neighbourhood{cellsFormingEdgeTransition{i,2}};
            
            %changingNeigh3 = intersect(neighbourhood3, neighbourhood3Red);
            try
                commonNeigh = intersect(neighbourhood2Red, neighbourhood1Red);
                commonNeigh = commonNeigh(commonNeigh ~= cellsFormingEdgeTransition{i, 2});
                commonNeigh2 = intersect(vertcat(ellipsoidInfo.neighbourhood{commonNeigh})', vertcat(ellipsoidInfo.neighbourhood{cellsFormingEdgeTransition{i, 2}})')';
                doubleTransitionCells = setdiff(vertcat(commonNeigh,commonNeigh2)',[cellsFormingEdgeTransition{i,1}]);

                motif1 = [neighReducted(i,1), cellsFormingEdgeTransition{i,2}, doubleTransitionCells];
                motif2 = [neighReducted(i,2), cellsFormingEdgeTransition{i,2}, doubleTransitionCells];
                
                
                intersectionOfMotif = zeros(size(motif1, 2), 1);
                for numCell1 = 1:size(motif1, 2)
                	intersectionOfMotif(numCell1) = size(intersect(motif1, ellipsoidInfo.neighbourhood{motif1(numCell1)}), 1);
                end
                
                %First transition
                cellsFormingEdgeTransition{i,1} = motif1(intersectionOfMotif == 2);
                cellsFormingEdgeTransition{i,2} = motif1(intersectionOfMotif == 3);
                cellsFormingEdgeTransition{i,3} = intersect(ellipsoidInfo.verticesPerCell{motif1(intersectionOfMotif == 3)}, 'rows');
                
                intersectionOfMotif = zeros(size(motif2, 2), 1);
                for numCell1 = 1:size(motif2, 2)
                	intersectionOfMotif(numCell1) = size(intersect(motif2, ellipsoidInfo.neighbourhood{motif2(numCell1)}), 1);
                end
                
                %Second transition
                cellsFormingEdgeTransition{end+1,1} = motif1(intersectionOfMotif == 2);
                cellsFormingEdgeTransition{end,2} = motif1(intersectionOfMotif == 3);
                cellsFormingEdgeTransition{end,3} = intersect(ellipsoidInfo.verticesPerCell{motif2(intersectionOfMotif == 3)}, 'rows');
            catch mexception
                disp('Weird transition. Probably a crosslink initially.');
                disp(mexception.getReport);
                disp('--------------------------');
            end
            
            %%Showing the motifs
%             clmap = colorcube();
%             vertices = unique([cellsFormingEdgeTransition{i,1}'; cellsFormingEdgeTransition{i,2}'; doubleTransitionCells']);
%             figure
%             for numVertex = 1:size(vertices, 1)
%                 KVert = convhulln([ellipsoidInfoReducted.verticesPerCell{vertices(numVertex)}]);
%                 patch('Vertices',[ellipsoidInfoReducted.verticesPerCell{vertices(numVertex)}],'Faces', KVert,'FaceColor', clmap(numVertex, :) ,'FaceAlpha', 1, 'EdgeColor', 'none')
%             end
%             
%             figure
%             for numVertex = 1:size(vertices, 1)
%                 KVert = convhulln([ellipsoidInfo.verticesPerCell{vertices(numVertex)}]);
%                 patch('Vertices',[ellipsoidInfo.verticesPerCell{vertices(numVertex)}],'Faces', KVert,'FaceColor', clmap(numVertex, :) ,'FaceAlpha', 1, 'EdgeColor', 'none')
%             end
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
        edgesLength=zeros(size(tableDataAngles.verticesOfEdge,1),1);

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
                edgesLength(i) = pdist2(vertEdge(1, :), vertEdge(2, :));
                if angles(i)>90
                    angles(i)=180-angles(i);
                end
            end
            
            ellipsoidInfoReducted.anglesOfTransitions = angles;
            ellipsoidInfoReducted.edgesLengthOfTransitions = edgesLength;

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
            
            edgesLengthEndLeft=[];
            edgesLengthEndRight=[];
            edgesLengthCentralRegion=[];
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
                    anglesEndRight(isRightCentroid, end+1) = angles(i);
                    edgesLengthEndRight(isRightCentroid, end+1) = edgesLength(i);
                end
                
                isLeftCentroid = mean(edgeTran(:,1))<endLimitLeft;
                if any(isLeftCentroid)
                    numAnglesEndLeft(isLeftCentroid) = numAnglesEndLeft(isLeftCentroid) + 1;
                    anglesEndLeft(isLeftCentroid, end+1) = angles(i);
                    edgesLengthEndLeft(isLeftCentroid, end+1)= edgesLength(i);
                end
                
                isCentralCentroid = mean(edgeTran(:,1)) >= endLimitLeft & mean(edgeTran(:,1)) <= endLimitRight;
                if any(isCentralCentroid)
                    numAnglesCentralRegion(isCentralCentroid) = numAnglesCentralRegion(isCentralCentroid) + 1;
                    anglesCentralRegion(isCentralCentroid, end+1) = angles(i);
                    edgesLengthCentralRegion(isCentralCentroid, end+1) = edgesLength(i);
                end
            end

            savefig(strcat(outputDir, '\angles_ellipsoid_x', num2str(ellipsoidInfo.xRadius), '_y', num2str(ellipsoidInfo.yRadius), '_z', num2str(ellipsoidInfo.zRadius), '_cellHeight', num2str(ellipsoidInfoReducted.cellHeight), '.fig'));

            anglesPerRegion.averageAnglesLess15Total=sum(angles<15)/length(angles);
            anglesPerRegion.averageAnglesBetw15_30Total=sum(angles>=15 & angles<30)/length(angles);
            anglesPerRegion.averageAnglesBetw30_45Total=sum(angles>=30 & angles<45)/length(angles);
            anglesPerRegion.averageAnglesBetw45_60Total=sum(angles>=45 & angles<60)/length(angles);
            anglesPerRegion.averageAnglesBetw60_75Total=sum(angles>=60 & angles<75)/length(angles);
            anglesPerRegion.averageAnglesMore75Total=sum(angles>=75)/length(angles);
            
           	anglesPerRegion.percentageTransitionsPerCell=length(angles)/size(ellipsoidInfo.finalCentroids, 1);

            anglesPerRegion.meanEdgeLength = mean(edgesLength);
            anglesPerRegion.stdEdgeLength = std(edgesLength);
            
            if isempty(anglesEndLeft)
                anglesEndLeft(1:size(ellipsoidInfo.bordersSituatedAt, 2), :) = NaN;
                edgesLengthEndLeft(1:size(ellipsoidInfo.bordersSituatedAt, 2), :) = NaN;
            end
            
            if isempty(anglesEndRight)
                anglesEndRight(1:size(ellipsoidInfo.bordersSituatedAt, 2), :) = NaN;
                edgesLengthEndRight(1:size(ellipsoidInfo.bordersSituatedAt, 2), :) = NaN;
            end
            
            if isempty(anglesCentralRegion)
                anglesCentralRegion(1:size(ellipsoidInfo.bordersSituatedAt, 2), :) = NaN;
                edgesLengthCentralRegion(1:size(ellipsoidInfo.bordersSituatedAt, 2), :) = NaN;
            end
            
            for numBorder = 1:size(ellipsoidInfo.bordersSituatedAt, 2)
                
                numCellsAtXBorderRight = sum(initialEllipsoid.finalCentroids(:, 1) < -(ellipsoidInfo.bordersSituatedAt(numBorder) * initialEllipsoid.xRadius));
                numCellsAtXBorderLeft = sum(initialEllipsoid.finalCentroids(:, 1) > (ellipsoidInfo.bordersSituatedAt(numBorder) * initialEllipsoid.xRadius));
                numCellsAtXCentral = size(initialEllipsoid.finalCentroids(:, 1), 1) - numCellsAtXBorderRight - numCellsAtXBorderLeft;
                
                anglesEndRightPerBorder = anglesEndRight(numBorder, :);
                anglesEndRightPerBorder(anglesEndRightPerBorder == 0) = [];
                anglesEndLeftPerBorder = anglesEndLeft(numBorder, :);
                anglesEndLeftPerBorder(anglesEndLeftPerBorder == 0) = [];
                anglesCentralRegionPerBorder = anglesCentralRegion(numBorder, :);
                anglesCentralRegionPerBorder(anglesCentralRegionPerBorder == 0) = [];
                
                anglesPerRegion.averageAnglesLess15EndRight=sum(anglesEndRightPerBorder<15)/length(anglesEndRightPerBorder);
                anglesPerRegion.averageAnglesBetw15_30EndRight=sum(anglesEndRightPerBorder>=15 & anglesEndRightPerBorder<30)/length(anglesEndRightPerBorder);
                anglesPerRegion.averageAnglesBetw30_45EndRight=sum(anglesEndRightPerBorder>=30 & anglesEndRightPerBorder<45)/length(anglesEndRightPerBorder);
                anglesPerRegion.averageAnglesBetw45_60EndRight=sum(anglesEndRightPerBorder>=45 & anglesEndRightPerBorder<60)/length(anglesEndRightPerBorder);
                anglesPerRegion.averageAnglesBetw60_75EndRight=sum(anglesEndRightPerBorder>=60 & anglesEndRightPerBorder<75)/length(anglesEndRightPerBorder);
                anglesPerRegion.averageAnglesMore75EndRight=sum(anglesEndRightPerBorder>=75)/length(anglesEndRightPerBorder);

                anglesPerRegion.averageAnglesLess15EndLeft=sum(anglesEndLeftPerBorder<15)/length(anglesEndLeftPerBorder);
                anglesPerRegion.averageAnglesBetw15_30EndLeft=sum(anglesEndLeftPerBorder>=15 & anglesEndLeftPerBorder<30)/length(anglesEndLeftPerBorder);
                anglesPerRegion.averageAnglesBetw30_45EndLeft=sum(anglesEndLeftPerBorder>=30 & anglesEndLeftPerBorder<45)/length(anglesEndLeftPerBorder);
                anglesPerRegion.averageAnglesBetw45_60EndLeft=sum(anglesEndLeftPerBorder>=45 & anglesEndLeftPerBorder<60)/length(anglesEndLeftPerBorder);
                anglesPerRegion.averageAnglesBetw60_75EndLeft=sum(anglesEndLeftPerBorder>=60 & anglesEndLeftPerBorder<75)/length(anglesEndLeftPerBorder);
                anglesPerRegion.averageAnglesMore75EndLeft=sum(anglesEndLeftPerBorder>=75)/length(anglesEndLeftPerBorder);

                anglesPerRegion.averageAnglesLess15EndGlobal=sum([anglesEndLeftPerBorder,anglesEndRightPerBorder]<15)/length([anglesEndLeftPerBorder,anglesEndRightPerBorder]);
                anglesPerRegion.averageAnglesBetw15_30EndGlobal=sum([anglesEndLeftPerBorder,anglesEndRightPerBorder]>=15 & [anglesEndLeftPerBorder,anglesEndRightPerBorder]<30)/length([anglesEndLeftPerBorder,anglesEndRightPerBorder]);
                anglesPerRegion.averageAnglesBetw30_45EndGlobal=sum([anglesEndLeftPerBorder,anglesEndRightPerBorder]>=30 & [anglesEndLeftPerBorder,anglesEndRightPerBorder]<45)/length([anglesEndLeftPerBorder,anglesEndRightPerBorder]);
                anglesPerRegion.averageAnglesBetw45_60EndGlobal=sum([anglesEndLeftPerBorder,anglesEndRightPerBorder]>=45 & [anglesEndLeftPerBorder,anglesEndRightPerBorder]<60)/length([anglesEndLeftPerBorder,anglesEndRightPerBorder]);
                anglesPerRegion.averageAnglesBetw60_75EndGlobal=sum([anglesEndLeftPerBorder,anglesEndRightPerBorder]>=60 & [anglesEndLeftPerBorder,anglesEndRightPerBorder]<75)/length([anglesEndLeftPerBorder,anglesEndRightPerBorder]);
                anglesPerRegion.averageAnglesMore75EndGlobal=sum([anglesEndLeftPerBorder,anglesEndRightPerBorder]>=75)/length([anglesEndLeftPerBorder,anglesEndRightPerBorder]);

                anglesPerRegion.averageAnglesLess15CentralRegion=sum(anglesCentralRegionPerBorder<15)/length(anglesCentralRegionPerBorder);
                anglesPerRegion.averageAnglesBetw15_30CentralRegion=sum(anglesCentralRegionPerBorder>=15 & anglesCentralRegionPerBorder<30)/length(anglesCentralRegionPerBorder);
                anglesPerRegion.averageAnglesBetw30_45CentralRegion=sum(anglesCentralRegionPerBorder>=30 & anglesCentralRegionPerBorder<45)/length(anglesCentralRegionPerBorder);
                anglesPerRegion.averageAnglesBetw45_60CentralRegion=sum(anglesCentralRegionPerBorder>=45 & anglesCentralRegionPerBorder<60)/length(anglesCentralRegionPerBorder);
                anglesPerRegion.averageAnglesBetw60_75CentralRegion=sum(anglesCentralRegionPerBorder>=60 & anglesCentralRegionPerBorder<75)/length(anglesCentralRegionPerBorder);
                anglesPerRegion.averageAnglesMore75CentralRegion=sum(anglesCentralRegionPerBorder>=75)/length(anglesCentralRegionPerBorder);

                anglesPerRegion.numAnglesEndLeft=length(anglesEndLeftPerBorder);
                anglesPerRegion.numAnglesEndRight=length(anglesEndRightPerBorder);
                anglesPerRegion.numAnglesCentralRegion=length(anglesCentralRegionPerBorder);
                
                anglesPerRegion.percentageTransitionsEndLeft=length(anglesEndLeftPerBorder)/numCellsAtXBorderLeft;
                anglesPerRegion.percentageTransitionsEndRight=length(anglesEndRightPerBorder)/numCellsAtXBorderRight;
                anglesPerRegion.percentageTransitionsCentralRegion=length(anglesCentralRegionPerBorder)/numCellsAtXMiddle;
                
                edgesLengthEndRightPerBorder = edgesLengthEndRight(numBorder, :);
                edgesLengthEndRightPerBorder(edgesLengthEndRightPerBorder == 0) = [];
                edgesLengthEndLeftPerBorder = edgesLengthEndLeft(numBorder, :);
                edgesLengthEndLeftPerBorder(edgesLengthEndLeftPerBorder == 0) = [];
                edgesLengthCentralRegionPerBorder = edgesLengthCentralRegion(numBorder, :);
                edgesLengthCentralRegionPerBorder(edgesLengthCentralRegionPerBorder == 0) = [];

                anglesPerRegion.meanEdgeLengthEndLeft = mean(edgesLengthEndLeftPerBorder);
                anglesPerRegion.meanEdgeLengthEndRight = mean(edgesLengthEndRightPerBorder);
                anglesPerRegion.meanEdgeLengthCentralRegion = mean(edgesLengthCentralRegionPerBorder);

                anglesPerRegion.stdEdgeLengthEndLeft = std(edgesLengthEndLeftPerBorder);
                anglesPerRegion.stdEdgeLengthEndRight = std(edgesLengthEndRightPerBorder);
                anglesPerRegion.stdEdgeLengthCentralRegion = std(edgesLengthCentralRegionPerBorder);
                
                anglesPerRegion = renameVariablesOfStructAddingSuffix(anglesPerRegion, num2str(round(ellipsoidInfo.bordersSituatedAt(numBorder)*100)), {'End', 'Central'});
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
