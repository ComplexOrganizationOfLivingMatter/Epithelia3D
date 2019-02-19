addpath(genpath('src'))
surfRatios = 1:0.25:5;
numSeeds = 1000;
wImg = 2048;
hImg = 10240;
path2load = ['data\tubularVoronoiModel\expansion\' num2str(wImg) 'x' num2str(hImg) '_' num2str(numSeeds) 'seeds\diagram' num2str(initialDiagram) '\'];
numRealizations = 20;
initialDiagram = 5;

for numImage = 1 : numRealizations
    createSamiraFormatExcel_Simulations([path2load 'Image_' num2str(numImage) '_Diagram_' num2str(initialDiagram) '\'], surfRatios);
end