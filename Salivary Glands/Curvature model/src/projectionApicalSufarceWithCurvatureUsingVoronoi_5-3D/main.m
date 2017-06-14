
listSeeds=[50,75,100,200,400];

parfor i= 1:length(listSeeds)
    pipelineProjectionApicalSurface (listSeeds(i))
end