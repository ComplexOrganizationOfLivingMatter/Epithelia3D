clear
addpath(genpath('src'));
addpath(genpath('lib'));
load('D:\Pablo\Epithelia3D\InSilicoModels\VoronoiEllipsoid\results\Stage 4\random_1_10\random_1\ellipsoid_x12642_y1_z1_cellHeight02216.mat')

initialEllipsoid = getVertices3D( initialEllipsoid.img3DLayer, initialEllipsoid.neighbourhood, initialEllipsoid );

initialEllipsoid.resolutionFactor = ellipsoidInfo.resolutionFactor;
initialEllipsoid.resolutionEllipse = 2000;

[ finalCentroidsAugmented] = getAugmentedCentroids( initialEllipsoid, vertcat(initialEllipsoid.verticesPerCell{:}), ellipsoidInfo.cellHeight);
