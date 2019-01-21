folder = 'D:\Pedro\Epithelia3D\InSilicoModels\TubularModel\';
folderData = 'data\tubularVoronoiModel\expansion\512x4096_200seeds\diagram1\polygonsDistributions\';
fileMat = 'dataPolygonDistributionAndPercentageScutoids.mat';
load([folder folderData fileMat])

addpath(genpath([folder 'src']))

%testing k6 graph family
numCells = 200;
nImgs = 20;

neighsAccum = cell(numCells,nImgs);
k5 = 5;
k6 = 6;

for nRealization = 1 : nImgs
    %accum neighs
    neighsImg = cat(1,neighsPerSRPerImg{nRealization,:});
    
    %check number of intersection of neighbours per cell
    for nCell = 1:numCells
        neighsAccum{nCell,nRealization} = unique(vertcat(neighsImg{:,nCell}));
    end
end

validCellsPerImg = validCellsPerImg(1,:);

for nRealization = 1 : nImgs
    
    tripletsOfNeighs = buildTripletsOfNeighs(neighsAccum(:,nRealization)');
    uniqTriplets = unique(sort(tripletsOfNeighs,2),'rows');

    %get k4
    quartetsOfNeighs = [];
    for nTriplets = 1 : size(uniqTriplets,1)
        neighsCellTriplet = arrayfun(@(x)  neighsAccum{x,nRealization},uniqTriplets(nTriplets,:),'UniformOutput',false);
        intersectionTriplet= intersect(neighsCellTriplet{1},intersect(neighsCellTriplet{2},neighsCellTriplet{3}));
        if ~isempty(intersectionTriplet)
            for nQuartets = 1:length(intersectionTriplet)
                quartetsOfNeighs(end+1,:) = [uniqTriplets(nTriplets,:),intersectionTriplet(nQuartets)];
            end
        end
    end
    uniqQuartets = unique(sort(quartetsOfNeighs,2),'rows');

    %get k5
    quintetsOfNeighs = [];
    for nQuartets = 1 : size(uniqQuartets,1)
        neighsCellQuartet = arrayfun(@(x)  neighsAccum{x,nRealization},uniqQuartets(nQuartets,:),'UniformOutput',false);
        intersectionQuartet= intersect(neighsCellQuartet{1},intersect(neighsCellQuartet{2},intersect(neighsCellQuartet{3},neighsCellQuartet{4})));
        if ~isempty(intersectionQuartet)
            for nQuintets = 1:length(intersectionQuartet)
                quintetsOfNeighs(end+1,:) = [uniqQuartets(nQuartets,:),intersectionQuartet(nQuintets)];
            end
        end
    end
    uniqQuintets = unique(sort(quintetsOfNeighs,2),'rows');
    
    %get k6
    sixtetsOfNeighs = [];
    for nQuintets = 1 : size(uniqQuintets,1)
        neighsCellQuintet = arrayfun(@(x)  neighsAccum{x,nRealization},uniqQuintets(nQuintets,:),'UniformOutput',false);
        intersectionQuintet= intersect(neighsCellQuintet{1},intersect(neighsCellQuintet{2},intersect(neighsCellQuintet{3},intersect(neighsCellQuintet{4},neighsCellQuintet{5}))));
        if ~isempty(intersectionQuintet)
            for nSixtets = 1:length(intersectionQuintet)
                sixtetsOfNeighs(end+1,:) = [uniqQuintets(nQuintets,:),intersectionQuintet(nSixtets)];
            end
        end
    end
    uniqSixtets = unique(sort(sixtetsOfNeighs,2),'rows');

    
    %get k7
    seventetsOfNeighs = [];
    for nSixtets = 1 : size(uniqSixtets,1)
        neighsCellSixtets = arrayfun(@(x)  neighsAccum{x,nRealization},uniqSixtets(nSixtets,:),'UniformOutput',false);
        intersectionSixtet= intersect(neighsCellSixtets{1},intersect(neighsCellSixtets{2},intersect(neighsCellSixtets{3},intersect(neighsCellSixtets{4},intersect(neighsCellSixtets{5},neighsCellSixtets{6})))));
        if ~isempty(intersectionSixtet)
            for nSeventets = 1:length(intersectionSixtet)
                seventetsOfNeighs(end+1,:) = [uniqSixtets(nSixtets,:),intersectionSixtet(nSeventets)];
            end
        end
    end
    uniqSeventets = unique(sort(seventetsOfNeighs,2),'rows');


    %get k8
    eightetsOfNeighs = [];

    for nSeventets = 1 : size(uniqSeventets,1)
        neighsCellSeventets = arrayfun(@(x)  neighsAccum{x,nRealization},uniqSeventets(nSeventets,:),'UniformOutput',false);
        intersectionSeventet = cell2mat(cellfun(@(x,y,z,zz,z3,z4,z5) intersect(x,intersect(y,intersect(z,intersect(zz,intersect(z3,intersect(z4,z5)))))),neighsCellSeventets(1),neighsCellSeventets(2),neighsCellSeventets(3),neighsCellSeventets(4),neighsCellSeventets(5),neighsCellSeventets(6),neighsCellSeventets(7),'UniformOutput',false));
        if ~isempty(intersectionSeventet)
            for nEightets = 1:length(intersectionSeventet)
                eightetsOfNeighs(end+1,:) = [uniqSeventets(nSeventets,:),intersectionSeventet(nEightets)];
            end
        end
    end
    uniqEightets = unique(sort(eightetsOfNeighs,2),'rows');

       
end