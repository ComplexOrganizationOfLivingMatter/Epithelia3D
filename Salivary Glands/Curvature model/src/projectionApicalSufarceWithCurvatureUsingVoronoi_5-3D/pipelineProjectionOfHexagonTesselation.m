listSeeds=[9,34,132,520,2064];
kindProjection='expansion';
for i=1:length(listSeeds)
    nameOfFolder=['512x1024_' num2str(listSeeds(i)) 'seeds\'];
    path3dVoronoi=['D:\Pedro\Epithelia3D\Salivary Glands\Tolerance model\Data\3D Voronoi model\Cylindrical voronoi\cylinderOfHexagons\' nameOfFolder];
    directory2save=['..\..\data\' kindProjection '\cylinderOfHexagons\'];
    addpath('lib')
    addpath('libExpansionOrReduction')
    addpath('libHexagonsExpansion')
    pathHexagonalImage=dir([path3dVoronoi '*m_5*']);

    %basalRadius/apicalRadius
    listOfSurfaceRatios=1:-0.1:0.1;
    listOfSurfaceRatios=1./listOfSurfaceRatios;

    surfaceProjectionHexagons(pathHexagonalImage,nameOfFolder,directory2save,path3dVoronoi,kindProjection,listOfSurfaceRatios,listSeeds(i))
    calculateNumberOfInvolvedCellsInTransitionsHexagonsTessellation(listSeeds(i));

end