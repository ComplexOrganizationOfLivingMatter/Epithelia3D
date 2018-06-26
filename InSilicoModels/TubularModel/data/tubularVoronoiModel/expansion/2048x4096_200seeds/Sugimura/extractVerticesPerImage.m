addpath(genpath('..\..\..\..\..\src'))

listImages=dir('**/*voronoi*1.tif');
vertInitial={};
surfaceRatios=[1.6667,5];

for nImg=1:size(listImages,1)
    nameImage=listImages(nImg).name;
    folderImage=listImages(nImg).folder;
    
    splImage=strsplit(nameImage,'_');

    img = imread([folderImage '\' nameImage]); 
    L_img = bwlabel(img);
    [neighs,~] = calculateNeighbours(L_img);
    [verticesInfo] = calculateVertices(L_img,neighs);
    [ verticesNoValidCellsInfo ] = getVerticesBorderNoValidCells(L_img );

    totalVert=cell2mat([verticesInfo.verticesPerCell;verticesNoValidCellsInfo.verticesPerCell]);
    totalCellsPerVertex=[mat2cell(verticesInfo.verticesConnectCells,ones(1,size(verticesInfo.verticesConnectCells,1))...
        ,size(verticesInfo.verticesConnectCells,2));verticesNoValidCellsInfo.verticesConnectCells];
    
    %%vertices in contact
    pairOfVertices=cell(size(verticesInfo.verticesConnectCells,1),1);
    nOfvertNoValidCells=size([verticesNoValidCellsInfo.verticesConnectCells],1);
    for nVert = 1:size(totalVert,1)
        cellsOfVertice = totalCellsPerVertex{nVert};
        if nVert <= size(verticesInfo.verticesPerCell,1)
            verticesID = find(cellfun(@(x) sum(ismember(cellsOfVertice,x))>1, totalCellsPerVertex(1:end))==1);
        else
            verticesID = find(cellfun(@(x) sum(ismember(cellsOfVertice,x))>=1, totalCellsPerVertex(end-nOfvertNoValidCells+1:end))==1)+size(totalVert,1)-nOfvertNoValidCells;
        end
        pairOfVertices{nVert} = [nVert*ones(length(verticesID)-1,1),verticesID(verticesID~=nVert)];  
    end
    pairOfVertices=cell2mat(pairOfVertices);
    orderedPairOfVertices=[min(pairOfVertices,[],2),max(pairOfVertices,[],2)];
    uniquePairOfVertices=unique(orderedPairOfVertices,'rows');
    
    tableVerticesConnection=array2table(pairOfVertices,'VariableNames',{'vertice1','vertice2'});
    tableVerticesCoord=array2table([[1:size(totalVert,1)]',totalVert(:,2),totalVert(:,1)],'VariableNames',{'verticeID','coordX','coordY'});
    
%     figure;
%     for nConn = 1:size(tableVerticesConnection,1)
%         x1=tableVerticesCoord.coordX(tableVerticesConnection.vertice1(nConn));
%         x2=tableVerticesCoord.coordX(tableVerticesConnection.vertice2(nConn));
%         y1=tableVerticesCoord.coordY(tableVerticesConnection.vertice1(nConn));
%         y2=tableVerticesCoord.coordY(tableVerticesConnection.vertice2(nConn));
%        plot([x1,x2],[y1,y2],'-') 
%        hold on
%     end
    
    if strcmp(splImage{2},'1.tif')
        nRand=str2double(splImage{1}(8:end));
        vertInitial(nRand,1:3)={tableVerticesCoord,tableVerticesConnection,folderImage};
    end
        
%     writetable(tableVerticesConnection,[folderImage '\connectionsVertices_' strrep(nameImage,'.tif','.xls')])
%     writetable(tableVerticesCoord,[folderImage '\coordinatesVertices_' strrep(nameImage,'.tif','.xls')])
end

for nFrusta=1:size(vertInitial,1)
    
    tableVerticesCoord=vertInitial{nFrusta,1};
    tableVerticesConnection=vertInitial{nFrusta,2};
    folderImage=vertInitial{nFrusta,3};
    for nSurf = 1:length(surfaceRatios)
        tableVerticesCoordAux=tableVerticesCoord;
        tableVerticesCoordAux.coordX=round(tableVerticesCoordAux.coordX*surfaceRatios(nSurf));
        
        writetable(tableVerticesConnection,[strrep(folderImage,'initialFrames','frusta') '\connectionsVertices_Frusta' num2str(nFrusta) '_' strrep(num2str(surfaceRatios(nSurf)),'.','') '.xls'])
        writetable(tableVerticesCoordAux,[strrep(folderImage,'initialFrames','frusta') '\coordinatesVertices_Frusta' num2str(nFrusta) '_' strrep(num2str(surfaceRatios(nSurf)),'.','') '.xls'])
        
    end
end