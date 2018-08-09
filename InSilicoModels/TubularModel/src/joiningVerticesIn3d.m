function id3dJoin=joiningVerticesIn3d(dataVertID, tipCells)

    radiusCyl=vertcat(dataVertID{:,2});
    radiusCylUniq=unique(radiusCyl);
    intermediateRadius=radiusCyl==radiusCylUniq(end-1);
    minorRadius=radiusCyl==radiusCylUniq(1);
    majorRadius=radiusCyl==radiusCylUniq(end);

    verticesOfTipCells = cellfun(@(x) any(ismember(x, tipCells)), dataVertID(:, 7));
    
    vertIds=vertcat(dataVertID{:,3});
    cellsVert=vertcat(dataVertID(:,end));
    vertIdsInter=vertcat(dataVertID{intermediateRadius,3});
    cellsVertInter=vertcat(dataVertID(intermediateRadius,end));
    zCoordInter = vertcat(dataVertID(intermediateRadius, 6));

    id3dJoin=[];
    for nVert=find(minorRadius)'
        id2Join=cellfun(@(x) sum(ismember(cellsVert{nVert},x))>2,cellsVertInter);
        id3dJoin= [id3dJoin; vertIdsInter(id2Join),ones(sum(id2Join),1).*vertIds(nVert)];
    end

    for nVert=find(majorRadius)'
        if verticesOfTipCells(nVert)
            id2Join=cellfun(@(x) sum(ismember(cellsVert{nVert},x))>2,cellsVertInter);
            newVertices = vertIdsInter(id2Join);
            if sum(id2Join) < 1
                id2Join=cellfun(@(x) sum(ismember(cellsVert{nVert},x))>1, cellsVertInter);
                realIdsVertices = vertIdsInter(id2Join);
                possibleVertices = cell2mat(dataVertID(realIdsVertices, 4:6));
                distancesToVertex = pdist2(cell2mat(dataVertID(nVert, 4:6)), possibleVertices);
                [minNumber] = min(distancesToVertex);
                idsMinNumber = minNumber == distancesToVertex;
                newVertices = realIdsVertices(idsMinNumber);
            end
            id3dJoin= [id3dJoin; newVertices, ones(length(newVertices),1).*vertIds(nVert)];
        else
            id2Join=cellfun(@(x) sum(ismember(cellsVert{nVert},x))>2,cellsVertInter);
            id3dJoin= [id3dJoin; vertIdsInter(id2Join),ones(sum(id2Join),1).*vertIds(nVert)];
        end
    end

    vertIdsEnd=vertcat(dataVertID{majorRadius & verticesOfTipCells,3});
    cellsVertEnd=vertcat(dataVertID(majorRadius & verticesOfTipCells, end));
    zCoordEnd = vertcat(dataVertID(majorRadius & verticesOfTipCells, 6));

    for nVert = find(minorRadius & verticesOfTipCells)'
        id2Join=cellfun(@(x, y) sum(ismember(cellsVert{nVert},x))>1 & dataVertID{nVert,6} == y, cellsVertEnd, zCoordEnd);
        id3dJoin= [id3dJoin; vertIdsEnd(id2Join),ones(sum(id2Join),1).*vertIds(nVert)];
    end

    disp('');
end