function connectVertices(verticesInfo,radius,centers)

        totalVert=verticesInfo.verticesPerCell;
        totalCellsPerVertex=mat2cell(verticesInfo.verticesConnectCells,ones(1,size(verticesInfo.verticesConnectCells,1))...
            ,size(verticesInfo.verticesConnectCells,2));

        %%vertices in contact
        pairOfVertices=cell(size(verticesInfo.verticesConnectCells,1),1);
        for nVert = 1:size(totalVert,1)
            cellsOfVertice = totalCellsPerVertex{nVert};
            verticesID = find(cellfun(@(x) sum(ismember(cellsOfVertice,x))>1, totalCellsPerVertex(1:end))==1);
            pairOfVertices{nVert} = [nVert*ones(length(verticesID)-1,1),verticesID(verticesID~=nVert)];  
        end
        pairOfVertices=vertcat(pairOfVertices{:});
        orderedPairOfVertices=[min(pairOfVertices,[],2),max(pairOfVertices,[],2)];
        uniquePairOfVertices=unique(orderedPairOfVertices,'rows');

        tableVerticesConnection=array2table(uniquePairOfVertices,'VariableNames',{'vertice1','vertice2'});
        tableVerticesCoord=array2table([[1:size(totalVert,1)]',totalVert(:,1),totalVert(:,2),totalVert(:,3)],'VariableNames',{'verticeID','coordX','coordY','coordZ'});
        
        %get 3D plot, vertices connections
        figure
        for nVert = 1:size(uniquePairOfVertices,1)
            vert1=uniquePairOfVertices(nVert,1);
            vert2=uniquePairOfVertices(nVert,2);
            try
                plot3([totalVert(vert1,1),totalVert(vert2,1)],[totalVert(vert1,2),totalVert(vert2,2)],[totalVert(vert1,3),totalVert(vert2,3)],'-')
                hold on
            catch
                
            end
        end
        
        %get 2D vertices
        [tableVerticesConnection2D,tableVerticesCoord2D]=extrapolateVerticesCyl2D(tableVerticesConnection,tableVerticesCoord,centers,radius);
            
        %get 2D plot        
        figure;
        hold on
        radiusAverage=round(mean(vertcat(radius{:})));
        for nConn = 1:size(tableVerticesConnection2D,1)
            x1=tableVerticesCoord2D.coordX(tableVerticesConnection2D.vertice1(nConn));
            y1=tableVerticesCoord2D.coordY(tableVerticesConnection2D.vertice1(nConn));
            x2=tableVerticesCoord2D.coordX(tableVerticesConnection2D.vertice2(nConn));
            y2=tableVerticesCoord2D.coordY(tableVerticesConnection2D.vertice2(nConn));

            D = pdist2([x1,y1],[x2,y2]);

            if D < (2*pi*radiusAverage/2)
                plot([x1,x2],[y1,y2],'-','LineWidth',2) 
            else
                if x1>x2
                    plot([x1,x2+2*pi*radiusAverage],[y1,y2],'-','LineWidth',2)
                    plot([x1-2*pi*radiusAverage,x2],[y1,y2],'-','LineWidth',2) 
                else
                    plot([x1+2*pi*radiusAverage,x2],[y1,y2],'-','LineWidth',2) 
                    plot([x1,x2-2*pi*radiusAverage],[y1,y2],'-','LineWidth',2)
                end
            end
        end
        axis equal
        
end