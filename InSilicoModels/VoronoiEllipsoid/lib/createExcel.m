function [ output_args ] = createExcel( input_args )
%CREATEEXCEL Summary of this function goes here
%   Detailed explanation goes here
	%%Creating row of excel
	exchangeNeighboursInfo.xRadius = ellipsoidInfo.xRadius;
	exchangeNeighboursInfo.yRadius = ellipsoidInfo.yRadius;
	exchangeNeighboursInfo.zRadius = ellipsoidInfo.zRadius;
	exchangeNeighboursInfo.totalCells = size(exchangeNeighboursPerCell, 1);
	exchangeNeighboursInfo.cellHeight = ellipsoidInfo.cellHeight;
	
	exchangeNeighboursInfo.meanCellArea = mean(ellipsoidInfo.cellArea);
	exchangeNeighboursInfo.stdCellArea = std(ellipsoidInfo.cellArea);
	
	exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCell = sum(exchangeNeighboursPerCell) / size(exchangeNeighboursPerCell, 1);
	
	for numBorders = 1:size(ellipsoidInfo.bordersSituatedAt, 2)
		
		exchangeNeighboursInfo.bordersSituatedAt = ellipsoidInfo.bordersSituatedAt(numBorders);
        %We get select the cells at the borders from the initial ellipsoid.
        %Not from the reduced ellipsoid. Thus, we'll always get the same
        %centroids for all the different cell heights.
        cellsAtXBorderRight = initialEllipsoid.finalCentroids(:, 1) < -(exchangeNeighboursInfo.bordersSituatedAt * initialEllipsoid.xRadius);
        cellsAtYBorderRight = initialEllipsoid.finalCentroids(:, 2) < -(exchangeNeighboursInfo.bordersSituatedAt * initialEllipsoid.yRadius);
        cellsAtZBorderRight = initialEllipsoid.finalCentroids(:, 3) < -(exchangeNeighboursInfo.bordersSituatedAt * initialEllipsoid.zRadius);

        cellsAtXBorderLeft = initialEllipsoid.finalCentroids(:, 1) > (exchangeNeighboursInfo.bordersSituatedAt * initialEllipsoid.xRadius);
        cellsAtYBorderLeft = initialEllipsoid.finalCentroids(:, 2) > (exchangeNeighboursInfo.bordersSituatedAt * initialEllipsoid.yRadius);
        cellsAtZBorderLeft = initialEllipsoid.finalCentroids(:, 3) > (exchangeNeighboursInfo.bordersSituatedAt * initialEllipsoid.zRadius);

        exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtXBorderLeft = sum(exchangeNeighboursPerCell(cellsAtXBorderLeft)) / size(exchangeNeighboursPerCell(cellsAtXBorderLeft), 1);
        exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtXBorderRight = sum(exchangeNeighboursPerCell(cellsAtXBorderRight)) / size(exchangeNeighboursPerCell(cellsAtXBorderRight), 1);
        exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtXMiddle = sum(exchangeNeighboursPerCell(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0)) / size(exchangeNeighboursPerCell(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0), 1);

        exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtYBorderLeft = sum(exchangeNeighboursPerCell(cellsAtYBorderLeft)) / size(exchangeNeighboursPerCell(cellsAtYBorderLeft), 1);
        exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtYBorderRight = sum(exchangeNeighboursPerCell(cellsAtYBorderRight)) / size(exchangeNeighboursPerCell(cellsAtYBorderRight), 1);
        exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtYMiddle = sum(exchangeNeighboursPerCell(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0)) / size(exchangeNeighboursPerCell(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0), 1);

        exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtZBorderLeft = sum(exchangeNeighboursPerCell(cellsAtZBorderLeft)) / size(exchangeNeighboursPerCell(cellsAtZBorderLeft), 1);
        exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtZBorderRight = sum(exchangeNeighboursPerCell(cellsAtZBorderRight)) / size(exchangeNeighboursPerCell(cellsAtZBorderRight), 1);
        exchangeNeighboursInfo.percentageOfexchangeNeighboursPerCellAtZMiddle = sum(exchangeNeighboursPerCell(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0)) / size(exchangeNeighboursPerCell(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0), 1);

        exchangeNeighboursInfo.numCellsAtXBorderLeft = size(exchangeNeighboursPerCell(cellsAtXBorderLeft), 1);
        exchangeNeighboursInfo.numCellsAtXBorderRight = size(exchangeNeighboursPerCell(cellsAtXBorderRight), 1);
        exchangeNeighboursInfo.numCellsAtXMiddle = size(exchangeNeighboursPerCell(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0), 1);

        exchangeNeighboursInfo.numCellsAtYBorderLeft = size(exchangeNeighboursPerCell(cellsAtYBorderLeft), 1);
        exchangeNeighboursInfo.numCellsAtYBorderRight = size(exchangeNeighboursPerCell(cellsAtYBorderRight), 1);
        exchangeNeighboursInfo.numCellsAtYMiddle = size(exchangeNeighboursPerCell(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0), 1);

        exchangeNeighboursInfo.numCellsAtZBorderLeft = size(exchangeNeighboursPerCell(cellsAtZBorderLeft), 1);
        exchangeNeighboursInfo.numCellsAtZBorderRight = size(exchangeNeighboursPerCell(cellsAtZBorderRight), 1);
        exchangeNeighboursInfo.numCellsAtZMiddle = size(exchangeNeighboursPerCell(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0), 1);

        exchangeNeighboursInfo.areaOfXBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtXBorderLeft));
        exchangeNeighboursInfo.areaOfXBorderRight = sum(ellipsoidInfo.cellArea(cellsAtXBorderRight));
        exchangeNeighboursInfo.areaOfXMiddle = sum(ellipsoidInfo.cellArea(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0));

        exchangeNeighboursInfo.areaOfYBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtYBorderLeft));
        exchangeNeighboursInfo.areaOfYBorderRight = sum(ellipsoidInfo.cellArea(cellsAtYBorderRight));
        exchangeNeighboursInfo.areaOfYMiddle = sum(ellipsoidInfo.cellArea(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0));
        
        exchangeNeighboursInfo.areaOfZBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtZBorderLeft));
        exchangeNeighboursInfo.areaOfZBorderRight = sum(ellipsoidInfo.cellArea(cellsAtZBorderRight));
        exchangeNeighboursInfo.areaOfZMiddle = sum(ellipsoidInfo.cellArea(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0));

        exchangeNeighboursInfo.surfaceReductionOfXBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtXBorderLeft)) / sum(initialEllipsoid.cellArea(cellsAtXBorderLeft));
        exchangeNeighboursInfo.surfaceReductionOfXBorderRight = sum(ellipsoidInfo.cellArea(cellsAtXBorderRight)) / sum(initialEllipsoid.cellArea(cellsAtXBorderRight));
        exchangeNeighboursInfo.surfaceReductionOfXMiddle = sum(ellipsoidInfo.cellArea(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0)) / sum(initialEllipsoid.cellArea(cellsAtXBorderRight == 0 & cellsAtXBorderLeft == 0));

        exchangeNeighboursInfo.surfaceReductionOfYBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtYBorderLeft)) / sum(initialEllipsoid.cellArea(cellsAtYBorderLeft));
        exchangeNeighboursInfo.surfaceReductionOfYBorderRight = sum(ellipsoidInfo.cellArea(cellsAtYBorderRight)) / sum(initialEllipsoid.cellArea(cellsAtYBorderRight));
        exchangeNeighboursInfo.surfaceReductionOfYMiddle = sum(ellipsoidInfo.cellArea(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0)) / sum(initialEllipsoid.cellArea(cellsAtYBorderRight == 0 & cellsAtYBorderLeft == 0));
        
        exchangeNeighboursInfo.surfaceReductionOfZBorderLeft = sum(ellipsoidInfo.cellArea(cellsAtZBorderLeft)) / sum(initialEllipsoid.cellArea(cellsAtZBorderLeft));
        exchangeNeighboursInfo.surfaceReductionOfZBorderRight = sum(ellipsoidInfo.cellArea(cellsAtZBorderRight)) / sum(initialEllipsoid.cellArea(cellsAtZBorderRight));
        exchangeNeighboursInfo.surfaceReductionOfZMiddle = sum(ellipsoidInfo.cellArea(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0)) / sum(initialEllipsoid.cellArea(cellsAtZBorderRight == 0 & cellsAtZBorderLeft == 0));
        
        exchangeNeighboursInfo = renameVariablesOfStructAddingSuffix(exchangeNeighboursInfo, num2str(round(exchangeNeighboursInfo.bordersSituatedAt*100)), {'Border', 'Middle'});

end

