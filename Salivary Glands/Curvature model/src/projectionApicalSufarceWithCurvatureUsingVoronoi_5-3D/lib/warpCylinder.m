%warp cylinder
clear all
load('D:\Pablo\Epithelia3D\Salivary Glands\Curvature model\data\Image_10.mat')
close all
uiopen('D:\Pablo\Epithelia3D\Salivary Glands\Curvature model\data\voronoiCylinderSR1_ZoomOut.fig',1)

[az, el] = view;
refFig = gca;
surfaceRatios=[1,3,6,9];
colours = colorcube(50);
colours(1, :) = [0 0 0];
for i=1:length(surfaceRatios)
    h = figure;
    Img=cell2mat(listLOriginalProjection.L_originalProjection(surfaceRatios(i)));
    imgRGB=Img;
    [imgRows,imgCols,imgPlanes] = size(imgRGB);
    [X,Y,Z] = cylinder(imgRows,imgCols);
    Z=Z*4000;
    X=X*.2*listLOriginalProjection.surfaceRatio(surfaceRatios(i));Y=Y*0.2*listLOriginalProjection.surfaceRatio(surfaceRatios(i));
    warp(X,Y,Z,imgRGB,colours);
    axis equal
    newFig = gca;
    newFig.CameraPositionMode = refFig.CameraPositionMode;
    newFig.CameraTargetMode = refFig.CameraPositionMode;
    newFig.CameraUpVectorMode = refFig.CameraPositionMode;
    newFig.CameraViewAngleMode = refFig.CameraPositionMode;
    
    newFig.CameraPosition = refFig.CameraPosition;
    newFig.CameraTarget = refFig.CameraTarget;
    newFig.CameraUpVector = refFig.CameraUpVector;
    newFig.CameraViewAngle = refFig.CameraViewAngle;
    
    newFig.Visible = 'off';
    set(get(0,'children'),'Color','w')
    print(strcat('cylinder_', num2str(surfaceRatios(i))), '-dtiff', '-r600');
    %Edge in black
end