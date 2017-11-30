
addpath('libVoronoiSegment')
addpath('libVoronoiSegment\lib')
addpath('lib')

H_apical=1024;
W_apical=512;
numSeeds=100;
numTotalImages=20;
%That is a factor of conversion to reduce the coordinates of the original
%cylinder
reductionFactor=4;
%surface ratio
rBasal=1;
rApical=0.7;
surfaceRatio=rBasal/rApical;
intermediateSurfaceRatios=sort(1.1);

globalAccumulativeMatrix=zeros(numSeeds*numTotalImages,3);

for numImage=1:numTotalImages
    numImage
    %load seeds in apical and the voronoi image in apical
    load(['..\..\data\expansion\512x1024_' num2str(numSeeds) 'seeds\Image_' num2str(numImage) '_Diagram_5\Image_' num2str(numImage) '_Diagram_5.mat'],'listSeedsProjected','listLOriginalProjection')

    initialSeeds=listSeedsProjected.seedsApical{1};
    initialSeeds=initialSeeds(:,2:end);
    
    name2save= ['Image_' num2str(numImage) '_' num2str(numSeeds) 'seeds'];
    tic
    %tridimensional reconstruction info
    [seedsInfo,img3Dfinal,img3DApicalSurface,img3DBasalSurface,img3DIntermediateSurface]=rebuilding3dVoronoiCylinderFromSeedsExpansion( initialSeeds, H_apical, W_apical, surfaceRatio,reductionFactor,intermediateSurfaceRatios,name2save);

    
    %% neighbours
    %%in apical and basal surface
    [neighApical3D,~]=calculate_neighbours3D(img3DApicalSurface);
    [neighBasal3D,~]=calculate_neighbours3D(img3DBasalSurface);
%     [neighApical2D,~]=calculate_neighbours(imgApical);
    
    %in 3D intermediate surfaces
    neighBySurfaceRatio3D=cell(size(img3DIntermediateSurface,1)+2,2);
    for intLayer=2:size(img3DIntermediateSurface,1)+1
        [neighIntermediateSurfaces,~]=calculate_neighbours3D(img3DIntermediateSurface.imageSurfaceLayer{intLayer-1});
        neighBySurfaceRatio3D{intLayer,1}=img3DIntermediateSurface.surfaceRatio(intLayer-1);
        neighBySurfaceRatio3D{intLayer,2}=neighIntermediateSurfaces;
    end
    neighBySurfaceRatio3D{1,1}=1;
    neighBySurfaceRatio3D{1,2}=neighApical3D;
    neighBySurfaceRatio3D{end,1}=surfaceRatio;
    neighBySurfaceRatio3D{end,2}=neighBasal3D;
    neighBySurfaceRatio3D=cell2table(neighBySurfaceRatio3D,'VariableNames',{'surfaceRatio','neighs'});
    
    %% measuring edges
    [ basalDataTransition,apicalDataNoTransition ] = measureAnglesAndLengthOfEdges3Dcylinder( img3DBasalSurface,img3DApicalSurface);

    disp 'a'
    
    toc
end

