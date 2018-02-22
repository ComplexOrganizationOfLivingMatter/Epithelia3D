function [ ] = createFrustaModelFromApicalImage(inputFile )
%CREATEFRUSTAMODELFROMAPICALIMAGE Summary of this function goes here
%   Detailed explanation goes here
    load(inputFile);

    disp('Getting vertices 3D');
    %Get vertices info on the apical layer
    initialEllipsoid = getVertices3D( initialEllipsoid.img3DLayer, initialEllipsoid.neighbourhood, initialEllipsoid );

    initialEllipsoid.resolutionFactor = ellipsoidInfo.resolutionFactor;
    initialEllipsoid.resolutionEllipse = 500;

    disp('Getting outter layer vertices');
    %New vertices on basal
    [ finalCentroidsAugmented] = getAugmentedCentroids( initialEllipsoid, vertcat(initialEllipsoid.verticesPerCell{:}), ellipsoidInfo.cellHeight);

    allFrustaImage = initialEllipsoid.img3DLayer;

    colours = colorcube(size(initialEllipsoid.centroids, 1));
    outputFigure = figure;

    % Now we have to get the actual pixels from the faces of the cells
    for numCell = 1:size(initialEllipsoid.centroids, 1)
        disp(['NumCell: ' num2str(numCell)]);
        indicesVerticesOfActualCell = any(ismember(initialEllipsoid.verticesConnectCells, numCell), 2);

        verticesOfActualCell = cell2mat(finalCentroidsAugmented(indicesVerticesOfActualCell, :));

        %Get the faces of the cell
        KVert = convhulln(verticesOfActualCell);

        %Create the appropiate structure for voselise function
        cellStructure.faces = KVert;
        cellStructure.vertices = verticesOfActualCell;

        %Get the pixels of the cell
        [outputGrid,gridCOx,gridCOy,gridCOz] = VOXELISE(max(verticesOfActualCell(:, 1)), max(verticesOfActualCell(:, 2)), max(verticesOfActualCell(:, 3)), cellStructure);

        %[x, y, z] = findND(outputGrid == 1);
        %realPixels = round(vertcat(gridCOx(x), gridCOy(y), gridCOz(z)))';

        %Paint the real pixels on the new image
        realPixels = [];
        for numX = 1:size(outputGrid, 1)
            for numY = 1:size(outputGrid, 2)
                for numZ = 1:size(outputGrid, 3)
                    if outputGrid(numX, numY, numZ)
                        allFrustaImage(gridCOx(numX), gridCOy(numY), gridCOz(numZ)) = numCell;
                        realPixels(end+1, :) = horzcat(gridCOx(numX), gridCOy(numY), gridCOz(numZ));
                    end
                end
            end
        end

        %Paint the cell to check if everything fits
        cellFigure = alphaShape(realPixels(:, 1), realPixels(:, 2), realPixels(:, 3), 500);
        plot(cellFigure, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
        hold on;
    end

    %Save necessary info
    outputFile = strrep(inputFile, 'VoronoiModel', 'FrustaModel');
    outputFileSplitted = strsplit(outputFile, '\');
    outputFileDirectory = strjoin(outputFileSplitted(1:end-1), '\');
    mkdir(outputFileDirectory)

    %savefig(strcat(outputFileDirectory, '\frustaEllipsoidModel_OutterLayer_', date, '.fig'));

    save(strcat(outputFileDirectory, '\frustaEllipsoidModel_', date'), 'allFrustaImage');

    %close outputFigure

end

