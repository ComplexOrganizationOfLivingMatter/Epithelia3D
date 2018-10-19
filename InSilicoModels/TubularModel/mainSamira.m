addpath(genpath('src'))
for numImage = 1:10   
    createSamiraFormatExcel(strcat('data\tubularVoronoiModel\expansion\2048x12288_600seeds\Image_', num2str(numImage),'_Diagram_5\'), [1.1111,1.25,1.4286,1.6667,2,2.5,3.3333,5]);
end