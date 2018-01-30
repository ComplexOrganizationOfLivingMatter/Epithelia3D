%50,75,100,200,
listSeeds=[10,20,50,100,200,400];
kindProjection={'reduction','expansion'};
for i= 1:length(listSeeds)
    pipelineProjectionSurface (listSeeds(i),kindProjection{2})
end