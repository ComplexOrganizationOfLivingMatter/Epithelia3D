function [ img3DLabelled, ellipsoidInfo, newOrderOfCentroids ] = create3DVoronoiFromCentroids( centroids,  augmentedCentroids, cellHeight, ellipsoidInfo, outputDir)
%CREATE3DVORONOIFROMCENTROIDS Summary of this function goes here
%   Detailed explanation goes here

    % This will be used to increase the resolution of the pixel location
    % Because a pixel location has multiple decimals, when we round it 
    % we are simplifying it. This is done to avoid that.
    ellipsoidInfo.resolutionFactor = 180; %300 is fair. 180 for sphere, rugby and globe

    centroids = round(centroids * ellipsoidInfo.resolutionFactor) + 1;
    augmentedCentroids = round(augmentedCentroids * ellipsoidInfo.resolutionFactor) + 1;
    
    % We've try to do the 3D matrix sparse... but only exists 2D sparse
    % matrices. The implemented methods for the N-D sparse matrix are weak
    % and not sufficient (ndSparse).
    img3D = zeros(round(max(augmentedCentroids)) + ((ellipsoidInfo.resolutionFactor)/10), 'uint8');

    %%img3D = ndSparse.build(max(augmentedCentroids)+1);
    
    %[allXs2, allYs2, allZs2] = findND(img3D == 0); %% BIGGEST RAM PROBLEM
    pixelsPerX = {};
    xs = ones(size(img3D, 2)*size(img3D, 1), 1, 'uint16');
    for numZ = 1:size(img3D, 3)
        imgActual = img3D(:, :, numZ);
        [y, z] = find(imgActual == 0);
        pixelsPerX(numZ, :) = {xs*numZ, uint16(z), uint16(y)};
    end
    %Indexation order
    allXs = vertcat(pixelsPerX{:, 3});
    allYs = vertcat(pixelsPerX{:, 2});
    allZs = vertcat(pixelsPerX{:, 1});
    clearvars pixelsPerX xs
    % Removing invalid areas
    disp('Removing invalid areas')
    [ validPxs, ~, ~ ] = getValidPixels(allXs, allYs, allZs, ellipsoidInfo, cellHeight);
    
    for numCentroid = 1:size(centroids, 1)
        img3D = Drawline3D(img3D, centroids(numCentroid, 1), centroids(numCentroid, 2), centroids(numCentroid, 3), augmentedCentroids(numCentroid, 1), augmentedCentroids(numCentroid, 2), augmentedCentroids(numCentroid, 3), numCentroid);
    end
    
    imgWithDistances = bwdist(img3D);

    disp('Reconstruct voronoi cells')
    img3DLabelled = uint16(watershed(imgWithDistances, 26));
    img3DLabelledWithoutFilter=img3DLabelled;
    %novalidIndices = sub2ind(size(img3DLabelled), allXs(validPxs == 0), allYs(validPxs == 0), allZs(validPxs == 0));
            
    %Removing invalid regions of img3DLabelled
    img3DLabelled(validPxs == 0) = 0;

    colours = colorcube(size(centroids, 1));
    newOrderOfCentroids = zeros(size(centroids, 1), 1);
    figure('visible', 'off');
    img3DLabelledPerim = uint16(bwperim(img3DLabelled)) .* img3DLabelled;
    disp('Building figure');
    for numSeed = 1:size(centroids, 1)
        % Getting the new order of the seeds
        newOrderOfCentroids(numSeed, 1) = img3DLabelledWithoutFilter(centroids(numSeed, 1), centroids(numSeed, 2), centroids(numSeed, 3));
        if newOrderOfCentroids(numSeed, 1) == 0
            newOrderOfCentroids(numSeed, 1) = img3DLabelledWithoutFilter(augmentedCentroids(numSeed, 1), augmentedCentroids(numSeed, 2), augmentedCentroids(numSeed, 3));
        end
        
        % Painting each cell
        [x, y, z] = findND(img3DLabelledPerim == numSeed);
        cellFigure = alphaShape(x, y, z);
        plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
        hold on;
    end
    
    ellipsoidInfo.centroids = augmentedCentroids(newOrderOfCentroids, :);
    save(strcat(outputDir, '\voronoi', date, '.mat'), 'img3DLabelled', 'ellipsoidInfo', '-v7.3');
    savefig(strcat(outputDir, '\voronoi_', date, '.fig'));
    %You can see the figures:
    %set(get(0,'children'),'visible','on')
end

