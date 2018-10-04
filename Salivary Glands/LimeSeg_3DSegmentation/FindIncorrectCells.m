function [IncorrectCells]=FindIncorrectCells(NeighboursData)
TotalNeighbours=sum(length(NeighboursData));
IncorrectCellsInf = find(TotalNeighbours < 3); 
IncorrectCellsSup = find(TotalNeighbours > 10);
IncorrectCells=[IncorrectCellsInf IncorrectCellsSup];
end 