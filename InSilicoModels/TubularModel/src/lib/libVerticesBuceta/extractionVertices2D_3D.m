function extractionVertices2D_3D%(pathFile,projectionType,imageType)
    projectionType='expansion';
    imageType='2048x4096_200seeds';
    pathFile=['D:\Pedro\Epithelia3D\InSilicoModels\TubularModel\data\tubularVoronoiModel\' projectionType '\' imageType '\'];

    listFolders=dir([pathFile 'Image_*']);
    addpath(genpath('src'))
    cellWithVertices={};
    dataVertID={};
    pairOfVerticesTotal={};
    for nRand=1:length(listFolders)
        load([pathFile 'Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listLOriginalProjection')
        for nSurfR = 1:length(listLOriginalProjection.L_originalProjection)
            %surfaceRatio = listLOriginalProjection.surfaceRatio(nSurfR);
            L_img = listLOriginalProjection.L_originalProjection{nSurfR};
            [~,W]=size(L_img);
            [neighs,~] = calculateNeighbours(L_img);
            [verticesInfo] = calculateVertices(L_img,neighs);
            [ verticesNoValidCellsInfo ] = getVerticesBorderNoValidCells(L_img );

            radius=W/(2*pi);
            totalVert=cell2mat([verticesInfo.verticesPerCell;verticesNoValidCellsInfo.verticesPerCell]);
            totalCellsPerVertex=[mat2cell(verticesInfo.verticesConnectCells,ones(1,size(verticesInfo.verticesConnectCells,1))...
                ,size(verticesInfo.verticesConnectCells,2));verticesNoValidCellsInfo.verticesConnectCells];

            %% vertices relocated in Cylinder 3D position: x=R*cos(angle); y=R*sin(angle);
            angleOfSeedsLocation=(360/W)*totalVert(:,2);
            %final location of seeds in basal region
            vert3D.x=round(radius*cosd(angleOfSeedsLocation))+radius+1;
            vert3D.y=round(radius*sind(angleOfSeedsLocation))+radius+1;
            vert3D.z=round(totalVert(:,1));
            vertID=1:length(vert3D.x);
            dataVertID=[dataVertID;[num2cell([nRand*ones(length(vert3D.x),1), radius*ones(length(vert3D.x),1),vertID', vert3D.x,vert3D.y,vert3D.z]),totalCellsPerVertex]];
            
            
            
            
            %% vertices in contact
            pairOfVertices=cell(length(vert3D.x),1);
            nOfvertNoValidCells=length(verticesNoValidCellsInfo.verticesPerCell);
            for nVert = 1:length(vert3D.x)
                cellsOfVertice = totalCellsPerVertex{nVert};
                if nVert<=length(vert3D.x)-nOfvertNoValidCells
                    verticesID = find(cellfun(@(x) sum(ismember(cellsOfVertice,x))>1, totalCellsPerVertex(1:end))==1);
                else
                    verticesID = find(cellfun(@(x) sum(ismember(cellsOfVertice,x))>=1, totalCellsPerVertex(end-nOfvertNoValidCells+1:end))==1)+length(vert3D.x)-nOfvertNoValidCells;
                end
                pairOfVertices{nVert} = [nVert*ones(length(verticesID)-1,1),verticesID(verticesID~=nVert)];  
            end
            pairOfVertices=cell2mat(pairOfVertices);
            orderedPairOfVertices=[min(pairOfVertices,[],2),max(pairOfVertices,[],2)];
            uniquePairOfVertices=unique(orderedPairOfVertices,'rows');
            pairOfVerticesTotal=[pairOfVerticesTotal;num2cell([uniquePairOfVertices,nRand*ones(size(uniquePairOfVertices,1),1),radius*ones(size(uniquePairOfVertices,1),1)])];
            
            
            
            
            %% Cells are formed by a set of vertices
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
        end
    end
    cellVerticesTable=cell2table(cellWithVertices,'VariableNames',{'nRand','radius','cellID','noValidCellID','borderCellID','vertX_Y'});
    pairOfVerticesTable=cell2table(pairOfVerticesTotal,'VariableNames',{'verticeID','nRand','radius'});
    vertices3dTable=cell2table(dataVertID,'VariableNames',{'nRand','radius','verticeID','vertX','vertY','vertZ'});

    writetable(cellVerticesTable,[projectionType '_' imageType '_tableVertices2D_' date '.xls'])
    writetable(vertices3dTable,[projectionType '_' imageType '_tableVertices3D_' date '.xls'])
    writetable(pairOfVerticesTable,[projectionType '_' imageType '_tableConnectionOfVertices3D_' date '.xls'])

end