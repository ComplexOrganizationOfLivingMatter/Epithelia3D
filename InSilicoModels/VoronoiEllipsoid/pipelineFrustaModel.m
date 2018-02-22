clear
addpath(genpath('src'));
addpath(genpath('lib'));

resultFiles = getAllFiles('results/');
ellipsoidFiles = resultFiles(cellfun(@(x) isempty(strfind(x, '.mat')) == 0 & isempty(strfind(x, 'ellipsoid_x')) == 0, resultFiles));

for numEllipsoid = 1:size(ellipsoidFiles, 1)
    disp(['NumEllipsoid: ' num2str(numEllipsoid)]);
    %load('D:\Pablo\Epithelia3D\InSilicoModels\VoronoiEllipsoid\results\Stage 4\random_1_10\random_1\ellipsoid_x12642_y1_z1_cellHeight02216.mat')
    inputFile = ellipsoidFiles{numEllipsoid};
    load(inputFile);

    %Get vertices info on the apical layer
    initialEllipsoid = getVertices3D( initialEllipsoid.img3DLayer, initialEllipsoid.neighbourhood, initialEllipsoid );

    initialEllipsoid.resolutionFactor = ellipsoidInfo.resolutionFactor;
    initialEllipsoid.resolutionEllipse = 500;

    %New vertices on basal
    [ finalCentroidsAugmented] = getAugmentedCentroids( initialEllipsoid, vertcat(initialEllipsoid.verticesPerCell{:}), ellipsoidInfo.cellHeight);

    allFrustaImage = initialEllipsoid.img3DLayer;

    colours = colorcube(size(centroids, 1));
    outputFigure = figure;

    % Now we have to get the actual pixels from the faces of the cells
    for numCell = 1:size(initialEllipsoid.centroids, 1)
        disp(['NumCell: ' num2str(numEllipsoid)]);
        indicesVerticesOfActualCell = find(any(ismember(initialEllipsoid.verticesConnectCells, numCell), 2));

        verticesConnectingCellsOfActualCell = initialEllipsoid.verticesConnectCells(indicesVerticesOfActualCell, :);
        verticesOfActualCell = cell2mat(initialEllipsoid.verticesPerCell(indicesVerticesOfActualCell, :));

        %Get the faces of the cell
        KVert = convhulln(verticesOfActualCell);

        %Create the appropiate structure for voselise function
        cellStructure.faces = KVert;
        cellStructure.vertices = verticesOfActualCell;

        %Get the pixels of the cell
        [outputGrid,gridCOx,gridCOy,gridCOz] = VOXELISE(max(verticesOfActualCell(:, 1)), max(verticesOfActualCell(:, 2)), max(verticesOfActualCell(:, 3)), cellStructure);

        [x, y, z] = findND(outputGrid == 1);

        realPixels = unique(round(vertcat(gridCOx(x), gridCOy(y), gridCOz(z)))', 'rows');

        %Paint the real pixels on the new image
        for numPixel = 1:size(realPixels, 1)
            allFrustaImage(realPixels(numPixel, 1), realPixels(numPixel, 2), realPixels(numPixel, 3)) = numCell;
        end

        %Paint the cell to check if everything fits
        cellFigure = alphaShape(realPixels(numPixel, 1), realPixels(numPixel, 2), realPixels(numPixel, 3), 500);
        plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
        hold on;
    end
    
    %Save necessary info
    outputFile = strrep(inputFile, 'VoronoiModel', 'FrustaModel');
    outputFileSplitted = strsplit(outputFile, '\');
    outputFileDirectory = strjoin(outputFile(1:end-1), '\');
    mkdir(outputFileDirectory)
    
    savefig(strcat(outputFileDirectory, '\frustaEllipsoidModel_OutterLayer_', date, '.fig'));
    
    save(strcat(outputFileDirectory, '\frustaEllipsoidModel_', date'), 'allFrustaImage');
    
    close outputFigure
end


