function mainTubularControlModelProjectionSurface(nSeeds,basalExpansions,apicalReductions,numRandoms,H,W)

    %main
    %we analyse the energy measurements from the expanded cylindrical voronoi
    typeProjections={'expansion','reduction'};
    if isempty(basalExpansions)
        typeProjections={'reduction'};
    else if isempty(apicalReductions)
            typeProjections={'expansion'};
         end
    end
    
    
    for typProj=1:length(typeProjections)

        typeProjection=typeProjections{typProj};
        relativePathVoronoi= ['data\tubularVoronoiModel\' typeProjection '\' num2str(W) 'x' num2str(H) '_'];

        if ~isempty(strfind(typeProjection,'expansion'))
            numSurfaces=length(basalExpansions);
        else
            numSurfaces=length(apicalReductions);
        end


        %defining colours to draw the frusta diagrams
        colours = colorcube(nSeeds);
        colours = colours(randperm(nSeeds), :);

        for nRand=1:numRandoms
            %drawing frusta expansions diagrams and saving the vertices
            drawAndSaveVertices(relativePathVoronoi,nSeeds,nRand,numSurfaces,typeProjection,basalExpansions,apicalReductions,colours,H);
        end

        %calculation of energy in frusta model
        energyCalculationControlTubularModel(numSurfaces,relativePathVoronoi,numRandoms,typeProjection,nSeeds,basalExpansions,apicalReductions)


    end
end