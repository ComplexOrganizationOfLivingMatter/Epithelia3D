function [finalImages,cellsLayer1,cellsLayer2]=cleanAndGetMeasurements(deployedImg)

    layer1Outer=deployedImg{1};
    layer1Inner=deployedImg{2};
    layer2Outer=deployedImg{3};
    layer2Inner=deployedImg{4};
    
    maxCell=max([unique(layer1Outer);unique(layer1Inner);unique(layer2Outer);unique(layer2Inner)]);
    c=colorcube(maxCell);
    orderRand=randperm(maxCell);
    c(orderRand(1),:)=[0 0 0];

    
    [finalLayer1Outer,validCellsLayer1Outer,noValidCellsLayer1Outer]=getFinalImageAndNoValidCells(layer1Outer,c);
%     figure;imshow(finalLayer1Outer,c)

    [finalLayer1Inner,validCellsLayer1Inner,noValidCellsLayer1Inner]=getFinalImageAndNoValidCells(layer1Inner,c);
%     figure;imshow(finalLayer1Inner,c)

    [finalLayer2Outer,validCellsLayer2Outer,noValidCellsLayer2Outer]=getFinalImageAndNoValidCells(layer2Outer,c);
%     figure;imshow(finalLayer2Outer,c)

    [finalLayer2Inner,validCellsLayer2Inner,noValidCellsLayer2Inner]=getFinalImageAndNoValidCells(layer2Inner,c);
%     figure;imshow(finalLayer2Inner,c)

    cellsLayer1 = unique([validCellsLayer1Outer;noValidCellsLayer1Outer;validCellsLayer1Inner;noValidCellsLayer1Inner]);
    cellsLayer2 = unique([validCellsLayer2Outer;noValidCellsLayer2Outer;validCellsLayer2Inner;noValidCellsLayer2Inner]);
    finalImages = {finalLayer1Outer,finalLayer1Inner,finalLayer2Outer,finalLayer2Inner};
end