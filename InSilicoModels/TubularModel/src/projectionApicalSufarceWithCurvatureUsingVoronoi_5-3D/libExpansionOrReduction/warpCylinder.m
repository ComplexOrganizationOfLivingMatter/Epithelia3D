%warp cylinder
clear all
load('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\data\Image_10.mat')
close all
uiopen('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\data\voronoiCylinderSR1_ZoomOut.fig',1)
%uiopen('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\data\voronoiCylinderSR5.fig',1)

refFig = gca;
surfaceRatios=[1,3,6,9];
colours = [0 0 0
0.153846153846154    1    0.846153846153846
0.769230769230769    1    0.230769230769231
0.769230769230769    0    0
0    0    0.615384615384615
1    0.538461538461538    0
1    0.230769230769231    0
0    0.307692307692308    1
0.923076923076923    1    0.0769230769230769
1    0.692307692307692    0
0.230769230769231    1    0.769230769230769
0.692307692307692    0    0
0.846153846153846    1    0.153846153846154
0    0    0.846153846153846
1    0.923076923076923    0
0    0.923076923076923    1
1    0    0
0    0.230769230769231    1
0    0.769230769230769    1
0.846153846153846    0    0
0.538461538461538    1    0.461538461538462
0    0.615384615384615    1
0.615384615384615    1    0.384615384615385
1    0.307692307692308    0
0.923076923076923    0    0
0.692307692307692    1    0.307692307692308
1    1    0
1    0.0769230769230769    0
0    0    0.769230769230769
0.307692307692308    1    0.692307692307692
0    0    0.538461538461538
1    0.846153846153846    0
0.0769230769230769    1    0.923076923076923
0    0.0769230769230769    1
1    0.461538461538462    0
0    0.538461538461538    1
0    0.461538461538462    1
1    0.153846153846154    0
1    0.615384615384615    0
0    0.384615384615385    1
0    0.846153846153846    1
1    0.384615384615385    0
1    0.769230769230769    0
0    0.153846153846154    1
0    1    1
0    0    1
0.384615384615385    1    0.615384615384615
0    0    0.923076923076923
0    0.692307692307692    1
0    0    0.692307692307692];

colours = repmat(colours, 8, 1);

for i=1:length(surfaceRatios)
    h = figure;
    
    %We put the first cylinder to append the bigger one
    %uiopen('D:\Pablo\Epithelia3D\Salivary Glands\Curvature model\data\voronoiCylinderSR1_referenceOK.fig',1)
    %hold on;
    Img=cell2mat(listLOriginalProjection.L_originalProjection(surfaceRatios(i)));
    imgRGB=Img;
    [imgRows,imgCols,imgPlanes] = size(imgRGB);
    [X,Y,Z] = cylinder(imgRows,imgCols);
    Z=Z*4000;
    X=X*.2*listLOriginalProjection.surfaceRatio(surfaceRatios(i));
    Y=Y*0.2*listLOriginalProjection.surfaceRatio(surfaceRatios(i));
    hRef = warp(X,Y,Z,imgRGB,colours);
    hRef.FaceAlpha = 0.9;
    axis equal
    newFig = gca;
    newFig.CameraPositionMode = refFig.CameraPositionMode;
    newFig.CameraTargetMode = refFig.CameraPositionMode;
    newFig.CameraUpVectorMode = refFig.CameraPositionMode;
    newFig.CameraViewAngleMode = refFig.CameraPositionMode;
    
    newFig.CameraPosition = refFig.CameraPosition;
    %newFig.CameraTarget = refFig.CameraTarget;
    newFig.CameraUpVector = refFig.CameraUpVector;
    newFig.CameraViewAngle = refFig.CameraViewAngle;
    
    newFig.Visible = 'off';
    set(get(0,'children'),'Color','w')
    print(strcat('cylinder_With2Cylinders_Expansion_', num2str(listLOriginalProjection.surfaceRatio(surfaceRatios(i))), '_', date), '-dtiff', '-r600');
    hold off;
end