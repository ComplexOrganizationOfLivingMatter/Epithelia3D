function [] = calculateVerticesConnectionHexagons(dir2save,listLOriginalProjection,initialSurfaceRatio,intermediateSurfaceRatio,basalSurfaceRatio,VoronoiOutput)
    %%calculateVerticesConnectionHexagons

    surfaceRatios=[initialSurfaceRatio,intermediateSurfaceRatio,basalSurfaceRatio];
    nRand=1;
    cellWithVertices={};
    dataVertID={};
    pairOfVerticesTotal={};

    %Voronoi or Frusta output
    if VoronoiOutput
        disp('---------------Voronoi results--------------');
        outputKind = 'Voronoi';
    else
        disp('---------------Frusta results --------------');
        outputKind = 'Frusta';
    end

    maxSurfaceRatio=max(surfaceRatios);
    L_imgMax=listLOriginalProjection.L_originalProjection{listLOriginalProjection.surfaceRatio==maxSurfaceRatio};
    Wmax=size(L_imgMax,2);
    RadiusMax=Wmax/(2*pi);

    for nSurfR=surfaceRatios

        L_img = listLOriginalProjection.L_originalProjection{round(listLOriginalProjection.surfaceRatio,3)==round(nSurfR,3)};
        L_img=[L_img(:,(end-round(size(L_img,2)/3)-1):end),L_img(:,1:(round(2*size(L_img,2)/3)))];
        
        if initialSurfaceRatio == nSurfR
            initialL_img = L_img;
            borderCells = unique([unique(L_img(:,1:2));unique(L_img(:,(end-1):end))]);
           [dataVertID,pairOfVerticesTotal,verticesInfo,verticesNoValidCellsInfo]=extract3dCoordInCylinderSurface(initialL_img,dataVertID,pairOfVerticesTotal,nRand,RadiusMax);
            
        else
            if VoronoiOutput
                %We get the L_img from earlier steps
                [dataVertID,pairOfVerticesTotal,verticesInfo,verticesNoValidCellsInfo]=extract3dCoordInCylinderSurface(L_img,dataVertID,pairOfVerticesTotal,nRand,RadiusMax, nSurfR/initialSurfaceRatio);
            else
                L_img = imresize(initialL_img,[size(initialL_img,1),round(size(initialL_img,2)*(nSurfR/initialSurfaceRatio))],'nearest');
                
                BWdst = bwdist(L_img);
                waterImg = watershed(BWdst);
                mask = waterImg;
                for nLab = 1:max(waterImg(:)) 
                    [x,y] = find(waterImg == nLab);
                    meanVal = round(mean([x,y]));
                    mask(waterImg == nLab) = L_img(meanVal(1),meanVal(2)) ;
                end
                L_img = double(mask);
                [dataVertID,pairOfVerticesTotal,verticesInfo,verticesNoValidCellsInfo]=extract3dCoordInCylinderSurface(L_img,dataVertID,pairOfVerticesTotal,nRand,RadiusMax, nSurfR/initialSurfaceRatio);
            end
        end
        %1- vertices located in Cylinder 3D position over the surface
        %2- vertices in contact over the surface
        %3- cells composed by N-vertices
        cellWithVertices = groupingVerticesPerCellSurface(L_img,verticesInfo,verticesNoValidCellsInfo,cellWithVertices,nRand,borderCells);
    end


    %% The same vertices as one
    [pairOfVerticesTotal] = unifyingDuplicatedVertices(dataVertID, pairOfVerticesTotal);
    
    %% Joining vertices in 3D
    tipCells = unique([verticesNoValidCellsInfo.verticesConnectCells{:}]);
    pairVertices3D=joiningVerticesIn3d(dataVertID, tipCells);
    
    radiusCyl=vertcat(dataVertID{:,2});

    pairTotalVertices = [[vertcat(pairOfVerticesTotal{:,1}),vertcat(pairOfVerticesTotal{:,2})];pairVertices3D];

    cellsVerts=cell(max(L_img(:)),2);
    for nCell=1:max(L_img(:))

        idVertsPerCell=cellfun(@(x) ismember(nCell,x), dataVertID(:,end));

        cellsVerts(nCell,1)={nCell};
        cellsVerts(nCell,2)={find(idVertsPerCell)'};

    end

    dataVertID = dataVertID(:,2:end);  

    %% Deleting junction intermediate layer
    [pairTotalVertices] = deleteJunctionIntermediateLayer(dataVertID,pairTotalVertices);

    %% Removing the vertices that are irrelevant
    % We created a line between each pair of vertices and see if any other
    % vertex overlap with this line.
    thresholdDistance = 3;
    verticesToDelete = [];
    newUnions = [];
    for numCell = 1:size(cellsVerts, 1)
        verticesOfACellIds = cellsVerts{numCell, 2};   

        %Possible pair of vertices we could remove
        actualPairOfVertices = pairTotalVertices(all(ismember(pairTotalVertices, verticesOfACellIds), 2), :);

        for initialNumVertex = verticesOfACellIds
            pairOfVerticesToAnalyse = actualPairOfVertices(any(ismember(actualPairOfVertices, initialNumVertex), 2), :);
            vertexNeighbours = unique(pairOfVerticesToAnalyse)';
            vertexNeighbours(vertexNeighbours == initialNumVertex) = [];

            for numVertexNeigh = vertexNeighbours
                pairOfVerticesNeighs = actualPairOfVertices(any(ismember(actualPairOfVertices, numVertexNeigh), 2), :);
                endVertices = unique(pairOfVerticesNeighs)';
                endVertices(ismember(endVertices, [initialNumVertex numVertexNeigh])) = [];
                if isempty(endVertices) == 0
                    for endVertexCont = 1:size(endVertices, 2)
                        endNumVertex = endVertices(endVertexCont);
                        initialVertex = cell2mat(dataVertID(initialNumVertex, 3:5));
                        intermediateVertex = cell2mat(dataVertID(numVertexNeigh, 3:5)); 
                        endVertex = cell2mat(dataVertID(endNumVertex, 3:5));
                        [linePoints] = line3D(initialVertex, endVertex);
                        if min(pdist2(intermediateVertex, linePoints)) < thresholdDistance
                            %plot3(intermediateVertex(:, 1), intermediateVertex(:, 2), intermediateVertex(:, 3), '*')
                            verticesToDelete(end+1) = numVertexNeigh;
                            newUnions(end+1, :) = [initialNumVertex, endNumVertex];
                        end
                    end
                end
            end
        end
    end

    verticesToDelete = verticesToDelete';
    [verticesToDelete, ids] = unique(verticesToDelete);
    newUnions = newUnions(ids, :);

    for removingVertex = 1:size(verticesToDelete, 1)
        newThresome = [verticesToDelete(removingVertex) newUnions(removingVertex, :)];
        pairTotalVertices(all(ismember(pairTotalVertices, newThresome), 2), :) = [];
        pairTotalVertices(end+1, :) = newUnions(removingVertex, :);
    end
    cellsVerts(:, 2) = cellfun(@(x) x(ismember(x, verticesToDelete) == 0), cellsVerts(:, 2), 'UniformOutput', false);
    dataVertID(verticesToDelete, :) = [];
    
    %% Connecting correctly the tip cells
    pairTotalVertices = connectVerticesOfTipCells(tipCells, pairTotalVertices, dataVertID, cellsVerts);
    
    [pairTotalVertices] = deleteJunctionIntermediateLayer(dataVertID,pairTotalVertices);
    
    %% Storing data
    cellVerticesTable=cell2table(cellsVerts,'VariableNames',{'cellIDs','verticesIDs'});
    pairOfVerticesTable=array2table(pairTotalVertices,'VariableNames',{'verticeID1','verticeID2'});
    vertices3dTable=cell2table(dataVertID,'VariableNames',{'radius','verticeID','coordX','coordY','coordZ','cellIDs'});

    %% Visualizing the model
   
    tipCellsAndItsVertices = {};
    
    colours = colorcube(200);
    colours = repmat(colours, 2200/200, 1);
    for numCell = 1:size(cellsVerts, 1)
        verticesToShowIDs = cellsVerts{numCell, 2};
        
        vertexIndices = ismember(vertices3dTable.verticeID, verticesToShowIDs);
        if ismember(numCell, tipCells) == 0
            shapeCell = alphaShape(vertices3dTable.coordX(vertexIndices), vertices3dTable.coordY(vertexIndices), vertices3dTable.coordZ(vertexIndices), Inf);
            plot(shapeCell, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none');
            hold on
            plot3(vertices3dTable.coordX(vertexIndices), vertices3dTable.coordY(vertexIndices), vertices3dTable.coordZ(vertexIndices),'*')
            hold on
        else
            tipCellsAndItsVertices(end+1, :) = {numCell, find(vertexIndices)};
        end
    end
    
    figure;
    hold on;

    verticesToShowIDs = cellsVerts{33, 2};
    
    for nPair=size(pairOfVerticesTable,1):-1:1
        if ismember(pairOfVerticesTable.verticeID1(nPair), verticesToShowIDs) && ismember(pairOfVerticesTable.verticeID2(nPair), verticesToShowIDs)
            x1=vertices3dTable.coordX(vertices3dTable.verticeID == pairOfVerticesTable.verticeID1(nPair));
            y1=vertices3dTable.coordY(vertices3dTable.verticeID == pairOfVerticesTable.verticeID1(nPair));
            z1=vertices3dTable.coordZ(vertices3dTable.verticeID == pairOfVerticesTable.verticeID1(nPair));
            x2=vertices3dTable.coordX(vertices3dTable.verticeID == pairOfVerticesTable.verticeID2(nPair));
            y2=vertices3dTable.coordY(vertices3dTable.verticeID == pairOfVerticesTable.verticeID2(nPair));
            z2=vertices3dTable.coordZ(vertices3dTable.verticeID == pairOfVerticesTable.verticeID2(nPair));

            plot3([x1,x2],[y1,y2],[z1,z2])
            hold on;

        end
    end

    tipCellsAndItsVerticesTable = cell2table(tipCellsAndItsVertices,'VariableNames',{'cellIDs','verticesIDs'});
    
    %Export as Samira requested:
    % - .xls file
    % Each line would be like:
    % - Radius. Cell ID. Vertex1 (x, y). Vertex2 (x,y)...
    disp('Exporting');
%     apicalRadius = min(radiusCyl);
%     basalRadius = max(radiusCyl);
%     
%     samiraTable = {};
%     for numRadius = [apicalRadius, basalRadius]
%         verticesWithActualRadius = dataVertID([dataVertID{:, 1}] == numRadius, :);
%         actualVerticesIds = [verticesWithActualRadius{:, 2}];
%         
%         for numCell = 1:size(cellsVerts, 1)
%             verticesOfCell = cellsVerts{numCell, 2};
%             verticesOfCellWithActualRadius = verticesOfCell(ismember(verticesOfCell, actualVerticesIds));
%             
%             actualPairTotalVertices = pairTotalVertices(all(ismember(pairTotalVertices, verticesOfCellWithActualRadius), 2), :);
%             
%             % Should be connected clockwise
%             % I.e. from bigger numbers to smaller ones
%             % Or the second vertex should in the left hand of the first
%             
%             % \TODO refactor to use this function:
%             [newOrderX, newOrderY] = poly2cw(verticesOfCell(:, 1), verticesOfCell(:, 2));
%             
%             verticesRadius = dataVertID(ismember([dataVertID{:, 2}], newOrderOfVertices), 3:5)';
%             samiraTable(end+1, :) = {numRadius, numCell, [verticesRadius{:}]};
%         end
%     end
    mkdir([dir2save 'vertices\'])
    writetable(cellVerticesTable,[dir2save 'vertices\cellsWithVerticesIDs_' outputKind '_' date '.xls'])
    writetable(vertices3dTable,[dir2save 'vertices\tableVerticesCoordinates3D_' outputKind '_' date '.xls'])
    writetable(pairOfVerticesTable,[dir2save 'vertices\tableConnectionsOfVertices3D_' outputKind '_' date '.xls'])
    writetable(tipCellsAndItsVerticesTable,[dir2save 'vertices\tipCells_' outputKind '_' date '.xls'])
    
%     writetable(samiraTable,[dir2save 'vertices\samiraFormat_' outputKind '_' date '.xls'])
    
end

