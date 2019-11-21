function delaunayEuler3D(xImg,yImg,numSeeds,numRand,setNLloydIt,isRandom)
%delaunay - euler 3d

    for nLloydIt = setNLloydIt

        numNeighsAccum = zeros(numRand,length(surfaceRatios));
        numNeighSurface = zeros(numRand,length(surfaceRatios));
        neighsAccum = cell(numRand,length(surfaceRatios));
        numWonNeighsAccum = cell(numRand,length(surfaceRatios));
        numLostNeighsAccum = cell(numRand,length(surfaceRatios));
        numTransitions = cell(numRand,length(surfaceRatios));
        percentageScutoids = zeros(numRand,length(surfaceRatios));

        polyDisTotal = cell(numRand,1);

        addpath(genpath('src'))

        % path2save = ['..\..\3D_laws\delaunayData\delaunayCyl_Voronoi' num2str(nLloydIt+1) '_' num2str(numSeeds) 'seeds_sr' num2str(max(surfaceRatios)) '_' date '.mat'];
        folderName = '..\..\3D_laws\delaunayData\';
        fileName = ['delaunayCyl_Voronoi' num2str(nLloydIt+1) '_' num2str(numSeeds) 'seeds_sr' num2str(max(surfaceRatios)) '_' date '.mat'];
        mkdir([folderName 'Voronoi ' num2str(nLloydIt+1)])
        path2save = [folderName 'Voronoi ' num2str(nLloydIt+1) '\' fileName];
        if ~exist(path2save,'file')

            for nRand = 1:numRand
                % select random position for seeds
                seedsX = cell(3,1);
                seedsY = cell(3,1);
                if ~isRandom
                    load(['data\tubularCVT\Data\' num2str(xImg) 'x' num2str(yImg) '_' num2str(numSeeds) 'seeds\Image_' num2str(nRand) '_Diagram_' num2str(nLloydIt+1) '.mat'],'seeds')
                    initLim = 0;
                    for nRep = 1:3
                        seedsX{nRep} = seeds(:,2) + initLim;
                        seedsY{nRep} = seeds(:,1) + initLim + (2-nRep)*yImg;
                    end
                else
                    for nRep = 1:3
                        uniqueSeeds=0;
                        if isRandom
                            while uniqueSeeds~=numSeeds 
                                seedsX{nRep} = (xImg-initLim).*rand(numSeeds,1) + initLim;
                                seedsY{nRep} = (yImg-initLim).*rand(numSeeds,1) + initLim + (2-nRep)*yImg;
                                uniqueSeeds = size(unique([seedsX{nRep},seedsY{nRep}],'rows'));
                            end
                        end 
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


                %% lloyd algorithm
                if isRandom && nLloydIt>0
                    idCentralRegion = (numSeeds*3+1):numSeeds*6;
                    matrixSeeds=lloydWithDelaunayCylinder(matrixSeeds,xImg,yImg,numSeeds,idCentralRegion,nLloydIt);
                end

                %init neighsAccum
                nNeighPerSR = zeros(1,length(surfaceRatios));
                euler2D = zeros(1,length(surfaceRatios));
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

                    
                    
                    
                    sidesCells = cellfun(@length,uniqueNeighsReformated);
                    [polyDisImg] = calculate_polygon_distribution( sidesCells, 1:1000 );
                    polyDisTotal{nRand}=polyDisImg(2,:);

                    if SR==1
                        neighsAccum{nRand,SR} = uniqueNeighsReformated;
                        numLostNeighsAccum{nRand,SR} = cell(size(uniqueNeighsReformated));
                        numWonNeighsAccum{nRand,SR} = cell(size(uniqueNeighsReformated));
                    else
                        neighsAccum{nRand,SR} = cellfun(@(x,y) unique([x;y]),uniqueNeighsReformated,neighsAccum{nRand,SR-1},'UniformOutput',false);

                        lostNeigh = cellfun(@(x,y) setdiff(x,y),neighsAccum{nRand,SR-1},uniqueNeighsReformated,'UniformOutput',false);
                        wonNeigh = cellfun(@(x,y) setdiff(y,x),neighsAccum{nRand,SR-1},neighsAccum{nRand,SR},'UniformOutput',false);

                        meanLost = mean(cellfun(@length,lostNeigh));
                        meanWon = mean(cellfun(@length,wonNeigh));

                        numLostNeighsAccum{nRand,SR} = cellfun(@(x,y) unique([x;y]),lostNeigh,numLostNeighsAccum{nRand,SR-1},'UniformOutput',false);
                        numWonNeighsAccum{nRand,SR} = cellfun(@(x,y) unique([x;y]),wonNeigh,numWonNeighsAccum{nRand,SR-1},'UniformOutput',false);

                        numTransitions{nRand,SR} = cellfun(@(x,y) length(([x;y])),numLostNeighsAccum{nRand,SR},numWonNeighsAccum{nRand,SR});     
                        percentageScutoids(nRand,SR) = sum(arrayfun(@(x) sum(x)>0,numTransitions{nRand,SR}))/length(uniqueNeighsReformated);

                    end
                    nNeighPerSR(SR) = mean(cellfun(@length,neighsAccum{nRand,SR}));
                    euler2D(SR) = mean(cellfun(@length,uniqueNeighsReformated));
                end
                numNeighsAccum(nRand,:) = nNeighPerSR;
                numNeighSurface(nRand,:) = euler2D;
            end
            averageTransitions = cellfun(@mean, numTransitions);
            % averageLost = mean(cellfun(@(x) mean(cellfun(@length, x)),numLostNeighsAccum));
            % averageWon = mean(cellfun(@(x) mean(cellfun(@length, x)),numWonNeighsAccum));
            % 

            tableSR = array2table(surfaceRatios,'RowNames',{'surfaceRatio'});
            tableNeighsAccum = array2table(numNeighsAccum,'VariableNames',tableSR.Properties.VariableNames);
            tableEuler3D = [tableSR;tableNeighsAccum];
            neighsAccumFinalSR = neighsAccum(:,end);

            tableTotalResults = [tableSR;array2table([mean(numNeighsAccum);std(numNeighsAccum);mean(averageTransitions);std(averageTransitions);mean(percentageScutoids);std(percentageScutoids)],'VariableNames',tableSR.Properties.VariableNames,'RowNames',{'meanNeighbours','stdNeighbours','meanTransitions','stdTransitions','meanScutoids','stdScutoids'})];

            save(path2save,'percentageScutoids','averageTransitions','numTransitions','tableEuler3D','neighsAccum','neighsAccumFinalSR','tableTotalResults');
        else

            load(path2save,'tableTotalResults')
        end

        delaunayGraphics(folderName,tableTotalResults,nLloydIt+1);
    end

end