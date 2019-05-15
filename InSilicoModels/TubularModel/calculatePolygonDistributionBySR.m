% SR = unique([1./(1:-0.1:0.1),2:9]);
initialDiagrams = 8;%[1 8];
% SR = [1 1.75 1.8 1.85];
SR = 1:0.25:10;
nImages = 20;
typeProjection = 'expansion';
% path2load = 'data\tubularVoronoiModel\expansion\512x4096_200seeds\';

addpath(genpath('src'))

for initialDiagram = initialDiagrams
    path2load = ['data\tubularVoronoiModel\' typeProjection '\512x4096_200seeds\diagram' num2str(initialDiagram) '_Markov'];
    polyDisImg = cell(nImages,length(SR));
    polyDisImgAccum = cell(nImages,length(SR));
    percentageScutoids = cell(nImages,length(SR));
    numberWonNeighs = cell(nImages,length(SR));
    numberLostNeighs = cell(nImages,length(SR));
    neighsPerSRPerImg = cell(nImages,length(SR));
    validCellsPerImg = cell(nImages,length(SR));
    for nImg = 1 : nImages

        load([path2load '\Image_' num2str(nImg) '_Diagram_' num2str(initialDiagram) '\Image_' num2str(nImg) '_Diagram_' num2str(initialDiagram) '.mat'],'listLOriginalProjection');

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
        validCellsPerImg{nImg} = validCells;
        neighsAccum = cell(1,max(img(:)));
        
%         load([path2load 'diagram' num2str(initialDiagram) '\Image_' num2str(nImg) '_Diagram_' num2str(initialDiagram) '\Image_' num2str(nImg) '_Diagram_' num2str(initialDiagram) 'specialCase.mat']);
        for srImg = 1:length(SR)

            idImg = [listLOriginalProjection{:,1}]==SR(srImg);
            img = listLOriginalProjection{idImg,2};
            if iscell(img)
               img = img{1}; 
            end
            neighs = calculateNeighbours(img);
            neighsPerSRPerImg{nImg,srImg} = neighs;
            if srImg==1
                neighsInit = neighs;
            end
            neighsAccum = cellfun(@(x,y) unique([x;y]),neighs,neighsAccum,'UniformOutput',false);
            sidesCells = cellfun(@(x) length(x),neighs);
            sidesCellsAccum = cellfun(@(x) length(x),neighsAccum);

            [polyDisImg{nImg,srImg}] = calculate_polygon_distribution( sidesCells, validCells );
            [polyDisImgAccum{nImg,srImg}] = calculate_polygon_distribution( sidesCellsAccum, validCells );

            lostNeigh = cellfun(@(x,y) length(setdiff(x,y)),neighsInit,neighs);
            wonNeigh = cellfun(@(x,y) length(setdiff(y,x)),neighsInit,neighs);
            percentageScutoids{nImg,srImg} = sum(sum([lostNeigh(validCells);wonNeigh(validCells)])>0)/length(validCells);
            numberWonNeighs{nImg,srImg} = wonNeigh;
            numberLostNeighs{nImg,srImg} = lostNeigh;
        end
    end
    mkdir([path2load '\polygonsDistributions\'])
    save([path2load '\polygonsDistributions\dataPolygonDistributionAndPercentageScutoidsSpecial.mat'],'polyDisImg','polyDisImgAccum','percentageScutoids','numberWonNeighs','numberLostNeighs','validCellsPerImg','neighsPerSRPerImg','SR');

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