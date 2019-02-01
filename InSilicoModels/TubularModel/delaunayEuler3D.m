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
surfaceRatios = unique([srInit,3:2000]);
numNeighsAccum = zeros(numRand,length(surfaceRatios));
neighsAccum = cell(numRand,length(surfaceRatios));


for nRand = 1:numRand
    % select random position for seeds
    uniqueSeeds=0;
    initLim = 0;
    while uniqueSeeds~=numSeeds
        seedsX = (xImg-initLim).*rand(numSeeds,1) + initLim;
        seedsY = (yImg-initLim).*rand(numSeeds,1) + initLim;
        uniqueSeeds = size(unique([seedsX,seedsY],'rows'));
    end
    %define repeated matrix of seeds to reduce the border effect (deleted border effect in central seeds)
    seedsXleft = seedsX + xImg;
    seedsXright = seedsX - xImg;
    seedsYup = seedsY + yImg;
    seedsYdown = seedsY - yImg;

    matrixSeeds = [seedsXleft,seedsYup;seedsX,seedsYup;seedsXright,seedsYup;... %row up
        seedsXleft,seedsY;seedsX,seedsY;seedsXright,seedsY;...                  %row center
        seedsXleft,seedsYdown;seedsX,seedsYdown;seedsXright,seedsYdown];        %row down

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

save(['..\..\3D_laws\delaunayEuler3D_' num2str(numSeeds) 'seeds_sr' num2str(max(surfaceRatios)) '_' date '.mat'],'tableMeanNeighsAccum','tableEuler3D','neighsAccum')
