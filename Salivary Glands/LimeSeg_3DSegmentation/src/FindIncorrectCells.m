function [IncorrectCells]=FindIncorrectCells(NeighboursData)

TotalNeighbours=sum(length(NeighboursData));
IncorrectCells = isempty(find(TotalNeighbours < 3 | TotalNeighbours > 10));
end 