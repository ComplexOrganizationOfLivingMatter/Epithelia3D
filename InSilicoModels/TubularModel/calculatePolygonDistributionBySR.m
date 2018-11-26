SR = unique([1./(1:-0.1:0.1),4:15]);
initialDiagram = 1;
nImages = 20;
path2load = '..\data\tubularVoronoiModel\expansion\512x4096_200seeds\';
addpath(genpath('..'))

polyDisImg = cell(nImages,length(SR));
for nImg = 1 : nImages

    load([path2load 'diagram' num2str(initialDiagram) '\Image_' num2str(nImg) '_Diagram_' num2str(initialDiagram) '\Image_' num2str(nImg) '_Diagram_' num2str(initialDiagram) '.mat'])
    idImg = [listLOriginalProjection{:,1}]==SR(end);
    img = listLOriginalProjection{idImg,2};
    noValidCells = unique([img(1,:),img(end,:)]);
    validCells = setdiff(unique(img),noValidCells);
    
    parfor srImg = 1:length(SR)
        
        idImg = [listLOriginalProjection{:,1}]==SR(srImg);
        img = listLOriginalProjection{idImg,2};
        neighs = calculateNeighbours(img);
        sidesCells = cellfun(@(x) length(x),neighs);
        [polyDisImg{nImg,srImg}] = calculate_polygon_distribution( sidesCells, validCells );
         
    end
end

save([path2load 'diagram' num2str(initialDiagram) '\polygonsDistributions\dataPolygonDistribution.mat'],'polyDisImg');

for srImg = 1:length(SR)
     
    dataPolDist = vertcat(polyDisImg{:,srImg});
    polyDistMatrix = cell2mat(vertcat(dataPolDist(2:2:end,:)));
    averagePolDist = mean(polyDistMatrix);
    stdPolDist = std(polyDistMatrix);
    namesColums = dataPolDist(1,:);
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
    hold on
    bar(averagePolDist);
    errorbar(averagePolDist,stdPolDist,'.k')
    xlim([0.5,8.5])
    set(gca,'XTickLabel',namesColums);
    
    title(strrep(num2str(SR(srImg)),'.','_'))
    print(h,[path2load 'diagram' num2str(initialDiagram) '\polygonsDistributions\polygonDistribution_SR' strrep(num2str(SR(srImg)),'.','_') '.tif'],'-dtiff','-r300')
     
    hold off
    close all
end