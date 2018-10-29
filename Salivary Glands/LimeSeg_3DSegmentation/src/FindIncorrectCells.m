function [IncorrectCells]=FindIncorrectCells(neighbours_data)

total_neighbours=sum(length(neighbours_data));
IncorrectCells = isempty(find(total_neighbours < 3 | total_neighbours > 10));
end 