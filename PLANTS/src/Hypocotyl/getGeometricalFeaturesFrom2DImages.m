function getGeometricalFeaturesFrom2DImages(name2save,finalImages,setNoValidCells)
    
    %threshold (in pixel) for consider a transition as valid
    thresholdRes = 4.33;
    %pixel radius to look for neighbours
    neighRadius = 2;
    
    for numLayer = 1 : 2
        %load images
        basalLayer = finalImages{2*numLayer-1};
        apicalLayer = finalImages{2*numLayer};
        
        %no valid cells by layer
        noValidCells = setNoValidCells{numLayer};
        
        %valid cell
        validCells = unique(basalLayer);
        validCells = setdiff(validCells,noValidCells);
        validCells = validCells(validCells~=0);
        
        %neighbours in apical and basal
        neighBasal = calculateNeighbours(basalLayer, neighRadius);
        neighApical = calculateNeighbours(apicalLayer, neighRadius);

        
        %measure edge length and angles
        [ totalEdges.basalTransition, totalEdges.basalNoTransition ] = measureAnglesAndLengthOfEdges( basalLayer,neighBasal,neighApical);
        [ totalEdges.apicalTransition, totalEdges.apicalNoTransition ] = measureAnglesAndLengthOfEdges( apicalLayer,neighApical,neighBasal);
        %calculate number of scutoids
        [scutoids,percCellsNoTransitions,percCellsTransition,nTransitionPerCell] = calculatePercentajeScutoidsByThreshold(validCells,noValidCells,neighApical,neighBasal,totalEdges,thresholdRes);
        
        %measure area, orientation and cell density
        measurePropertiesInCells(basalLayer,apicalLayer,noValidCells)
        
        
        %calculate vertices
        verticesBasal = calculateVertices( basalLayer, neighBasal, neighRadius);
        verticesApical = calculateVertices( apicalLayer, neighApical, neighRadius);
    
    end


end