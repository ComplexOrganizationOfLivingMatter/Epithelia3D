function [surfaceRatio, averageTable, individualDataTable] = measurePropertiesInCells(basalLayer,apicalLayer,noValidCells)

    %valid cells
    validCellsBasal=setdiff(unique(basalLayer),noValidCells);
    validCellsBasal=validCellsBasal(validCellsBasal~=0);
    validCellsApical=setdiff(unique(apicalLayer),noValidCells);
    validCellsApical=validCellsApical(validCellsApical~=0);
    
    %get layers with only valid cells
    basalLayerValidCells = basalLayer;
    basalLayerValidCells(ismember(basalLayer,noValidCells))=0;
    apicalLayerValidCells = apicalLayer;
    apicalLayerValidCells(ismember(apicalLayer,noValidCells))=0;
    
    %get properties from basal and apical
    propsBasal = regionprops(basalLayerValidCells,'Area','MajorAxisLength','MinorAxisLength','Orientation');
    propsApical = regionprops(apicalLayerValidCells,'Area','MajorAxisLength','MinorAxisLength','Orientation');

    %%Area
    areaCellsBasal = cat(1,propsBasal.Area);
    areaCellsBasal = areaCellsBasal(validCellsBasal);
    averageAreaBasal = mean(areaCellsBasal);
    stdAreaBasal = std(areaCellsBasal);
    

    areaCellsApical = cat(1,propsApical.Area);
    areaCellsApical = areaCellsApical(validCellsApical);
    averageAreaApical = mean(areaCellsApical);
    stdAreaApical = std(areaCellsApical);

    %%Major and minor axes
    majorAxisCellsBasal = cat(1,propsBasal.MajorAxisLength);
    majorAxisCellsBasal = majorAxisCellsBasal(validCellsBasal);
    averageMajorAxisBasal = mean(majorAxisCellsBasal);
    stdMajorAxisBasal = std(majorAxisCellsBasal);

    minorAxisCellsBasal = cat(1,propsBasal.MinorAxisLength);
    minorAxisCellsBasal = minorAxisCellsBasal(validCellsBasal);
    averageMinorAxisBasal = mean(minorAxisCellsBasal);
    stdMinorAxisBasal = std(minorAxisCellsBasal);

    majorAxisCellsApical = cat(1,propsApical.MajorAxisLength);
    majorAxisCellsApical = majorAxisCellsApical(validCellsApical);
    averageMajorAxisApical = mean(majorAxisCellsApical);
    stdMajorAxisApical = std(majorAxisCellsApical);

    minorAxisCellsApical = cat(1,propsApical.MinorAxisLength);
    minorAxisCellsApical = minorAxisCellsApical(validCellsApical);
    averageMinorAxisApical = mean(minorAxisCellsApical);
    stdMinorAxisApical = std(minorAxisCellsApical);
    
    ratioMajorMinorAxesBasal = majorAxisCellsBasal./minorAxisCellsBasal;
    ratioMajorMinorAxesApical = majorAxisCellsApical./minorAxisCellsApical;
    
    averageRatioLengthAxesBasal = mean(ratioMajorMinorAxesBasal);
    stdRatioLengthAxesBasal = std(ratioMajorMinorAxesBasal);
    averageRatioLengthAxesApical = mean(ratioMajorMinorAxesApical);
    stdRatioLengthAxesApical = std(ratioMajorMinorAxesApical);

    %%Orientation of cells
    orientationCellsBasal = abs(cat(1,propsBasal.Orientation));
    orientationCellsBasal = orientationCellsBasal(validCellsBasal);
    averageOrientationCellsBasal = mean(orientationCellsBasal);
    stdOrientationCellsBasal = std(orientationCellsBasal);

    orientationCellsApical = abs(cat(1,propsApical.Orientation));
    orientationCellsApical = orientationCellsApical(validCellsApical);
    averageOrientationCellsApical = mean(orientationCellsApical);
    stdOrientationCellsApical = std(orientationCellsApical);

    [xApi,yApi] = find( apicalLayer > 0 );
    [xBas,yBas] = find( basalLayer > 0 );

    pixApi=sortrows([xApi,yApi]);
    maxColApical = zeros(max(pixApi(:,1)),1);
    for nRow = 1 : max(pixApi(:,1))
       indPixRow = pixApi(:,1)==nRow ;
       maxColApical(nRow) = max(pixApi(indPixRow,2));
    end
    WApical = mean(maxColApical);
    
    pixBas=sortrows([xBas,yBas]);
    maxColBasal = zeros(max(pixBas(:,1)),1);
    for nRow = 1 : max(pixBas(:,1))
       indPixRow = pixBas(:,1)==nRow ;
       maxColBasal(nRow) = max(pixBas(indPixRow,2));
    end
    WBasal = mean(maxColBasal);
    
    surfaceRatio = WBasal/WApical;
      
    
    averageTable = array2table([[length(validCellsBasal);length(validCellsApical)],[averageAreaBasal*length(validCellsBasal);averageAreaApical*length(validCellsApical)],[averageAreaBasal;averageAreaApical],[stdAreaBasal;stdAreaApical],[averageOrientationCellsBasal;averageOrientationCellsApical],...
        [stdOrientationCellsBasal;stdOrientationCellsApical],[averageMajorAxisBasal;averageMajorAxisApical],[stdMajorAxisBasal;stdMajorAxisApical],...
        [averageMinorAxisBasal;averageMinorAxisApical],[stdMinorAxisBasal;stdMinorAxisApical],[averageRatioLengthAxesBasal;averageRatioLengthAxesApical]...
        [stdRatioLengthAxesBasal;stdRatioLengthAxesApical]],'VariableNames',{'numValidCells','totalAreaValidCells','averageArea','stdArea','averageOrientation','stdOrientation','averageMajorAxLength','stdMajorAxLength','averageMinorAxLength','stdMinorAxLength','averageRatioAxLength','stdRatioAxLength'},'RowNames',{'Basal','Apical'});
    
    individualDataTable = array2table([validCellsBasal,areaCellsBasal,areaCellsApical,orientationCellsBasal,orientationCellsApical,majorAxisCellsBasal,...
        majorAxisCellsApical,minorAxisCellsBasal,minorAxisCellsApical,ratioMajorMinorAxesBasal,...
        ratioMajorMinorAxesApical],'VariableNames',{'cellID','areaBasal','areaApical','orientationBasal','orientationApical','majorAxBasal','majorAxApical','minorAxBasal','minorAxApical','ratioAxBasal','ratioAxApical'});
    
    
end