addpath(genpath('lib'))

filePathStage4='results\Stage 4\';

load([filePathStage4 'random_1\ellipsoid_x12642_y1_z1_cellHeight02216.mat'],'ellipsoidInfo','initialEllipsoid')

round([initialEllipsoid.xCenter,initialEllipsoid.yCenter,initialEllipsoid.zCenter]*initialEllipsoid.resolutionEllipse);

[H,W,c]=size(initialEllipsoid.img3DLayer);
x0=[0 round([initialEllipsoid.yCenter,initialEllipsoid.zCenter]*initialEllipsoid.resolutionEllipse)];
u=[H,0,0];
deg=45;

newPixels = {};
figure;
colours = colorcube(size(initialEllipsoid.cellArea, 1));


for numCell = 1:size(initialEllipsoid.cellArea, 1)
    [x, y, z] = findND(initialEllipsoid.img3DLayer == numCell);
    XYZOld = horzcat(x, y, z)';
    [XYZnew, R, t] = AxelRot(XYZOld, deg, u, x0);
    XYZnew = XYZnew';
    newPixels(numCell) = {XYZnew};
%     cellFigure = alphaShape(XYZnew(:, 1), XYZnew(:, 2), XYZnew(:, 3), 500);
%     plot(cellFigure, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
%     hold on;
end




allPixels = vertcat(newPixels{:});
newImage = zeros(size(initialEllipsoid.img3DLayer), 'uint16');
for numCell = 1:size(initialEllipsoid.cellArea, 1)
    actualPixels = round(newPixels{numCell});
    for numPixel = 1:size(actualPixels, 1)
        newImage(actualPixels(numPixel, 1), actualPixels(numPixel, 2), actualPixels(numPixel, 3)) = numCell;
    end
end

%save rotated image

