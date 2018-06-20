function [verticesInfoExtreme]=connectVerticesIn3D(dataVertID,pairOfVerticesTotal,clusterOfNeighs,clusterOfNeighsAux,verticesInfoExtreme,verticesInfoExtremeAux)

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
    [pairOfVertices3DApical,verticesInfoExtreme,clusterOfNeighs]=joinSurfaceVertices(dataVertIDApical,clusterOfNeighs,clusterOfNeighsAux,verticesInfoExtreme,verticesInfoExtremeAux,dataVertIDApical{2,1});
    %join vertices basal
    [pairOfVertices3DBasal,verticesInfoExtreme,clusterOfNeighs]=joinSurfaceVertices(dataVertIDBasal,clusterOfNeighs,clusterOfNeighsAux,verticesInfoExtreme,verticesInfoExtremeAux,dataVertIDBasal{2,1});
    %join vertices apico-basal
    [pairOfVertices3DApicoBasal,verticesInfoExtreme]=joinVerticesApicoBasal(clusterOfNeighs,verticesInfoExtreme,verticesInfoExtremeAux);

    
    [pairOfVertices3DBorders]=joinBorderExtremes(dataVertIDApicalBord,dataVertIDBasalBord,verticesInfoExtreme);
    
    
end