
load('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\data\tubularVoronoiModel\expansion\512x4096_200seeds\diagram5\diagram5_dataPolygonDistributionAndPercentageScutoids.mat')


for numFile = 1:size(neighsPerSRPerImg, 2)
    neighbours = neighsPerSRPerImg(numFile, :);
    neighsSurface{1} = neighbours{1}';
    neighsAccumSurfaces{1} = neighbours{1}';

    for idSR = 2:size(neighbours, 2)
        neighsSurface{idSR} = neighbours{idSR}';
        neighsAccumSurfaces{idSR} = cellfun(@(x,y) unique([x;y]), neighsAccumSurfaces{idSR-1}, neighsSurface{idSR},'UniformOutput',false);
    end
    
    numNeighsPerSRPerImg = cellfun(@(aCell) cellfun(@(x) length(x), aCell), neighsAccumSurfaces, 'UniformOutput', false);
    
    totalNeighsAccum = cat(2,numNeighsPerSRPerImg{:});
    [meanWinningPerSidePerFile{numFile}] = calculateMeanWinning3DNeighbours(totalNeighsAccum, validCellsPerImg{numFile, 1});
end

dim = ndims(meanWinningPerSidePerFile{1});          %# Get the number of dimensions for your arrays
M = cat(dim+1,meanWinningPerSidePerFile{:});        %# Convert to a (dim+1)-dimensional matrix
meanWinningPerSide_Total = mean(M,dim+1, 'omitnan');  %# Get the mean across arrays