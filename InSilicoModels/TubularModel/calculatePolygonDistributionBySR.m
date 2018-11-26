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

save([path2load 'diagram' num2str(initialDiagram) '\polygonsDistributions\'],'polyDisImg');

for nImg = 1 : nImages
    
        vertcat(polyDisImg)
    
end