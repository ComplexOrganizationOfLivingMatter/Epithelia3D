function [ApicalIncorrectCells,BasalIncorrectCells]=CheckPercentagePolygon(polygon_distribution_Apical,polygon_distribution_Basal,polygonDistributions)
polygon_distribution_apicobasal= sum([polygon_distribution_Apical{2,:}])+ sum([polygon_distribution_Basal{2,:}]);
if polygon_distribution_apicobasal ~= 2
for NumberCell=1:length(polygonDistributions{1,1})
    ApicalNeighbours=polygonDistributions{1,1};
    TotalApicalNeighbours{NumberCell,1}=sum(length(ApicalNeighbours{NumberCell,1}));
end
for NumberCell=1:length(polygonDistributions{1,2})
    BasalNeighbours=polygonDistributions{1,2};
    TotalBasalNeighbours{NumberCell,1}=sum(length(BasalNeighbours{NumberCell,1}));
end
ApicalIncorrectCells1 = find([TotalApicalNeighbours{:}] <= 2); 
ApicalIncorrectCells2 = find([TotalApicalNeighbours{:}] >= 11);
ApicalIncorrectCells=[ApicalIncorrectCells1 ApicalIncorrectCells2];
BasalIncorrectCells1 = find([TotalBasalNeighbours{:}] <= 2); 
BasalIncorrectCells2 = find([TotalBasalNeighbours{:}] >= 11);
BasalIncorrectCells=[BasalIncorrectCells1 BasalIncorrectCells2];
TotalIncorrectCells= ['There are some incorrect cells','  ', 'ApicalIncorrectCells:', num2str(ApicalIncorrectCells),' ', 'BasalIncorrectCells:', num2str(BasalIncorrectCells)];
disp(TotalIncorrectCells);
end
end 