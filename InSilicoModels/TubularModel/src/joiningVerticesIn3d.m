function id3dJoin=joiningVerticesIn3d(dataVertID)

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
     
     id2Join=cellfun(@(x) sum(ismember(cellsVert{nVert},x))==3,cellsVertInter);
     id3dJoin= [id3dJoin; vertIdsInter(id2Join),ones(sum(id2Join),1).*vertIds(nVert)];
 end
 
 for nVert=find(majorRadius)'
     
     id2Join=cellfun(@(x) sum(ismember(cellsVert{nVert},x))==3,cellsVertInter);
     id3dJoin= [id3dJoin; vertIdsInter(id2Join),ones(sum(id2Join),1).*vertIds(nVert)];
 end
    
end