function [ rowInfo ] = createExcel( ellipsoidInfo, exchangeNeighboursPerCell )
%CREATEEXCEL Summary of this function goes here
%   Detailed explanation goes here
	%%Creating row of excel
	rowInfo.xRadius = ellipsoidInfo.xRadius;
	rowInfo.yRadius = ellipsoidInfo.yRadius;
	rowInfo.zRadius = ellipsoidInfo.zRadius;
	rowInfo.totalCells = size(exchangeNeighboursPerCell, 1);
	rowInfo.cellHeight = ellipsoidInfo.cellHeight;
	
	rowInfo.meanCellArea = mean(ellipsoidInfo.cellArea);
	rowInfo.stdCellArea = std(ellipsoidInfo.cellArea);
	
	rowInfo.percentageOfexchangeNeighboursPerCell = sum(exchangeNeighboursPerCell) / size(exchangeNeighboursPerCell, 1);
	
	for numBorders = 1:size(ellipsoidInfo.bordersSituatedAt, 2)
		
		rowInfo.bordersSituatedAt = ellipsoidInfo.bordersSituatedAt(numBorders);
        %We get select the cells at the borders from the initial ellipsoid.
        %Not from the reduced ellipsoid. Thus, we'll always get the same
        %centroids for all the different cell heights.
        cellsAtXBorderRight = initialEllipsoid.finalCentroids(:, 1) < -(rowInfo.bordersSituatedAt * initialEllipsoid.xRadius);
        cellsAtYBorderRight = initialEllipsoid.finalCentroids(:, 2) < -(rowInfo.bordersSituatedAt * initialEllipsoid.yRadius);
        cellsAtZBorderRight = initialEllipsoid.finalCentroids(:, 3) < -(rowInfo.bordersSituatedAt * initialEllipsoid.zRadius);

        cellsAtXBorderLeft = initialEllipsoid.finalCentroids(:, 1) > (rowInfo.bordersSituatedAt * initialEllipsoid.xRadius);
        cellsAtYBorderLeft = initialEllipsoid.finalCentroids(:, 2) > (rowInfo.bordersSituatedAt * initialEllipsoid.yRadius);
        cellsAtZBorderLeft = initialEllipsoid.finalCentroids(:, 3) > (rowInfo.bordersSituatedAt * initialEllipsoid.zRadius);

        rowInfo.percentageOfexchangeNeighboursPerCellAtXBorderLeft = sum(exchangeNeighboursPerCell(cellsAtXBorderLeft)) / size(exchangeNeighboursPerCell(cellsAtXBorderLeft), 1);
        rowInfo.percentageOfexchangeNeighboursPerCellAtXBorderRight = sum(exchangeNeighboursPerCell(cellsAtXBorderRight)) / size(exchangeNeighboursPerCell(cellsAtXBorderRight), 1);
        rowInfo.percentageOfexchangeNeighboursPerCellAtXMiddle = sum(exchangeNeighboursPerCell(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0)) / size(exchangeNeighboursPerCell(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0), 1);

        rowInfo.percentageOfexchangeNeighboursPerCellAtYBorderLeft = sum(exchangeNeighboursPerCell(cellsAtYBorderLeft)) / size(exchangeNeighboursPerCell(cellsAtYBorderLeft), 1);
        rowInfo.percentageOfexchangeNeighboursPerCellAtYBorderRight = sum(exchangeNeighboursPerCell(cellsAtYBorderRight)) / size(exchangeNeighboursPerCell(cellsAtYBorderRight), 1);
        rowInfo.percentageOfexchangeNeighboursPerCellAtYMiddle = sum(exchangeNeighboursPerCell(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0)) / size(exchangeNeighboursPerCell(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0), 1);

        rowInfo.percentageOfexchangeNeighboursPerCellAtZBorderLeft = sum(exchangeNeighboursPerCell(cellsAtZBorderLeft)) / size(exchangeNeighboursPerCell(cellsAtZBorderLeft), 1);
        rowInfo.percentageOfexchangeNeighboursPerCellAtZBorderRight = sum(exchangeNeighboursPerCell(cellsAtZBorderRight)) / size(exchangeNeighboursPerCell(cellsAtZBorderRight), 1);
        rowInfo.percentageOfexchangeNeighboursPerCellAtZMiddle = sum(exchangeNeighboursPerCell(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0)) / size(exchangeNeighboursPerCell(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0), 1);

        rowInfo.numCellsAtXBorderLeft = size(exchangeNeighboursPerCell(cellsAtXBorderLeft), 1);
        rowInfo.numCellsAtXBorderRight = size(exchangeNeighboursPerCell(cellsAtXBorderRight), 1);
        rowInfo.numCellsAtXMiddle = size(exchangeNeighboursPerCell(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0), 1);

        rowInfo.numCellsAtYBorderLeft = size(exchangeNeighboursPerCell(cellsAtYBorderLeft), 1);
        rowInfo.numCellsAtYBorderRight = size(exchangeNeighboursPerCell(cellsAtYBorderRight), 1);
        rowInfo.numCellsAtYMiddle = size(exchangeNeighboursPerCell(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0), 1);

        rowInfo.numCellsAtZBorderLeft = size(exchangeNeighboursPerCell(cellsAtZBorderLeft), 1);
        rowInfo.numCellsAtZBorderRight = size(exchangeNeighboursPerCell(cellsAtZBorderRight), 1);
        rowInfo.numCellsAtZMiddle = size(exchangeNeighboursPerCell(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0), 1);

        rowInfo.areaOfXBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtXBorderLeft));
        rowInfo.areaOfXBorderRight = sum(ellipsoidInfo.cellArea(cellsAtXBorderRight));
        rowInfo.areaOfXMiddle = sum(ellipsoidInfo.cellArea(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0));

        rowInfo.areaOfYBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtYBorderLeft));
        rowInfo.areaOfYBorderRight = sum(ellipsoidInfo.cellArea(cellsAtYBorderRight));
        rowInfo.areaOfYMiddle = sum(ellipsoidInfo.cellArea(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0));
        
        rowInfo.areaOfZBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtZBorderLeft));
        rowInfo.areaOfZBorderRight = sum(ellipsoidInfo.cellArea(cellsAtZBorderRight));
        rowInfo.areaOfZMiddle = sum(ellipsoidInfo.cellArea(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0));

        rowInfo.surfaceReductionOfXBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtXBorderLeft)) / sum(initialEllipsoid.cellArea(cellsAtXBorderLeft));
        rowInfo.surfaceReductionOfXBorderRight = sum(ellipsoidInfo.cellArea(cellsAtXBorderRight)) / sum(initialEllipsoid.cellArea(cellsAtXBorderRight));
        rowInfo.surfaceReductionOfXMiddle = sum(ellipsoidInfo.cellArea(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0)) / sum(initialEllipsoid.cellArea(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0));

        rowInfo.surfaceReductionOfYBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtYBorderLeft)) / sum(initialEllipsoid.cellArea(cellsAtYBorderLeft));
        rowInfo.surfaceReductionOfYBorderRight = sum(ellipsoidInfo.cellArea(cellsAtYBorderRight)) / sum(initialEllipsoid.cellArea(cellsAtYBorderRight));
        rowInfo.surfaceReductionOfYMiddle = sum(ellipsoidInfo.cellArea(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0)) / sum(initialEllipsoid.cellArea(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0));
        
        rowInfo.surfaceReductionOfZBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtZBorderLeft)) / sum(initialEllipsoid.cellArea(cellsAtZBorderLeft));
        rowInfo.surfaceReductionOfZBorderRight = sum(ellipsoidInfo.cellArea(cellsAtZBorderRight)) / sum(initialEllipsoid.cellArea(cellsAtZBorderRight));
        rowInfo.surfaceReductionOfZMiddle = sum(ellipsoidInfo.cellArea(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0)) / sum(initialEllipsoid.cellArea(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0));
        
        rowInfo = renameVariablesOfStructAddingSuffix(rowInfo, num2str(round(rowInfo.bordersSituatedAt*100)), {'Border', 'Middle'});

end

