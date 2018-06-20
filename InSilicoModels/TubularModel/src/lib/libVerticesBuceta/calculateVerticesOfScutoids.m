function  [clusterOfNeighs,clusterOfNeighsAux,verticesInfoExtremes,verticesInfoExtremesAux]=calculateVerticesOfScutoids(img3Dfinal,image3DInfo,reductionFactor,dataVertID,H_initial)

    resolutionIssue=80;
    
    centerImage=[round(size(img3Dfinal,1)/2),round(size(img3Dfinal,2)/2)]*reductionFactor;
    %get scutoids vertices along the apicoBasal axis
    clusterOfNeighs = buildClustersOfNeighs3D(image3DInfo,reductionFactor,centerImage);
    cross2Delete=abs(cell2mat(clusterOfNeighs(:,3))-max([dataVertID{:,2}])) < resolutionIssue;
    cross2DeleteAux=abs(cell2mat(clusterOfNeighs(:,3))-max([dataVertID{:,2}])) < resolutionIssue/2;
    clusterOfNeighsAux=clusterOfNeighs(~cross2DeleteAux,:);
    clusterOfNeighs(cross2Delete,:)=[];
    
    
    
    %add id to scutoid vertices
    indexesScuVert=size(dataVertID,1)+1:size(dataVertID,1)+size(clusterOfNeighs,1);
    idMaxScuVert=max(indexesScuVert);
    indexesScuVert=num2cell(indexesScuVert');
    clusterOfNeighs=[indexesScuVert,clusterOfNeighs];

    verticesInfoExtremes = getExtremeScutoidVertices(img3Dfinal(:,:,1),img3Dfinal(:,:,end),reductionFactor,H_initial,clusterOfNeighs,centerImage);
    
    cross2Delete=abs([verticesInfoExtremes{:,3}]-max([dataVertID{:,2}])) < resolutionIssue;
    verticesInfoExtremes(cross2Delete)=[];
    
    verticesInfoExtremesAux = getExtremeScutoidVertices(img3Dfinal(:,:,4),img3Dfinal(:,:,end-3),reductionFactor,H_initial,clusterOfNeighs,centerImage);
    cross2Delete=abs([verticesInfoExtremesAux{:,3}]-max([dataVertID{:,2}])) < resolutionIssue/2;
    verticesInfoExtremesAux(cross2Delete)=[];
    
end