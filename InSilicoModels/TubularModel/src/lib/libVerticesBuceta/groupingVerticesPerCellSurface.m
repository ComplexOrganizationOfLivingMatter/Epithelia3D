function cellWithVertices = groupingVerticesPerCellSurface(L_img,verticesInfo,verticesNoValidCellsInfo,cellWithVertices,nRand)
    

    [~,W]=size(L_img);
    radius=W/(2*pi);
    %%Cells are formed by a set of vertices
    for nCell=1:max(max(L_img))
        [nRowValid,~,~]=find(verticesInfo.verticesConnectCells==nCell);
        [~,nRowNoValid,~]=find(horzcat(verticesNoValidCellsInfo.verticesConnectCells{:})==nCell);

        booleanNoValidCell=1 ;
        if isempty(nRowNoValid)
           booleanNoValidCell=0 ;
        end

        cellVertices= [verticesInfo.verticesPerCell(nRowValid,:);verticesNoValidCellsInfo.verticesPerCell(nRowNoValid)];

        vert=vertcat(cellVertices{:});                

        %checking border cells
        distBetwVert=pdist(vert);
        if any(distBetwVert > W/2)
            indRightBorder = vert(:,2) > W/2;
            vertRight = vert;
            vertLeft = vert;

            vertRight(~indRightBorder,2)=vert(~indRightBorder,2)+W;
            vertLeft(indRightBorder,2)=vert(indRightBorder,2)-W;

            row1={nRand radius nCell booleanNoValidCell 1 reshape(vertLeft.', 1, [])};
            row2={nRand radius nCell booleanNoValidCell 2 reshape(vertRight.', 1, [])};
            row=[row1;row2];
        else
            row={nRand radius nCell booleanNoValidCell 0 reshape(vert.', 1, [])};
        end
        cellWithVertices = [cellWithVertices;row];
    end
    
    disp('2 - Group of vertices per cell')
end
