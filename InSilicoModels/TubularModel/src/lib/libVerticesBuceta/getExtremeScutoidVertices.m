function verticesInfoExtremes = getExtremeScutoidVertices(img3DfinalDown,img3DfinalUp,reductionFactor,H_initial,clusterOfNeighs,centerImage)

    %get scutoids vertices in the extreme region
    [neighDown,~]=calculateNeighbours(img3DfinalDown);
    [neighUp,~]=calculateNeighbours(img3DfinalUp);
    [verticesInfoDown] = calculateVertices(img3DfinalDown,neighDown);
    verticesInfoDown.verticesPerCell=cellfun(@(x) [x*reductionFactor,1],verticesInfoDown.verticesPerCell,'UniformOutput',false);
    [verticesInfoUp] = calculateVertices(img3DfinalUp,neighUp);
    verticesInfoUp.verticesPerCell=cellfun(@(x) [x*reductionFactor,H_initial],verticesInfoUp.verticesPerCell,'UniformOutput',false);
    
    idMaxScuVert=max(cell2mat(clusterOfNeighs(:,1)));

    verticesPerCellExtreme=[verticesInfoDown.verticesPerCell(:);verticesInfoUp.verticesPerCell(:)];
    sizeVertExtreme=size(verticesPerCellExtreme,1);
    verticesConnectCellExtreme=mat2cell([verticesInfoDown.verticesConnectCells(:,:);verticesInfoUp.verticesConnectCells(:,:)],ones(sizeVertExtreme,1),3);
    radiusVerticesExtreme=cellfun(@(x) pdist2(x(1:2),centerImage),verticesPerCellExtreme,'UniformOutput',false);
    idVerticesExtremes=num2cell(idMaxScuVert+1:idMaxScuVert+sizeVertExtreme)';
    verticesInfoExtremes=[verticesPerCellExtreme,verticesConnectCellExtreme,radiusVerticesExtreme,idVerticesExtremes];
    


end
