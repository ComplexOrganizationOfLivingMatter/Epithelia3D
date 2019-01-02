
load('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\data\tubularVoronoiModel\expansion\512x4096_200seeds\diagram5\diagram5_dataPolygonDistributionAndPercentageScutoids.mat')


for numFile = 1:size(numNeighsPerSRPerImg, 1)
    vertcat(numNeighsPerSRPerImg{numFile, :});
    neighsAccumSurfaces{1} = neighbours{1}';

    for idSR = 2:size(numNeighsPerSRPerImg, 1)
        neighsAccumSurfaces{idSR} = cellfun(@(x,y) unique([x;y]),neighsAccumSurfaces{idSR-1},neighsSurface{idSR},'UniformOutput',false);
    end
    
    numNeighsPerSRPerImg = cellfun(@(aCell) cellfun(@(x) length(x), aCell), neighsPerSRPerImg, 'UniformOutput', false);
    [meanWinningPerSidePerFile{numFile}] = calculateMeanWinning3DNeighbours(, validCellsPerImg{numFile, 1});
end