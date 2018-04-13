pathTube='D:\Pedro\Epithelia3D\InSilicoModels\paperCode\TubularModel\data\tubularVoronoiModel\';
listNumSeeds=[40 800];
H=512; 
W=4096;
totalRandom=20;
projection='expansion';
thresholdRes=4;

for numSeeds=listNumSeeds
    percentajeScutoidsByThreshold(pathTube,numSeeds,H,W,totalRandom,projection,thresholdRes)
end