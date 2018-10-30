%warp cylinder

%clear all
%load('D:\Pedro\Epithelia3D\InSilicoModels\TubularModel\data\expansion\512x1024_100seeds\Image_1_Diagram_5\Image_1_Diagram_5.mat')
%close all
%uiopen('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\data\voronoiCylinderSR1_ZoomOut.fig',1)
%uiopen('D:\Pablo\Epithelia3D\InSilicoModels\TubularModel\data\voronoiCylinderSR5.fig',1)

%uiopen('D:\Pablo\Epithelia3D\Graphics\data\cylinder_200seeds_SR1_referenceOK_03_04_2018.fig',1)
uiopen('D:\Pablo\Epithelia3D\Graphics\data\cylinder_4x_200seeds_SR1_referenceOK_04_04_2018.fig',1)

refFig = gca;
surfaceRatios=[9];
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
    
    actualSR = listLOriginalProjection.surfaceRatio(surfaceRatios(i));
    %We put the first cylinder to append the bigger one
    %uiopen('D:\Pablo\Epithelia3D\Graphics\data\cylinder_200seeds_SR1_referenceOK_03_04_2018.fig',1)
    uiopen('D:\Pablo\Epithelia3D\Graphics\data\cylinder_4x_200seeds_SR1_referenceOK_04_04_2018.fig',1)
    hold on;
    %Img=cell2mat(listLOriginalProjection.L_originalProjection(surfaceRatios(i)));
    
    originalImage = listLOriginalProjection.L_originalProjection{1};
    imgRGB=imresize(originalImage, [size(originalImage, 1), size(originalImage, 2)*actualSR], 'nearest');
    
    %imgRGB = Img;
    imgRGB = imgRGB((end/4):(end/2), :);
    
    [imgRows,imgCols,imgPlanes] = size(imgRGB);
    [X,Y,Z] = cylinder(imgRows,imgCols);
    Z=Z*4000;
    %Z=Z*4000*3;
    X=X*0.2*actualSR;
    Y=Y*0.2*actualSR;
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
    print(strcat('cylinder_With2Cylinders_Frusta_Expansion_', num2str(actualSR), '_', date), '-dtiff', '-r600');
    hold off;
end