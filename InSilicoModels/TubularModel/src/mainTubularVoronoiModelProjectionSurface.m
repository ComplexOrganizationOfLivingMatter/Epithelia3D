function mainTubularVoronoiModelProjectionSurface(numSeeds,basalExpansions,apicalReductions,numRandoms,Hinitial,Winitial,thresholdRes)
%MAINTUBULARVORONOIMODELPROJECTIONSURFACE get all the information used in
%the manuscript regarding tue tubular voronoi model. This code is divide in
%4 principal functions that are explained below.

    kindProjection={'expansion','reduction'};
    if isempty(basalExpansions)
        kindProjection={'reduction'};
    else if isempty(apicalReductions)
            kindProjection={'expansion'};
         end
    end
    
    directory2save='data\tubularVoronoiModel\';

    for typeP = 1 : length(kindProjection)

            nameOfFolder=[num2str(Winitial) 'x' num2str(Hinitial) '_' num2str(numSeeds) 'seeds\'];
            path3dVoronoi=['data\tubularCVT\Data\' nameOfFolder];

            pathV5data=dir([path3dVoronoi '*m_5*']);

            switch kindProjection{typeP}
                case {'expansion'}
                    %basalRadius/apicalRadius
                    listOfSurfaceRatios=basalExpansions;
                case {'reduction'}
                    %apicalRadius/basalRadius
                    listOfSurfaceRatios=apicalReductions;
            end

            %carry out Voronoi surface projections and edge length and angles measurements
            surfaceProjection(pathV5data,nameOfFolder,directory2save,path3dVoronoi,kindProjection{typeP},listOfSurfaceRatios)
  
            %calculation the presence of scutoids
            if thresholdRes <= 1
                calculateNumberOfInvolvedCellsInTransitions(numSeeds,kindProjection{typeP},pathV5data,directory2save,length(listOfSurfaceRatios),Hinitial,Winitial)
            else
                 calculatePercentajeScutoidsByThreshold(directory2save,numSeeds,Hinitial,Winitial,numRandoms,kindProjection{typeP},thresholdRes)
            end
            %calculation the number of cells along the trasversal plane
            calculateNcellsAroundTrasversalSection(numSeeds,kindProjection{typeP},pathV5data,directory2save,length(listOfSurfaceRatios),Hinitial,Winitial)

            %measurements of line tension energy
            energyCalculationVoronoiTubularModel(directory2save,nameOfFolder,length(listOfSurfaceRatios),numRandoms,kindProjection{typeP},numSeeds,basalExpansions,apicalReductions)
            
            
    end

end

