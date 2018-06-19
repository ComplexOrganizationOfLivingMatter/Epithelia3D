function connectVerticesIn3D(dataVertID,clusterOfNeighs,verticesInfoDown,verticesInfoUp)

    %add id to scutoid vertices
    indexesScuVert=size(dataVertID,1)+1:size(dataVertID,1)+size(clusterOfNeighs,1);
    indexesScuVert=num2cell(indexesScuVert');
    clusterOfNeighs=[indexesScuVert,clusterOfNeighs];

    %differencing apical-basal-extremes
    indVertApical=cell2mat(dataVertID(:,2))==min(cell2mat(dataVertID(:,2)));
    indVertBasal=cell2mat(dataVertID(:,2))==max(cell2mat(dataVertID(:,2)));

    dataVertIDApical=dataVertID(indVertApical,:);
    dataVertIDBasal=dataVertID(indVertBasal,:);
    indVertBordApical=cellfun(@(x) length(x)==2,dataVertIDApical(:,7));
    indVertBordBasal=cellfun(@(x) length(x)==2,dataVertIDBasal(:,7));
    dataVertIDApicalBord=dataVertIDApical(indVertBordApical,:);
    dataVertIDBasalBord=dataVertIDBasal(indVertBordBasal,:);

    dataVertIDApical=dataVertIDApical(~indVertBordApical,:);
    dataVertIDBasal=dataVertIDBasal(~indVertBordBasal,:);

    %join vertices apical
    for nVertApical=1:size(dataVertIDApical,1)
        vert2Join=dataVertIDApical(nVertApical,:);
        vertId=vert2Join{3};
        cellsInVert=vert2Join{end};
        
        matchVert=cellfun(@(x) sum(ismember(cellsInVert,x))==3,clusterOfNeighs(:,2));
        indexesMatch=find(matchVert);
        [~,ind]=min(cell2mat(clusterOfNeighs(matchVert,4)));
        joinedVertices = [vertId indexesMatch(ind)];
        
    end
    
end