function [ output_args ] = layerVoronoi( seedsInitial )
%LAYERVORONOI Summary of this function goes here
%   Detailed explanation goes here
    pxWidth = 0.6165279;
    pxDepth = 1.2098982;

    seeds = [];

    seeds(:, 1) = seedsInitial(:, 2) * pxWidth;
    seeds(:, 2) = seedsInitial(:, 3) * pxWidth;
    seeds(:, 3) = seedsInitial(:, 1) * pxDepth;

    seeds(:, 1) = seeds(:, 1) - min(seeds(:, 1)) + 1;
    seeds(:, 2) = seeds(:, 2) - min(seeds(:, 2)) + 1;
    seeds(:, 3) = seeds(:, 3) - min(seeds(:, 3)) + 1;

    seeds = round(seeds);

    %We put the intial seeds on the voronoi 3D image
    img3D = zeros(max(seeds) + 1);
    for numSeed = 1:size(seeds, 1)
        actualSeed = seeds(numSeed, :);
        img3D(actualSeed(1), actualSeed(2), actualSeed(3)) = 1;
    end
    imgDist = bwdist(img3D);
    
    %We create the shape in which the voronoi will be embedded
    shapeOfSeeds = alphaShape(seeds(:, 1), seeds(:, 2), seeds(:, 3), 100);
    %plot(shapeOfSeeds);

    img3DActual = zeros(max(seeds) + 1);

    [xPx, yPx, zPx] = findND(img3DActual == 0);
    badPxs = shapeOfSeeds.inShape(xPx, yPx, zPx);

    for numBadPxs = 1:size(badPxs, 1)
        if badPxs(numBadPxs) == 0
            imgDist(xPx(numBadPxs), yPx(numBadPxs), zPx(numBadPxs)) = 0;
        end
    end
    imgDistDilated = imdilate(imgDist, strel('disk', 5));
    imgDist(imgDistDilated == 0) = 0;

    img3DLabelled = zeros(max(seeds) + 1);
    colours = colorcube(size(seeds, 1));
    figure;
    for numSeed = 1:size(seeds, 1)
        numSeed
        actualSeed = seeds(numSeed, :);
        img3DActual(actualSeed(1), actualSeed(2), actualSeed(3)) = 1;
        imgDistPerSeed = bwdist(img3DActual);
        regionActual = imgDistPerSeed == imgDist;
        img3DLabelled(regionActual) = numSeed;
        img3DActual(actualSeed(1), actualSeed(2), actualSeed(3)) = 0;

        [x, y, z] = findND(img3DLabelled == numSeed);
        cellFigure = alphaShape(x, y, z, 2);
        plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
        hold on;

        seedsInfo(numSeed).ID = numSeed;
        seedsInfo(numSeed).region = regionActual;
        seedsInfo(numSeed).volume = cellFigure.volume;
        seedsInfo(numSeed).colour = colours(numSeed, :);
        seedsInfo(numSeed).pxCoordinates = [x, y, z];
        seedsInfo(numSeed).cellHeight = max(z) - min(z);
    end

    save(strcat('..\..\results\layerAnalysisVoronoi_', date, '.mat'), 'img3DLabelled', 'seedsInfo', '-v7.3');

    colorR = repmat(colorcube(255), 4, 1);

    for numZ = 1:size(img3DLabelled, 3)
        img = double(img3DLabelled(:, :, numZ));
        fig=figure('Visible','off');
        imshow(img,colorR)
        print('-f1','-dbmp',['img_z_' num2str(numZ)  '.bmp']);
        close all
    %     imwrite(img, colorR(1:255, :), strcat('img_z_', num2str(numZ) , '.tiff'));
    end

end

