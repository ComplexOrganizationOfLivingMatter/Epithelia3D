%warp cylinder
clear all
load('D:\Pablo\Epithelia3D\Salivary Glands\Curvature model\data\Image_10.mat')
close all
uiopen('D:\Pablo\Epithelia3D\Salivary Glands\Curvature model\data\voronoiCylinderSR1_ZoomOut.fig',1)


refFig = gca;
surfaceRatios=[1,3,6,9];
colours = colorcube(50);
colours(1, :) = [0 0 0];
for i=2:length(surfaceRatios)
    %h = figure;
    
    %We put the first cylinder to append the bigger one
    uiopen('D:\Pablo\Epithelia3D\Salivary Glands\Curvature model\data\voronoiCylinderSR1_referenceOK.fig',1)
    hold on;
    Img=cell2mat(listLOriginalProjection.L_originalProjection(surfaceRatios(i)));
    imgRGB=Img;
    [imgRows,imgCols,imgPlanes] = size(imgRGB);
    [X,Y,Z] = cylinder(imgRows,imgCols);
    Z=Z*4000;
    X=X*.2*listLOriginalProjection.surfaceRatio(surfaceRatios(i));Y=Y*0.2*listLOriginalProjection.surfaceRatio(surfaceRatios(i));
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
    print(strcat('cylinder_Alpha_09_Expansion_', num2str(listLOriginalProjection.surfaceRatio(surfaceRatios(i)))), '-dtiff', '-r600');
    hold off;
end