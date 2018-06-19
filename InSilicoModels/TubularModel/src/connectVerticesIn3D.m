function connectVerticesIn3D(dataVertID,clusterOfNeighs,verticesInfoDown,verticesInfoUp)


    indVertApical=cell2mat(dataVertID(:,2))==min(cell2mat(dataVertID(:,2)));
    indVertBasal=cell2mat(dataVertID(:,2))==max(cell2mat(dataVertID(:,2)));

    dataVertIDApical=dataVertID(indVertApical,:);
    dataVertIDBasal=dataVertID(indVertBasal,:);
    indVertBordApical=cellfun(@(x) length(x)==2,dataVertIDApical(:,7));
    indVertBordBasal=cellfun(@(x) length(x)==2,dataVertIDBasal(:,7));
    dataVertIDApicalBord=dataVertIDApical(indVertBordApical,:);
    dataVertIDBasalBord=dataVertIDApical(indVertBordBasal,:);

    dataVertIDApical=dataVertIDApical(~indVertBordApical,:);
    dataVertIDBasal=dataVertIDBasal(~indVertBordBasal,:);

    for nVertApical=1:size(dataVertIDApical,1)
        vert2Join=dataVertIDApical(nVertApical,:);
        
        
    end
    
end