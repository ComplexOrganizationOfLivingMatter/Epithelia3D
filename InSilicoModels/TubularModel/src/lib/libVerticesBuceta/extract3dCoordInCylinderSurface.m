function [dataVertID,pairOfVerticesTotal,verticesInfo,verticesNoValidCellsInfo]=extract3dCoordInCylinderSurface(L_img,dataVertID,pairOfVerticesTotal,nRand,radiusMaxCylinder, surfaceRatioToExtrapolateVertices)

    [~,W]=size(L_img);
    [neighs,~] = calculateNeighbours(L_img);
    [verticesInfo] = calculateVertices(L_img,neighs);
    [ verticesNoValidCellsInfo ] = getVerticesBorderNoValidCells(L_img );

    if exist('surfaceRatioToExtrapolateVertices', 'var') == 1
        W = round(W*surfaceRatioToExtrapolateVertices);
        verticesInfo.verticesPerCell = cellfun(@(x) round(x .* [1, surfaceRatioToExtrapolateVertices]), verticesInfo.verticesPerCell, 'UniformOutput', false);
        verticesNoValidCellsInfo.verticesPerCell = cellfun(@(x) round(x .* [1, surfaceRatioToExtrapolateVertices]), verticesNoValidCellsInfo.verticesPerCell, 'UniformOutput', false);
    end

    radius=W/(2*pi);
    totalVert=cell2mat([verticesInfo.verticesPerCell;verticesNoValidCellsInfo.verticesPerCell]);
    totalCellsPerVertex=[mat2cell(verticesInfo.verticesConnectCells,ones(1,size(verticesInfo.verticesConnectCells,1))...
        ,size(verticesInfo.verticesConnectCells,2));verticesNoValidCellsInfo.verticesConnectCells];

    %% vertices relocated in Cylinder 3D position: x=R*cos(angle); y=R*sin(angle);
    angleOfSeedsLocation=(360/W)*totalVert(:,2);
    %final location of seeds in basal region
    vert3D.x=round(radius*cosd(angleOfSeedsLocation))+radiusMaxCylinder+1;
    vert3D.y=round(radius*sind(angleOfSeedsLocation))+radiusMaxCylinder+1;
    vert3D.z=round(totalVert(:,1));
    vertID=[1:length(vert3D.x)]+size(dataVertID,1);
    dataVertID=[dataVertID;[num2cell([nRand*ones(length(vert3D.x),1), radius*ones(length(vert3D.x),1),vertID', vert3D.x,vert3D.y,vert3D.z]),totalCellsPerVertex]];
    
     %% vertices in contact
    pairOfVertices=cell(length(vert3D.x),1);
    nOfvertNoValidCells=length(verticesNoValidCellsInfo.verticesPerCell);
    for nVert = 1:length(vert3D.x)
        cellsOfVertice = totalCellsPerVertex{nVert};
        if nVert<=length(vert3D.x)-nOfvertNoValidCells
            verticesID = find(cellfun(@(x) sum(ismember(cellsOfVertice,x))>1, totalCellsPerVertex(1:end-nOfvertNoValidCells)));
        else
            verticesID = find(cellfun(@(x) sum(ismember(cellsOfVertice,x))>=1, totalCellsPerVertex(end-nOfvertNoValidCells+1:end)))+length(vert3D.x)-nOfvertNoValidCells;
        end
        pairOfVertices{nVert} = [nVert*ones(length(verticesID)-1,1),verticesID(verticesID~=nVert)];  
    end
    pairOfVertices=cell2mat(pairOfVertices);
    orderedPairOfVertices=[min(pairOfVertices,[],2),max(pairOfVertices,[],2)];
    uniquePairOfVertices=unique(orderedPairOfVertices,'rows');
    if ~isempty(pairOfVerticesTotal)
        uniquePairOfVertices=uniquePairOfVertices+ max(max(vertcat(pairOfVerticesTotal{:,1:2})));
    end
    pairOfVerticesTotal=[pairOfVerticesTotal;num2cell(uniquePairOfVertices),num2cell([nRand*ones(size(uniquePairOfVertices,1),1),radius*ones(size(uniquePairOfVertices,1),1)])];
    
    disp('1 - Vertices in contact')

end