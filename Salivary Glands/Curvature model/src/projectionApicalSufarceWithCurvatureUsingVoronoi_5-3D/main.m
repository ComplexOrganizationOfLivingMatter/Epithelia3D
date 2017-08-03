%50,75,100,200,
listSeeds=[400];
kindProjection={'reduction','expansion'};
for i= 1:length(listSeeds)
    pipelineProjectionApicalSurface (listSeeds(i),kindProjection{2})
end