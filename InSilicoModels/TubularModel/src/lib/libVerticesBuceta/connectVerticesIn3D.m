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
    dataVertIDBasal(:,3)=num2cell(cell2mat(dataVertIDBasal(:,3))+size(dataVertIDApical,1));

    %join vertices apical
    [pairOfVertices3DApical,verticesInfoExtreme,clusterOfNeighs]=joinSurfaceVertices(dataVertIDApical,clusterOfNeighs,clusterOfNeighsAux,verticesInfoExtreme,verticesInfoExtremeAux,dataVertIDApical{1,2});
    %join vertices basal
    [pairOfVertices3DBasal,verticesInfoExtreme,clusterOfNeighs]=joinSurfaceVertices(dataVertIDBasal,clusterOfNeighs,clusterOfNeighsAux,verticesInfoExtreme,verticesInfoExtremeAux,dataVertIDBasal{1,2});
    %join vertices apico-basal
    [pairOfVertices3DApicoBasal,verticesInfoExtreme]=joinVerticesApicoBasal(clusterOfNeighs,verticesInfoExtreme,verticesInfoExtremeAux);

    
    [pairOfVertices3DBorders]=joinBorderExtremes(dataVertIDApicalBord,dataVertIDBasalBord,verticesInfoExtreme);
    
    surfaceVertices=[cell2mat(dataVertIDApical(:,4:6));cell2mat(dataVertIDApicalBord(:,4:6));cell2mat(dataVertIDBasal(:,4:6));cell2mat(dataVertIDBasalBord(:,4:6))];
    scutoidVertices=vertcat(clusterOfNeighs{:,2});
    borderScutoidVertices=vertcat(verticesInfoExtreme{:,1});
    
    allVerticesIDWithCoord =[ surfaceVertices ; scutoidVertices ; borderScutoidVertices];
    allPairsOfVertices=[pairOfVertices3DApical; pairOfVertices3DApicoBasal];%[pairOfVertices3DApical;pairOfVertices3DBasal;pairOfVertices3DApicoBasal; pairOfVertices3DBorders];
    [row,~]=find(allPairsOfVertices==0);
    allPairsOfVertices(row,:)=[];
    figure;
    for i=1:size(allPairsOfVertices,1)
        
        X= [allVerticesIDWithCoord(allPairsOfVertices(i,1),1),allVerticesIDWithCoord(allPairsOfVertices(i,2),1)];
        Y= [allVerticesIDWithCoord(allPairsOfVertices(i,1),2),allVerticesIDWithCoord(allPairsOfVertices(i,2),2)];
        Z= [allVerticesIDWithCoord(allPairsOfVertices(i,1),3),allVerticesIDWithCoord(allPairsOfVertices(i,2),3)];
        plot3(X,Y,Z,'-','LineWidth',0.5,'Color',[1 0 1])
        hold on
        
    end
    
    
end