function mainTubularVoronoiModelProjectionSurface(listSeeds,basalExpansions,apicalReductions,Hinitial,Winitial)

    kindProjection={'expansion','reduction'};
    directory2save='data\tubularModelSurfaceProjection\';

    for typeP = 1 : length(kindProjection)
        for numSeeds= listSeeds

            nameOfFolder=[num2str(Hinitial) 'x' num2str(Winitial) '_' num2str(numSeeds) 'seeds\'];
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

            %carry out Voronoi surface projections
            surfaceProjection(pathV5data,nameOfFolder,directory2save,path3dVoronoi,kindProjection{typeP},listOfSurfaceRatios,numSeeds)

            %calculate the presence of scutoids
            calculateNumberOfInvolvedCellsInTransitions(numSeeds,kindProjection{typeP},pathV5data,directory2save,length(listOfSurfaceRatios),Hinitial,Winitial)
        end
    end

end

