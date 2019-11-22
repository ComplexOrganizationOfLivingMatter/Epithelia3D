addpath(genpath('src'))
%always include the surface ratio 1
surfRatios = 1:0.25:10;
numSeeds = 200;
wImg = 512;
hImg = 4096;
numRealizations = 20;
%initialDiagram = 1;
setDiagrams = [2:10,1];
path2load = ['data\tubularVoronoiModel\expansion\' num2str(wImg) 'x' num2str(hImg) '_' num2str(numSeeds) 'seeds\diagram' num2str(initialDiagram) '_Markov\'];

for initialDiagram=setDiagrams
    delete(gcp('nocreate'))
    %parpool(7);
    parfor numImage = 1 : numRealizations
        createSamiraFormatExcel_delaunaySimulations([path2load 'Image_' num2str(numImage) '_Diagram_' num2str(initialDiagram) '\'], surfRatios,hImg,wImg);
    end
end