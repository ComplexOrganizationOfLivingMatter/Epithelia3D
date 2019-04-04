%delaunay - euler 3d

%delimitate initial space
%x axis limit
xImg = 32;
%y axis limit
yImg = 1024;

%number of initial seeds
numSeeds = 1000;

%number of different randomizations
numRand = 20;

srInit = 10 * 1./(1:10);
surfaceRatios = unique([srInit,1.8,3:1000]);
numNeighsAccum = zeros(numRand,length(surfaceRatios));
neighsAccum = cell(numRand,length(surfaceRatios));


for nRand = 1:numRand
    % select random position for seeds
    seedsX = cell(3,1);
    seedsY = cell(3,1);
    for nRep = 1:3
        uniqueSeeds=0;
        initLim = 0;
        while uniqueSeeds~=numSeeds 
            seedsX{nRep} = (xImg-initLim).*rand(numSeeds,1) + initLim;
            seedsY{nRep} = (yImg-initLim).*rand(numSeeds,1) + initLim + (2-nRep)*yImg;
            uniqueSeeds = size(unique([seedsX{nRep},seedsY{nRep}],'rows'));
        end
    end
    
    seedsXcentral = vertcat(seedsX{:});
    seedsY = vertcat(seedsY{:});
    
    %define repeated matrix of seeds to reduce the border effect (deleted border effect in central seeds)
    seedsXright = seedsXcentral + xImg;
    seedsXleft = seedsXcentral - xImg;
    %matrix defined:[upLeft;upCentral;upRight;midLeft;midCentral;midRight;downLeft;downCentral;downRight];
    matrixSeeds = [seedsXleft(1:numSeeds),seedsY(1:numSeeds); seedsXleft(numSeeds+1:2*numSeeds),seedsY(numSeeds+1:2*numSeeds);seedsXleft(2*numSeeds+1:3*numSeeds),seedsY(2*numSeeds+1:3*numSeeds);...
    seedsXcentral(1:numSeeds),seedsY(1:numSeeds); seedsXcentral(numSeeds+1:2*numSeeds),seedsY(numSeeds+1:2*numSeeds);seedsXcentral(2*numSeeds+1:3*numSeeds),seedsY(2*numSeeds+1:3*numSeeds);...
    seedsXright(1:numSeeds),seedsY(1:numSeeds); seedsXright(numSeeds+1:2*numSeeds),seedsY(numSeeds+1:2*numSeeds);seedsXright(2*numSeeds+1:3*numSeeds),seedsY(2*numSeeds+1:3*numSeeds)];
    
    %init neighsAccum
    nNeighPerSR = zeros(1,length(surfaceRatios));

    for SR = 1:length(surfaceRatios)

        %the seeds we want to study are in the central region of 'matrixSeeds'
        %label of interest
        labelOfInterest = 4*numSeeds+1:5*numSeeds;

        %generate the complete delaunay triangulation for each surface
        %ratio
        TRI = delaunay(matrixSeeds(:,1).*surfaceRatios(SR),matrixSeeds(:,2));
        TRIsort = sort(TRI,2);
        TRIunique = unique(TRIsort,'rows');

        %calculateNeighboursPerTriangledSeed only for label of interest
        neighs = arrayfun(@(x) setdiff(unique(TRIunique(sum(ismember(TRIunique,x),2)>0,:)),x),labelOfInterest,'UniformOutput',false);

        %due to we have labels from 1 to 9000, ([1 : 1/3seeds] up,
        %[1/3seeds + 1: 2/3seeds] central and [2/3seeds + 1 : seeds]
        %down) we need to relabel them: 
        
        %central from [1 : 1/9 seeds];
        neighsCentral = cellfun(@(x) rem(x(x>3*numSeeds & x<=6*numSeeds),numSeeds),neighs,'UniformOutput',false);
        neighsCentralZero = cellfun(@(x) x(x==0)+numSeeds,neighsCentral,'UniformOutput',false);
        
        %up from [1/9 seeds + 1 : 2/9 seeds] ; 
        
        neighsUp = cellfun(@(x) rem(x(x<=3*numSeeds),numSeeds)+1*numSeeds,neighs,'UniformOutput',false);
        neighsUpZero = cellfun(@(x) x(x==numSeeds)+numSeeds,neighsUp,'UniformOutput',false);        
        
        %down from [2/9 seeds + 1 : 3/9 seeds]
        neighsDown = cellfun(@(x) rem(x(x>6*numSeeds & x<=9*numSeeds),numSeeds)+2*numSeeds,neighs,'UniformOutput',false);
        neighsDownZero = cellfun(@(x) x(x==2*numSeeds)+numSeeds,neighsDown,'UniformOutput',false);

        %join all the relabels
        uniqueNeighsReformatedPrev = cellfun(@(x,y,xx,yy,xxx,yyy) unique([x;y;xx;yy;xxx;yyy])...
            ,neighsUp,neighsUpZero,neighsCentral,neighsCentralZero,neighsDown,neighsDownZero,'UniformOutput',false);

        %delete 0's labels....
        uniqueNeighsReformated = cellfun(@(x) x(x>0),uniqueNeighsReformatedPrev,'UniformOutput',false);
        
%         sidesCells = cellfun(@length,uniqueNeighsReformated);
%         [polyDisImg] = calculate_polygon_distribution( sidesCells, 1:1000 );

        if SR==1
            neighsAccum{nRand,SR} = uniqueNeighsReformated;
        else
            neighsAccum{nRand,SR} = cellfun(@(x,y) unique([x;y]),uniqueNeighsReformated,neighsAccum{nRand,SR-1},'UniformOutput',false);
        end
        nNeighPerSR(SR) = mean(cellfun(@(x) length(x),neighsAccum{nRand,SR}));

    end
    numNeighsAccum(nRand,:) = nNeighPerSR;

end

tableSR = array2table([surfaceRatios],'RowNames',{'surfaceRatio'});
tableNeighsAccum = array2table(numNeighsAccum,'VariableNames',tableSR.Properties.VariableNames);
tableEuler3D = [tableSR;tableNeighsAccum];
meanEuler3D = mean(numNeighsAccum);
stdEuler3D = std(numNeighsAccum);
tableMeanNeighsAccum = [tableSR;array2table([meanEuler3D;stdEuler3D],'VariableNames',tableSR.Properties.VariableNames,'RowNames',{'meanNeighbours','stdNeighbours'})];
neighsAccumFinalSR = neighsAccum(:,end);


save(['..\..\3D_laws\delaunayEuler3D_' num2str(numSeeds) 'seeds_sr' num2str(max(surfaceRatios)) '_' date '.mat'],'tableMeanNeighsAccum','tableEuler3D','neighsAccum','neighsAccumFinalSR','-v7.3')
