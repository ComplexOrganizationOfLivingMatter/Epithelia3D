clear all
% SR = unique([1./(1:-0.1:0.1),2:9]);
initialDiagrams = 8;%[1 8];
% SR = unique([SR 1.8 4]);
SR = 1:0.25:10;
nImages = 20;
typeProjection = 'expansion';
% path2load = 'data\tubularVoronoiModel\expansion\512x4096_200seeds\';

addpath(genpath('src'))

for initialDiagram = initialDiagrams
    
    path2load = ['data\tubularVoronoiModel\' typeProjection '\512x4096_200seeds\diagram' num2str(initialDiagram) '_Markov'];
    totalPathFile = [path2load '\polygonsDistributions\dataPolygonDistributionAndPercentageScutoids_15-May-2019.mat'];
    if ~exist(totalPathFile,'file')
    
        polyDisImg = cell(nImages,length(SR));
        polyDisImgAccum = cell(nImages,length(SR));
        neighsPerSRPerImg = cell(nImages,length(SR));
        validCellsPerImg = cell(nImages,length(SR));
        numNeighsAccum = zeros(nImages,length(SR));
        numNeighSurface = zeros(nImages,length(SR));
        neighsAccum = cell(nImages,length(SR));
        numWonNeighsAccum = cell(nImages,length(SR));
        numLostNeighsAccum = cell(nImages,length(SR));
        numTransitions = cell(nImages,length(SR));
        percentageScutoids = zeros(nImages,length(SR));

        for nRand = 1 : nImages

            load([path2load '\Image_' num2str(nRand) '_Diagram_' num2str(initialDiagram) '\Image_' num2str(nRand) '_Diagram_' num2str(initialDiagram) '.mat'],'listLOriginalProjection');

            if strcmp(typeProjection,'expansion')
                idImg = [listLOriginalProjection{:,1}]==SR(end);
            else
                idImg = [listLOriginalProjection{:,1}]==SR(1);
            end
            img = listLOriginalProjection{idImg,2};
            if iscell(img)
               img = img{1}; 
            end
            noValidCells = unique([img(1,:),img(end,:)]);
            validCells = setdiff(unique(img),noValidCells);
            validCellsPerImg{nRand} = validCells;


    %         load([path2load 'diagram' num2str(initialDiagram) '\Image_' num2str(nImg) '_Diagram_' num2str(initialDiagram) '\Image_' num2str(nImg) '_Diagram_' num2str(initialDiagram) 'specialCase.mat']);
            %init neighsAccum
            nNeighPerSR = zeros(1,length(SR));
            euler2D = zeros(1,length(SR));
            for srImg = 1:length(SR)

                idImg = [listLOriginalProjection{:,1}]==SR(srImg);
                img = listLOriginalProjection{idImg,2};
                if iscell(img)
                   img = img{1}; 
                end
                neighs = calculateNeighbours(img);
                neighsValid = neighs(validCells);
                neighsPerSRPerImg{nRand,srImg} = neighsValid;
                if srImg==1
                    neighsInit = neighsValid;
                end

                if srImg==1
                    neighsAccum{nRand,srImg} = neighsValid;
                    numLostNeighsAccum{nRand,srImg} = cell(size(neighsValid));
                    numWonNeighsAccum{nRand,srImg} = cell(size(neighsValid));
                else

                    neighsAccum{nRand,srImg} = cellfun(@(x,y) unique([x;y]),neighsValid,neighsAccum{nRand,srImg-1},'UniformOutput',false);

                    lostNeigh = cellfun(@(x,y) setdiff(x,y),neighsAccum{nRand,srImg-1},neighsValid,'UniformOutput',false);
                    wonNeigh = cellfun(@(x,y) setdiff(y,x),neighsAccum{nRand,srImg-1},neighsAccum{nRand,srImg},'UniformOutput',false);

                    numLostNeighsAccum{nRand,srImg} = cellfun(@(x,y) unique([x;y]),lostNeigh,numLostNeighsAccum{nRand,srImg-1},'UniformOutput',false);
                    numWonNeighsAccum{nRand,srImg} = cellfun(@(x,y) unique([x;y]),wonNeigh,numWonNeighsAccum{nRand,srImg-1},'UniformOutput',false);

                    numTransitions{nRand,srImg} = cellfun(@(x,y) length(([x;y])),numLostNeighsAccum{nRand,srImg},numWonNeighsAccum{nRand,srImg});     
                    percentageScutoids(nRand,srImg) = sum(arrayfun(@(x) sum(x)>0,numTransitions{nRand,srImg}))/length(neighsValid);

                end
                nNeighPerSR(srImg) = mean(cellfun(@length,neighsAccum{nRand,srImg}));
                euler2D(srImg) = mean(cellfun(@length,neighsValid));

                [polyDisImg{nRand,srImg}] = calculate_polygon_distribution(cellfun(@length,neighs), validCells );
                [polyDisImgAccum{nRand,srImg}] = calculate_polygon_distribution(cellfun(@length,neighsAccum{nRand,srImg}), 1:length(neighsAccum{nRand,srImg}));

            end
            numNeighsAccum(nRand,:) = nNeighPerSR;
            numNeighSurface(nRand,:) = euler2D;

            disp(['rand ' num2str(nRand) ' - finished'])
        end

        averageTransitions = cellfun(@mean, numTransitions);
        % averageLost = mean(cellfun(@(x) mean(cellfun(@length, x)),numLostNeighsAccum));
        % averageWon = mean(cellfun(@(x) mean(cellfun(@length, x)),numWonNeighsAccum));

        tableSR = array2table(SR,'RowNames',{'surfaceRatio'});
        tableNeighsAccum = array2table(numNeighsAccum,'VariableNames',tableSR.Properties.VariableNames);
        tableEuler3D = [tableSR;tableNeighsAccum];
        neighsAccumFinalSR = neighsAccum(:,end);
        tableTotalResults = [tableSR;array2table([mean(numNeighsAccum);std(numNeighsAccum);mean(averageTransitions);std(averageTransitions);mean(percentageScutoids);std(percentageScutoids)],'VariableNames',tableSR.Properties.VariableNames,'RowNames',{'meanNeighbours','stdNeighbours','meanTransitions','stdTransitions','meanScutoids','stdScutoids'})];


        mkdir([path2load '\polygonsDistributions\'])
        save([path2load '\polygonsDistributions\dataPolygonDistributionAndPercentageScutoids_' date '.mat'],'polyDisImg','polyDisImgAccum','SR','percentageScutoids','averageTransitions','numTransitions','tableEuler3D','neighsAccum','neighsAccumFinalSR','tableTotalResults');

    else
        load(totalPathFile,'tableTotalResults')
        delaunayGraphics([path2load '\polygonsDistributions\'],tableTotalResults,initialDiagrams);
    end
%     tablePolDistAccum = [];
%     tablePolDist = [];
%     for srImg = 1:length(SR)
% 
%         dataPolDist = vertcat(polyDisImg{:,srImg});
%         polyDistMatrix = cell2mat(vertcat(dataPolDist(2:2:end,:)));
%         averagePolDist = mean(polyDistMatrix);
%         stdPolDist = std(polyDistMatrix);
%         namesColums = dataPolDist(1,:);
% 
% 
%         h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
%         hold on
%         bar(averagePolDist);
%         errorbar(averagePolDist,stdPolDist,'.k')
%         xlim([0.5,8.5])
%         ylim([0 0.6])
%         set(gca,'XTickLabel',namesColums);
% 
%         title(strrep(num2str(SR(srImg)),'.','_'))
%         path2save1 = [path2load 'diagram' num2str(initialDiagram) '\polygonsDistributions\polygonDistributionImg\'];
%         mkdir(path2save1)
%         print(h,[path2save1 'polygonDistribution_SR' strrep(num2str(SR(srImg)),'.','_') '.tif'],'-dtiff','-r300')
% 
%         hold off
%         close all
% 
%         dataPolDistAccum = vertcat(polyDisImgAccum{:,srImg});
%         polyDistMatrixAccum = cell2mat(vertcat(dataPolDistAccum(2:2:end,:)));
%         averagePolDistAccum = mean(polyDistMatrixAccum);
%         stdPolDistAccum = std(polyDistMatrixAccum);
%         namesColumsAccum = dataPolDistAccum(1,:);
% 
%         h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
%         hold on
%         bar(averagePolDistAccum);
%         errorbar(averagePolDistAccum,stdPolDistAccum,'.k')
%         set(gca,'XTick',(2:2:length(namesColumsAccum)));
%         set(gca,'XTickLabel',namesColumsAccum(2:2:end));
%         ylim([0,0.5])
% 
%         title(num2str(SR(srImg)))
%         path2save2 = [path2load 'diagram' num2str(initialDiagram) '\polygonsDistributions\polygonDistributionAccum\'];
%         mkdir(path2save2)
%         print(h,[path2save2 'polygonDistributionAccum_SR' strrep(num2str(SR(srImg)),'.','_') '.tif'],'-dtiff','-r300')
% 
%         hold off
%         close all
%         
%                 
%         tablePolDistAccum = [tablePolDistAccum;[SR(srImg) averagePolDistAccum;SR(srImg) stdPolDistAccum]];
%         tablePolDist = [tablePolDist;[SR(srImg) averagePolDist;SR(srImg) stdPolDist]];
%     end
%     tablePolDistAccum = array2table(tablePolDistAccum,'variableNames',[{'surfaceRatio'}, strrep(namesColumsAccum,'-','')]);
%     tablePolDist = array2table(tablePolDist,'variableNames',[{'surfaceRatio'},strrep(namesColums,'-','')]);
%     writetable(tablePolDist,[path2save1 'polygonDistribution_' date 'specialCase.xls'])
%     writetable(tablePolDistAccum,[path2save2 'polygonDistributionAccum_' date 'specialCase.xls'])
end