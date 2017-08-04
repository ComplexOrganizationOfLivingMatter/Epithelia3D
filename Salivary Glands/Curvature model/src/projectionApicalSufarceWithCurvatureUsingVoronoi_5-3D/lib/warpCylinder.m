%warp cylinder
surfaceRatios=[1,3,6,9];
for i=1:length(surfaceRatios)
    figure;
    Img=cell2mat(listLOriginalProjection.L_originalProjection(surfaceRatios(i)));
    imgRGB=Img;
    [imgRows,imgCols,imgPlanes] = size(imgRGB);
    [X,Y,Z] = cylinder(imgRows,imgCols);
    Z=Z*4000;
    X=X*.2*listLOriginalProjection.surfaceRatio(surfaceRatios(i));Y=Y*0.2*listLOriginalProjection.surfaceRatio(surfaceRatios(i));
    warp(X,Y,Z,imgRGB,colormap(colorcube(50)));
    axis equal
end