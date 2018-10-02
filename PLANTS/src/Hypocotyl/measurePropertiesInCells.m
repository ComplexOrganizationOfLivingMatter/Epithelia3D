function measurePropertiesInCells(basalLayer,apicalLayer,noValidCells)

    basalLayerValidCells = basalLayer;
    basalLayerValidCells(ismember(basalLayer,noValidCells))=0;
    propsBasal = regionprops(basalLayerValidCells,'Area','MajorAxisLength','MinorAxisLength','Orientation');
    
    areaCellsBasal = cat(1,propsBasal.Area);
    majorAxisCellsBasal = cat(1,propsBasal.MajorAxisLength);
    minorAxisCellsBasal = cat(1,propsBasal.MinorAxisLength);
    orientationCellsBasal = abs(cat(1,propsBasal.Orientation));

    apicalLayerValidCells = apicalLayer;
    apicalLayerValidCells(ismember(basalLayer,noValidCells))=0;
    propsApical = regionprops(apicalLayerValidCells,'Area','MajorAxisLength','MinorAxisLength','Orientation');

    areaCellsApical = cat(1,propsApical.Area);
    majorAxisCellsApical = cat(1,propsApical.MajorAxisLength);
    minorAxisCellsApical = cat(1,propsApical.MinorAxisLength);
    orientationCellsApical = abs(cat(1,propsApical.Orientation));




end