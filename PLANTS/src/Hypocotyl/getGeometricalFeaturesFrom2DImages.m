function getGeometricalFeaturesFrom2DImages(name2save,finalImagesPerLayer,noValidCells)
    
    %threshold (in pixel) for consider a transition as valid
    thresholdRes = 4.33;
    %pixel radius to look for neighbours
    neighRadius = 2;
    
    %load images
    basalLayer = finalImagesPerLayer{1};
    apicalLayer = finalImagesPerLayer{2};

    %valid cell
    validCells = unique(basalLayer);
    validCells = setdiff(validCells,noValidCells);
    validCells = validCells(validCells~=0);

    %neighbours in apical and basal
    neighBasal = calculateNeighbours(basalLayer, neighRadius);
    neighApical = calculateNeighbours(apicalLayer, neighRadius);


    %measure edge length and angles
    [ totalEdges.basalTransition, totalEdges.basalNoTransition ] = measureAnglesAndLengthOfEdges( basalLayer,neighBasal,neighApical,noValidCells);
    [ totalEdges.apicalTransition, totalEdges.apicalNoTransition ] = measureAnglesAndLengthOfEdges( apicalLayer,neighApical,neighBasal,noValidCells);

    %calculate number of scutoids
    [tableScutoids] = calculatePercentajeScutoidsByThreshold(validCells,noValidCells,neighApical,neighBasal,totalEdges,thresholdRes);

    %measure area, orientation and cell density
    [surfaceRatio, averageCellDataTable, individualCellDataTable] = measurePropertiesInCells(basalLayer,apicalLayer,noValidCells);

    splitName = strsplit(name2save,'/');
    mkdir(strjoin(splitName(1:end-1),'/'))
    
    save([name2save,'ResultsMeasurementCells'],'tableScutoids','totalEdges','surfaceRatio','averageCellDataTable','individualCellDataTable')
%         %calculate vertices
%         verticesBasal = calculateVertices( basalLayer, neighBasal, neighRadius);
%         verticesApical = calculateVertices( apicalLayer, neighApical, neighRadius);
%     

end