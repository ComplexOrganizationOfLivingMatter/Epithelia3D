function lookFor4cellsJunctionsAndExportTheExcel(pathFile)

    pathSplitted = strsplit(pathFile, '\');
    dir2save = strcat(strjoin(pathSplitted(1:end-2), '\'),'\verticesSamira\');   
    nameOfSimulation = pathSplitted{end-1};
    nameSplitted = strsplit(nameOfSimulation, '_');

    voronoiTable = readtable(strcat(dir2save, '\Voronoi_realization', nameSplitted{2} ,'_samirasFormat_', date, '.xls'));
    frustaTable = readtable(strcat(dir2save, '\Frusta_realization', nameSplitted{2} ,'_samirasFormat_', date, '.xls'));

    voronoiSR=unique(voronoiTable.Radius);   
    
    
    cellVerticesRep=cell(size(voronoiTable,1),1);
    for SR = voronoiSR'
        
        indSR = find(voronoiTable.Radius==SR);
        cellIDs = voronoiTable.CellIDs(indSR);
        
        coordX = vertcat(table2cell(voronoiTable(:,5:2:end)));
        coordX = [coordX{:}]';
        coordY = vertcat(table2cell(voronoiTable(:,6:2:end)));
        coordY = [coordY{:}]';
        coordXY = [coordX,coordY];
        uniqueXY = unique(coordXY,'rows');
        numRepet = arrayfun(@(x,y) sum(ismember(coordXY,[x y],'rows')),uniqueXY(:,1),uniqueXY(:,2));
        crossesVert = ismember(coordXY,uniqueXY(numRepet>3,:),'rows') & ~isnan(coordXY(:,1));
        crossesPos = find(crossesVert);
        nRowTable = mod(crossesPos,length(indSR))+1;
        verticesCrosses = coordXY(crossesVert,:);
        
        for nRow = 1:length(indSR)
            
            if sum(nRowTable==nRow)>0
                cellVerticesRep{indSR(nRow)}=verticesCrosses(nRowTable==nRow,:);
            end
            
        end        
        
        
    end

end