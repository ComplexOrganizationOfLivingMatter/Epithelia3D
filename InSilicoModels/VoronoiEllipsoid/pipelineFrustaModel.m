clear
addpath(genpath('src'));
addpath(genpath('lib'));
load('D:\Pablo\Epithelia3D\InSilicoModels\VoronoiEllipsoid\results\Stage 4\random_1_10\random_1\ellipsoid_x12642_y1_z1_cellHeight02216.mat')

initialEllipsoid = getVertices3D( initialEllipsoid.img3DLayer, initialEllipsoid.neighbourhood, initialEllipsoid );

initialEllipsoid.resolutionFactor = ellipsoidInfo.resolutionFactor;
initialEllipsoid.resolutionEllipse = 2000;

[ finalCentroidsAugmented] = getAugmentedCentroids( initialEllipsoid, vertcat(initialEllipsoid.verticesPerCell{:}), ellipsoidInfo.cellHeight);

allFrustaImage = size(ellipsoidInfo.img3DLayer);

for numCell = 1:size(initialEllipsoid.centroids, 1)
    verticesOfActualCell = initialEllipsoid.verticesPerCell(any(ismember(initialEllipsoid.verticesConnectCells, numCell), 2), :);
    verticesOfActualCell = vertcat(verticesOfActualCell{:});
    [k,v] = boundary(verticesOfActualCell(:, 1), verticesOfActualCell(:, 2), verticesOfActualCell(:, 3))
    vertex1
    vertex2
    allFrustaImage = Drawline3D(allFrustaImage, vertex1(1), vertex1(2), vertex1(3), vertex2(1), vertex2(2), vertex2(3), 0);
end
