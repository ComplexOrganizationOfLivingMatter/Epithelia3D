function  [clusterOfNeighs,verticesInfoDown,verticesInfoUp]=calculateVerticesOfScutoids(img3Dfinal,image3DInfo,reductionFactor,dataVertID,H_initial)

    
    centerImage=[round(size(img3Dfinal,1)/2),round(size(img3Dfinal,2)/2)]*reductionFactor;
    %get scutoids vertices along the apicoBasal axis
    clusterOfNeighs = buildClustersOfNeighs3D(image3DInfo,reductionFactor,centerImage);
    cross2Delete=abs(cell2mat(clusterOfNeighs(:,3))-max([dataVertID{:,2}])) < 80;
    clusterOfNeighs(cross2Delete,:)=[];

    %get scutoids vertices in the extreme region
    [neighDown,~]=calculateNeighbours(img3Dfinal(:,:,1));
    [neighUp,~]=calculateNeighbours(img3Dfinal(:,:,end));
    [verticesInfoDown] = calculateVertices(img3Dfinal(:,:,1),neighDown);
    verticesInfoDown.verticesPerCell=cellfun(@(x) [x*reductionFactor,1],verticesInfoDown.verticesPerCell,'UniformOutput',false);
    [verticesInfoUp] = calculateVertices(img3Dfinal(:,:,end),neighUp);
    verticesInfoUp.verticesPerCell=cellfun(@(x) [x*reductionFactor,H_initial],verticesInfoUp.verticesPerCell,'UniformOutput',false);

end