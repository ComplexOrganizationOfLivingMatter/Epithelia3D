function [neighs_real,sides_cells]=calculateNeighboursDelaunay(TRI)

    totalCells = unique(TRI)';
    neighs_real = cell(1, max(totalCells));
    sides_cells = zeros(1, max(totalCells));

    for nCell = totalCells
        
        isMemb = ismember(TRI,nCell);
        triCell = sum(isMemb,2)>0;
        
        cellsNeigh = unique(TRI(triCell,:));
        cellsNeigh = cellsNeigh(cellsNeigh~=nCell);
        
        neighs_real{nCell} = cellsNeigh;
        sides_cells(nCell) = length(cellsNeigh);

    end
        
end