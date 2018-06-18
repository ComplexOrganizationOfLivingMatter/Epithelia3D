
addpath(genpath('lib'))

H_initial=4096;
W_initial=2048;
numSeeds=200;
numTotalImages=1;
%That is a factor of conversion to reduce the coordinates of the original
%cylinder
reductionFactor=20;
%surface ratio
surfaceRatio=10;
projectionType='expansion';

for numImage=1:numTotalImages
    %load seeds in apical and the voronoi image in apical   
    load(['..\data\tubularVoronoiModel\' projectionType '\' num2str(W_initial) 'x' num2str(H_initial) '_' num2str(numSeeds) 'seeds\Image_' num2str(numImage) '_Diagram_5\Image_' num2str(numImage) '_Diagram_5.mat'],'listSeedsProjected','listLOriginalProjection')

    initialSeeds=listSeedsProjected.seedsApical{1};
    initialSeeds=initialSeeds(:,2:end);
    dir2save='..\data\tubularVoronoiModel\3Dreconstruction\';
    mkdir(dir2save);
    name2save= [dir2save 'Image_' num2str(numImage) '_' num2str(W_initial) 'x' num2str(H_initial) '_'  num2str(numSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_reductionFactor_' num2str(reductionFactor)];
    disp(name2save)
    
    tic
        %tridimentional reconstruction info
%         [seedsInfo,img3Dfinal]=rebuilding3dVoronoiCylinderFromSeedsExpansion( initialSeeds, H_initial, W_initial, surfaceRatio,reductionFactor,name2save);


        %% neighbours
        
        load(name2save)
        
        %3D
%         [image3DInfo]=calculateNeighbours3D(img3Dfinal);
%         save([name2save '.mat'],'image3DInfo','img3Dfinal','-append');
        
        %2D
%         imgApical=listLOriginalProjection.L_originalProjection{end};
%         [neighApical2D,~]=calculateNeighbours(imgApical);
%         [quartetsOfNeighsApical] = buildQuartetsOfNeighs2D(neighApical2D);
%         [quartetsOfNeighsBasal] = buildQuartetsOfNeighs2D(neighBasal2D);
        quartetsOfNeighs3D = clustersOfNeighs3D(image3DInfo);
            
%         [neighBasal2D,~]=calculateNeighbours(imgApical);
        
        %% Calculate scutoids (intermediate apico-basal plane) vertices

    toc
end

