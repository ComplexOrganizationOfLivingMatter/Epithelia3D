function id3dJoin=joiningVerticesIn3d(dataVertID, tipCells)

    radiusCyl=vertcat(dataVertID{:,2});
    radiusCylUniq=unique(radiusCyl);
    intermediateRadius=radiusCyl==radiusCylUniq(end-1);
    minorRadius=radiusCyl==radiusCylUniq(1);
    majorRadius=radiusCyl==radiusCylUniq(end);

    vertIds=vertcat(dataVertID{:,3});
    cellsVert=vertcat(dataVertID(:,end));
    vertIdsInter=vertcat(dataVertID{intermediateRadius,3});
    cellsVertInter=vertcat(dataVertID(intermediateRadius,end));

    id3dJoin=[];
    for nVert=find(minorRadius)'
        id2Join=cellfun(@(x) sum(ismember(cellsVert{nVert},x))>2,cellsVertInter);
        id3dJoin= [id3dJoin; vertIdsInter(id2Join),ones(sum(id2Join),1).*vertIds(nVert)];
    end

    for nVert=find(majorRadius)'
        id2Join=cellfun(@(x) sum(ismember(cellsVert{nVert},x))>2,cellsVertInter);
        id3dJoin= [id3dJoin; vertIdsInter(id2Join),ones(sum(id2Join),1).*vertIds(nVert)];
    end

    verticesOfTipCells = cellfun(@(x) any(ismember(x, tipCells)), dataVertID(:, 7));

    vertIdsEnd=vertcat(dataVertID{majorRadius & verticesOfTipCells,3});
    cellsVertEnd=vertcat(dataVertID(majorRadius & verticesOfTipCells, end));
    zCoordEnd = vertcat(dataVertID(majorRadius & verticesOfTipCells, 6));

    for nVert = find(minorRadius & verticesOfTipCells)'
        id2Join=cellfun(@(x, y) sum(ismember(cellsVert{nVert},x))>1, cellsVertEnd, zCoordEnd);
        id3dJoin= [id3dJoin; vertIdsEnd(id2Join),ones(sum(id2Join),1).*vertIds(nVert)];
    end

    disp('');
end