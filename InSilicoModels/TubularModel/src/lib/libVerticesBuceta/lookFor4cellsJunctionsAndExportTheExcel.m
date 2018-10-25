function newVoronoiCrossesTable = lookFor4cellsJunctionsAndExportTheExcel(voronoiTable)

%     pathSplitted = strsplit(pathFile, '\');
%     dir2save = strcat(strjoin(pathSplitted(1:end-2), '\'),'\verticesSamira\');   
%     nameOfSimulation = pathSplitted{end-1};
%     nameSplitted = strsplit(nameOfSimulation, '_');
    voronoiSR=unique(voronoiTable.Radius);   
    
    cellVerticesRep=cell(size(voronoiTable,1),1);
    for SR = voronoiSR'
        
        indSR = voronoiTable.Radius==SR;
        
        verticesOfCell = [voronoiTable{indSR, end}];
        
        coordX = cellfun(@(x) x(1:2:end-1), verticesOfCell, 'UniformOutput', false);
        coordX = [coordX{:}]';
        coordY = cellfun(@(x) x(2:2:end), verticesOfCell, 'UniformOutput', false);
        coordY = [coordY{:}]';
        coordXY = [coordX,coordY];
        uniqueXY = unique(coordXY,'rows');
        numRepet = arrayfun(@(x,y) sum(ismember(coordXY,[x y],'rows')),uniqueXY(:,1),uniqueXY(:,2));
        crossesVert = ismember(coordXY,uniqueXY(numRepet>3,:),'rows') & ~isnan(coordXY(:,1));
        
        if sum(crossesVert) > 0
            crossesPos = find(crossesVert);
            nRowTable = rem(crossesPos,sum(indSR));
            nRowTable(nRowTable==0) = sum(indSR);
            
            verticesCrosses = coordXY(crossesVert,:);
            
            indSR = find(indSR);
            for nRow = 1:length(indSR)
                if sum(nRowTable==nRow)>0
                    vertRow = verticesCrosses(nRowTable==nRow,:);
                    cellVerticesRep{indSR(nRow)} = reshape(vertRow',[1,numel(vertRow)]);
                end
            end
        end
    end
    
    newVoronoiCrossesTable = voronoiTable(:,1:4);
    verticesRepeated = cell2table(cellVerticesRep,'VariableNames',{'verticesValues_x_y'});
    newVoronoiCrossesTable = [newVoronoiCrossesTable,verticesRepeated];
end