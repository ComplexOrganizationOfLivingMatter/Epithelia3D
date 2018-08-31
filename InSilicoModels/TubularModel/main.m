addpath(genpath('src'))
for numImage = 1:10
    createSamiraFormatExcel(strcat('data\tubularVoronoiModel\expansion\2048x4096_200seeds\Image_', num2str(numImage),'_Diagram_5\'), 1.6667)
end