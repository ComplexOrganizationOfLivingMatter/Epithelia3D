%%Stl tube building
H_apical = 512;
W_apical = 1024;
numSeeds = 40;
numTotalImages = 1;
reductionFactor = 3;
intermediateSurfaceRatios = [];
initialDiagram = 8;
typeProjection = 'expansion';
% colors = winter(numSeeds);
% colors = colors(randperm(numSeeds),:);

colorsFix = [0 0.769230769230769 0.615384615384615;0 0.230769230769231 0.884615384615385;0 0.743589743589744 0.628205128205128;0 0.384615384615385 0.807692307692308;0 0.0512820512820513 0.974358974358974;0 0.666666666666667 0.666666666666667;0 0 1;0 0.512820512820513 0.743589743589744;0 0.717948717948718 0.641025641025641;0 0.564102564102564 0.717948717948718;0 0.128205128205128 0.935897435897436;0 0.333333333333333 0.833333333333333;0 0.974358974358974 0.512820512820513;0 0.410256410256410 0.794871794871795;0 0.923076923076923 0.538461538461538;0 0.641025641025641 0.679487179487180;0 0.205128205128205 0.897435897435898;0 0.487179487179487 0.756410256410256;0 0.102564102564103 0.948717948717949;0 0.538461538461538 0.730769230769231;0 0.282051282051282 0.858974358974359;0 1 0.500000000000000;0 0.589743589743590 0.705128205128205;0 0.435897435897436 0.782051282051282;0 0.871794871794872 0.564102564102564;0 0.615384615384615 0.692307692307692;0 0.820512820512821 0.589743589743590;0 0.461538461538462 0.769230769230769;0 0.0769230769230769 0.961538461538462;0 0.846153846153846 0.576923076923077;0 0.0256410256410256 0.987179487179487;0 0.256410256410256 0.871794871794872;0 0.692307692307692 0.653846153846154;0 0.948717948717949 0.525641025641026;0 0.794871794871795 0.602564102564103;0 0.897435897435898 0.551282051282051;0 0.358974358974359 0.820512820512821;0 0.307692307692308 0.846153846153846;0 0.153846153846154 0.923076923076923;0 0.179487179487180 0.910256410256410];

path2Work = ['data\tubularVoronoiModel\expansion\' num2str(H_apical) 'x' num2str(W_apical) '_' num2str(numSeeds) 'seeds\diagram' num2str(initialDiagram) '\Image_1_Diagram_' num2str(initialDiagram) '\'];

nameFigRef = [path2Work 'sr5_reductionFactor3\sr5_04-Dec-2019.fig'];
hRef=openfig(nameFigRef);
refFig = gca;

delete(gcp('nocreate'))
parpool(4);
surfaceRatios = [4.5,4,3.5,3,2.5,2,1.75,1.5,1.25];

for nSr = 1:length(surfaceRatios)
    
    surfaceRatio = surfaceRatios(nSr);
    
    path2save = [path2Work 'sr' num2str(surfaceRatio) '_reductionFactor' num2str(reductionFactor) '\stlInfo\'];
    nameFig = [path2Work 'sr' num2str(surfaceRatio) '_reductionFactor' num2str(reductionFactor) '\sr' num2str(surfaceRatio) '_' date '.fig'];
    
    addpath(genpath('beforePaperCode\srcBeforePaperCode\projectionSurfaceVoronoi5\'));
    addpath(genpath('src'))
    % tic
%     main3dVoronoiSegmentCylinder(H_apical,W_apical,numSeeds,numTotalImages,surfaceRatio,intermediateSurfaceRatios,reductionFactor,initialDiagram,typeProjection,path2save);
    h=paint3DVoronoiTubes(path2save,numSeeds,colorsFix);


    newFig = gca;
    newFig.XScale = refFig.XScale;
    newFig.YScale = refFig.YScale;
    newFig.ZScale = refFig.ZScale;    
    newFig.CameraPositionMode = refFig.CameraPositionMode;
    newFig.CameraTargetMode = refFig.CameraTargetMode;
    newFig.CameraUpVectorMode = refFig.CameraUpVectorMode;
    newFig.CameraViewAngleMode = refFig.CameraViewAngleMode;
    newFig.AmbientLightColor = refFig.AmbientLightColor;
    newFig.CameraPosition = refFig.CameraPosition;
    newFig.CameraUpVector = refFig.CameraUpVector;
    newFig.CameraViewAngle = refFig.CameraViewAngle;
    set(gca,'color','none')
    axis off
    camproj('perspective')
    lighting gouraud
    material dull
    savefig(h,nameFig);
    print(h,'-dpdf','-r600',strrep(nameFig,['_' date '.fig'],['_' date '.pdf']))
end