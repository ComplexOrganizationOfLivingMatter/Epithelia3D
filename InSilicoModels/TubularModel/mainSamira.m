addpath(genpath('src'))
%always include the surface ratio 1
surfRatios = 1:0.25:5;
numSeeds = 400;
wImg = 1024;
hImg = 4096;
numRealizations = 20;
initialDiagram = 5;
path2load = ['data\tubularVoronoiModel\expansion\' num2str(wImg) 'x' num2str(hImg) '_' num2str(numSeeds) 'seeds\diagram' num2str(initialDiagram) '\'];

parfor numImage = 1 : numRealizations
    createSamiraFormatExcel_delaunaySimulations([path2load 'Image_' num2str(numImage) '_Diagram_' num2str(initialDiagram) '\'], surfRatios,hImg,wImg);
end