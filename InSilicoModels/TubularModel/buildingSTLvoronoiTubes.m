%%Stl tube building
H_apical = 512;
W_apical = 4096;
numSeeds = 200;
numTotalImages = 1;
reductionFactor = 2;
% surfaceRatio = 5;
intermediateSurfaceRatios = [];
initialDiagram = 8;
typeProjection = 'expansion';
colors = winter(numSeeds);
colors = colors(randperm(numSeeds),:);

% nameFig = ['data\tubularVoronoiModel\expansion\' num2str(H_apical) 'x' num2str(W_apical) '_' num2str(numSeeds) 'seeds\Image_1_Diagram_8\sr2.fig'];
nameFig = ['data\tubularVoronoiModel\expansion\' num2str(H_apical) 'x' num2str(W_apical) '_' num2str(numSeeds) 'seeds\diagram' num2str(initialDiagram) '\Image_1_Diagram_' num2str(initialDiagram) '\sr4.fig'];
h=openfig(nameFig);
lighting gouraud
material dull
print(h,'-dpdf','-r300',strrep(nameFig,'.fig','.pdf'))
% set(gca,'color','none')
% axis off
refFig = gca;

for surfaceRatio = [1.8]%,4]
    
    path2save = ['data\tubularVoronoiModel\expansion\' num2str(H_apical) 'x' num2str(W_apical) '_' num2str(numSeeds) 'seeds\diagram' num2str(initialDiagram) '\stlInfo\SR' num2str(surfaceRatio) '\'];

    addpath(genpath('beforePaperCode\srcBeforePaperCode\projectionSurfaceVoronoi5\'));
    addpath(genpath('src'))
    % tic
%     main3dVoronoiSegmentCylinder(H_apical,W_apical,numSeeds,numTotalImages,surfaceRatio,intermediateSurfaceRatios,reductionFactor,initialDiagram,typeProjection,path2save);
%     h=paint3DVoronoiTubes(path2save,numSeeds,colors);
%     
%     % toc
    h=openfig(strrep(nameFig,'sr4','sr1.8'));

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
    nameSaveFig = strrep(nameFig,'sr4.fig',['sr' num2str(surfaceRatio) '.fig']);
    savefig(h,nameSaveFig);
    print(h,'-dpdf','-r300',strrep(nameSaveFig,'.fig','.pdf'))
end