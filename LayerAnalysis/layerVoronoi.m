function [ output_args ] = layerVoronoi( infoCentroids, numLayer, maxFrame )
%LAYERVORONOI Summary of this function goes here
%   Detailed explanation goes here
    pxWidth = 0.6165279;
    %pxDepth = 1.2098982;
%     pxWidth = 0.2;
    
    outputDir = strcat('..\..\results\LayerAnalysis\Layer_', numLayer, '\');
    mkdir(outputDir);

    seeds = [];
    cellIds = vertcat(infoCentroids{:, 1});
    seedsInitial = vertcat(infoCentroids{:, 2});
    seeds(:, 1) = seedsInitial(:, 1) * pxWidth;
    seeds(:, 2) = seedsInitial(:, 2) * pxWidth;
    
    widthMax=max(max(seeds(:, 1:2)));
    seeds(:, 3) = seedsInitial(:, 3) * (widthMax/maxFrame);

    seeds(:, 1) = seeds(:, 1) - min(seeds(:, 1)) + 1;
    seeds(:, 2) = seeds(:, 2) - min(seeds(:, 2)) + 1;
    seeds(:, 3) = seeds(:, 3) - min(seeds(:, 3)) + 1;

    seeds = round(seeds);

    %We put the intial seeds on the voronoi 3D image
    img3D = zeros(max(seeds) + 1);
    for numCell = 1:max(cellIds)
        seedsOfCell = seeds(cellIds == numCell, :);
        for numSeed = 1:size(seedsOfCell, 1)
            actualSeed = seedsOfCell(numSeed, :);
            img3D(actualSeed(1), actualSeed(2), actualSeed(3)) = numCell;
        end
    end
    imgDist = bwdist(img3D);
    
    %We create the shape in which the voronoi will be embedded
    shapeOfSeeds = alphaShape(seeds(:, 1), seeds(:, 2), seeds(:, 3), 500);
    %plot(shapeOfSeeds);

    img3DActual = zeros(max(seeds) + 1);
    %Remove pixels outside the cells area
    [xPx, yPx, zPx] = findND(img3DActual==0);
    validPxs = shapeOfSeeds.inShape(xPx, yPx, zPx);
    imgDist(validPxs==0)=0;
%     
%     [xPxs, yPxs, zPxs] = findND(validPxs == 1);
%     for numBadPxs = size(validPxs, 1):-1:1
%         if validPxs(numBadPxs) == 0
%             numBadPxs
%             imgDist(xPx(numBadPxs), yPx(numBadPxs), zPx(numBadPxs)) = 0;
%         end
%     end

    %Create voronoi 3D region and paint it
    img3DLabelled = zeros(max(seeds) + 1);
    colours = colorcube(max(cellIds));
    figure;
%    seedsInfo = [];
    for numCell = 1:max(cellIds)
        numCell
        img3DActual(img3D == numCell) = 1;
        imgDistPerSeed = bwdist(img3DActual);
        regionActual = imgDistPerSeed == imgDist;
        img3DLabelled(regionActual) = numCell;
        img3DActual(img3D == numCell) = 0;

        [x, y, z] = findND(bwperim(img3DLabelled == numCell));
        cellFigure = alphaShape(x, y, z, 10);
        plot(cellFigure, 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
        hold on;

%         seedsInfo(numSeed).ID = numSeed;
%         seedsInfo(numSeed).region = regionActual;
%         seedsInfo(numSeed).volume = cellFigure.volume;
%         seedsInfo(numSeed).colour = colours(numSeed, :);
%         seedsInfo(numSeed).pxCoordinates = [x, y, z];
%         seedsInfo(numSeed).cellHeight = max(z) - min(z);
    end

    save(strcat(outputDir, 'layerAnalysisVoronoi_', date, '.mat'), 'img3DLabelled');
    savefig(strcat(outputDir, 'layerAnalysisVoronoi_', date, '.fig'));
    colorR = repmat(colorcube(255), 10, 1);
    close all
    for numZ = 1:size(img3DLabelled, 3)
        img = double(img3DLabelled(:, :, numZ));
        fig=figure('Visible','off');
        imshow(img,colorR)
        print('-f1','-dbmp',[outputDir, 'img_z_' num2str(numZ)  '.bmp']);
        close all
    %     imwrite(img, colorR(1:255, :), strcat('img_z_', num2str(numZ) , '.tiff'));
    end

end

