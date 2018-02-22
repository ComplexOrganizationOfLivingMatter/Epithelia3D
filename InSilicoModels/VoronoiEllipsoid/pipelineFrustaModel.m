clear
addpath(genpath('src'));
addpath(genpath('lib'));
load('D:\Pablo\Epithelia3D\InSilicoModels\VoronoiEllipsoid\results\Stage 4\random_1_10\random_1\ellipsoid_x12642_y1_z1_cellHeight02216.mat')

initialEllipsoid = getVertices3D( initialEllipsoid.img3DLayer, initialEllipsoid.neighbourhood, initialEllipsoid );

initialEllipsoid.resolutionFactor = ellipsoidInfo.resolutionFactor;
initialEllipsoid.resolutionEllipse = 1000;

[ finalCentroidsAugmented] = getAugmentedCentroids( initialEllipsoid, vertcat(initialEllipsoid.verticesPerCell{:}), ellipsoidInfo.cellHeight);

allFrustaImage = zeros(size(ellipsoidInfo.img3DLayer), 'uint16');


colours = colorcube(size(centroids, 1));
figure;

for numCell = 1:size(initialEllipsoid.centroids, 1)
    numCell
    indicesVerticesOfActualCell = find(any(ismember(initialEllipsoid.verticesConnectCells, numCell), 2));
    
    verticesConnectingCellsOfActualCell = initialEllipsoid.verticesConnectCells(indicesVerticesOfActualCell, :);
    verticesOfActualCell = cell2mat(initialEllipsoid.verticesPerCell(indicesVerticesOfActualCell, :));
    
    KVert = convhulln(verticesOfActualCell);
    
    fv.faces = KVert;
    fv.vertices = verticesOfActualCell;
    
    [outputGrid,gridCOx,gridCOy,gridCOz] = VOXELISE(max(verticesOfActualCell(:, 1)), max(verticesOfActualCell(:, 2)), max(verticesOfActualCell(:, 3)), fv);
    
    [x, y, z] = findND(outputGrid == 1);
    
    realPixels = unique(round(vertcat(gridCOx(x), gridCOy(y), gridCOz(z)))', 'rows');
    
    for numPixel = 1:size(realPixels, 1)
        allFrustaImage(realPixels(numPixel, 1), realPixels(numPixel, 2), realPixels(numPixel, 3)) = numCell;
    end
    
    cellFigure = alphaShape(realPixels(numPixel, 1), realPixels(numPixel, 2), realPixels(numPixel, 3), 500);
    plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
    hold on;
    
%     figure;
%     boundaryShaped = alphaShape(realPixels(:, 1), realPixels(:, 2), realPixels(:, 3));
%     plot(boundaryShaped);
    
%    verticesConnectingCellsOfActualCell = mat2cell(verticesConnectingCellsOfActualCell, ones(size(verticesConnectingCellsOfActualCell, 1), 1));
    
%    verticesConnectingCellsOfActualCell = cell2mat(cellfun(@(x) x(x ~= numCell), verticesConnectingCellsOfActualCell, 'UniformOutput', false));
%     for numVertex = 1:size(verticesConnectingCellsOfActualCell, 1)
%         vertex1 = double(initialEllipsoid.verticesPerCell{verticesConnectingCellsOfActualCell(numVertex, 1)});
%         vertex2 = double(initialEllipsoid.verticesPerCell{verticesConnectingCellsOfActualCell(numVertex, 2)});
%         allFrustaImage = Drawline3D(allFrustaImage, vertex1(1), vertex1(2), vertex1(3), vertex2(1), vertex2(2), vertex2(3), 0);
%     end
end


