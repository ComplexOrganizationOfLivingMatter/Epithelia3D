function [tableVertices3D,cellVertices3D,tableTotalPairOfVert3D] = create3DCellsFromVertices(dataVertID,clusterOfNeighs,verticesInfoExtreme,nRand)

    maxNCell = max(cell2mat(cellfun(@(x) max(x),dataVertID(:,7),'UniformOutput',false)));
    
    cellsID=[dataVertID(:,7);clusterOfNeighs(:,3);verticesInfoExtreme(:,2)];
    coordVert=[mat2cell([vertcat(dataVertID{:,4}),vertcat(dataVertID{:,5}),vertcat(dataVertID{:,6})],ones(size(dataVertID,1),1),3);clusterOfNeighs(:,2);verticesInfoExtreme(:,1)];
    vertID=[dataVertID(:,3);clusterOfNeighs(:,1);verticesInfoExtreme(:,4)];
    numberOfRand=num2cell(ones(size(vertID,1),1)*nRand);
    totalVerticesInfo=[numberOfRand,vertID,coordVert,cellsID];
    
    tableVertices3D=cell2table(totalVerticesInfo,'VariableNames',{'nRand','vertID','vertCoord','cellsID'});
    
    cellVertices3D=cell(maxNCell,3);
    figure;
    c=[colormap(hsv(maxNCell/2));colormap(jet(maxNCell/2))];
    totalPairOfVert=[];
    for nCell = 1 : maxNCell
        
        vertPerCell=cellfun(@(x) ismember(nCell,x),tableVertices3D.cellsID);
        
        cellVertices3D{nCell,1}=nRand;
        cellVertices3D{nCell,2}=nCell;
        cellVertices3D{nCell,3}=tableVertices3D.vertID(vertPerCell);
        cellVertices3D{nCell,4}=tableVertices3D.vertCoord(vertPerCell,:);
        
        verticesID=cellVertices3D{nCell,3};
        verticesCoord=double([cellVertices3D{nCell,4}]);
        K = convhulln(verticesCoord);
        trisurf(K,verticesCoord(:,1),verticesCoord(:,2),verticesCoord(:,3),'FaceColor',c(nCell,:),'EdgeAlpha',0.05)
        hold on
        
        for nConn = 1:size(K,1)
            vertConn=verticesID(K(nConn,:));
            totalPairOfVert=[totalPairOfVert;vertConn(1),vertConn(2);vertConn(2),vertConn(3);vertConn(1),vertConn(3)];
        end
    end
    totalPairOfVert=unique(sort(totalPairOfVert,2),'rows');
    tableTotalPairOfVert3D=array2table([nRand*ones(size(totalPairOfVert,1),1),totalPairOfVert],'VariableNames',{'nRand','vert1','vert2'});
    cellVertices3D=cell2table(cellVertices3D(:,1:3),'VariableNames',{'nRand','cellID','vertID'});
end