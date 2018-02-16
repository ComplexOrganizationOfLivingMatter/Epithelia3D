%pipeline
function pipelineProjectionApicalSurface (numSeeds,kindProjection)

    nameOfFolder=['512x1024_' num2str(numSeeds) 'seeds\'];

    path3dVoronoi=['D:\Pedro\Epithelia3D\InSilicoModels\ToleranceModel\Data\3D Voronoi model\Cylindrical voronoi\' nameOfFolder];
    directory2save='..\..\data\';
    addpath('libExpansionOrReduction')
    addpath('lib')

    pathV5data=dir([path3dVoronoi '*m_5*']);

    switch kindProjection
        case {'expansion'}
            %basalRadius/apicalRadius
            listOfSurfaceRatios=1:-0.1:0.1;
            listOfSurfaceRatios=1./listOfSurfaceRatios;
        case {'reduction'}
            %apicalRadius/basalRadius
            listOfSurfaceRatios=1:-0.1:0.1;
    end
    
    surfaceProjection(pathV5data,nameOfFolder,directory2save,path3dVoronoi,kindProjection,listOfSurfaceRatios,numSeeds)
    
%     calculateNumberOfInvolvedCellsInTransitions(numSeeds)
%     calculateNcellsAroundTrasversalSection(numSeeds)
%     calculateNcellsAroundLongitudinalSection(numSeeds)
    
end