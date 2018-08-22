function connectVertices(name,verticesInfoLayer1,verticesInfoLayer2,rangeY)
    
    

    load(['data\' name '\maskLayers\certerAndRadiusPerZ.mat'],'centers','radiiBasalLayer1','radiiApicalLayer1','radiiBasalLayer2','radiiApicalLayer2');
    setOfVertices={verticesInfoLayer1.Outer,verticesInfoLayer1.Inner,verticesInfoLayer2.Outer,verticesInfoLayer2.Inner};
    setOfRadii={radiiBasalLayer1,radiiApicalLayer1,radiiBasalLayer2,radiiApicalLayer2};
    
    for nSet = 1:length(setOfVertices)
        
        radius=setOfRadii{nSet};
        verticesInfo=setOfVertices{nSet};
        totalVert=cell2mat([verticesInfo.verticesPerCell]);
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

        tableVerticesConnection=array2table(pairOfVertices,'VariableNames',{'vertice1','vertice2'});
        tableVerticesCoord=array2table([[1:size(totalVert,1)]',totalVert(:,1),totalVert(:,2),totalVert(:,3)],'VariableNames',{'verticeID','coordX','coordY','coordZ'});

        [tableVerticesConnection2D,tableVerticesCoord2D]=extrapolateVerticesCyl2D(tableVerticesConnection,tableVerticesCoord,centers,rangeY,radius);
            
%             totalCells=unique(vertcat(totalCellsPerVertex{:}));
%             cellMax=max(max(vertcat(totalCellsPerVertex{:})));
%             colours = jet(double(cellMax));
%             colours = colours(randperm(cellMax), :);
%             cellVertices3D=cell(cellMax,3);
%             for nCell = 1 : cellMax
%                 if ismember(nCell,totalCells)
%                     vertPerCell=cellfun(@(x) ismember(nCell,x),totalCellsPerVertex);
% 
%                     cellVertices3D{nCell,1}=tableVerticesCoord.verticeID(vertPerCell,1);
%                     cellVertices3D{nCell,2}=[tableVerticesCoord.coordX(vertPerCell),tableVerticesCoord.coordY(vertPerCell),tableVerticesCoord.coordZ(vertPerCell)];
%                     if size(cellVertices3D{nCell,2},1)>2
%                         verticesID=cellVertices3D{nCell,1};
%                         verticesCoord=double([cellVertices3D{nCell,2}]);
%                         if size(verticesCoord,1)==3
%                             K=[1,2,3];
%                         else
%                             K = convhulln(verticesCoord);
%                         end
%                         trisurf(K,verticesCoord(:,1),verticesCoord(:,2),verticesCoord(:,3),'FaceColor',colours(nCell,:),'EdgeAlpha',0.05)
%                         hold on
% 
%                         totalConn=cell(size(K,1),1);
%                         for nConn = 1:size(K,1)
%                             vertConn=verticesID(K(nConn,:));
%                             totalConn{nConn}=[vertConn([1 2])';vertConn([1 3])';vertConn([2 3])'];
%                         end
%                         cellVertices3D{nCell,3}=vertcat(totalConn{:});
%                     end
%                 end
%             end
            
        figure;
        hold on
        radiusAverage=round(mean(vertcat(radius{rangeY(1):rangeY(2)})));
        for nConn = 1:size(tableVerticesConnection2D,1)
            x1=tableVerticesCoord2D.coordX(tableVerticesConnection2D.vertice1(nConn));
%                 z1=tableVerticesCoord.coordZ(tableVerticesConnection.vertice1(nConn));
            y1=tableVerticesCoord2D.coordY(tableVerticesConnection2D.vertice1(nConn));
            x2=tableVerticesCoord2D.coordX(tableVerticesConnection2D.vertice2(nConn));
            y2=tableVerticesCoord2D.coordY(tableVerticesConnection2D.vertice2(nConn));
%                 z2=tableVerticesCoord.coordZ(tableVerticesConnection.vertice2(nConn));

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
end