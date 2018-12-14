function [imageOfSurfaceRatios, neighbours] = divideObjectInSurfaceRatios(obj_img, startingSurface, endSurface, validCells, noValidCells, colours, selpath)
%DIVIDEOBJECTINSURFACERATIOS Summary of this function goes here
%   Detailed explanation goes here
    
    apical3dInfo = calculateNeighbours3D(endSurface);

    basal3dInfo = calculateNeighbours3D(startingSurface);
    neighbours_data = table(apical3dInfo.neighbourhood, basal3dInfo.neighbourhood);
    neighbours_data.Properties.VariableNames = {'Apical','Basal'};
    [~, apicoBasal_SurfaceRatio] = calculate_CellularFeatures(neighbours_data, apical3dInfo, basal3dInfo, endSurface, startingSurface, obj_img, noValidCells, validCells, [], []);
    
    totalPartitions = 10;
    
    initialPartitions = (1:(totalPartitions-1))/totalPartitions;
    realSurfaceRatio = initialPartitions * (apicoBasal_SurfaceRatio - 1) + 1;
    
    imageOfSurfaceRatios = cell(totalPartitions, 1);
    imageOfSurfaceRatios(:) = {zeros(size(obj_img))};
    for numCell = unique([validCells, noValidCells])
        [xStarting, yStarting, zStarting] = ind2sub(size(startingSurface), find(startingSurface == numCell));
        [xEnd, yEnd, zEnd] = ind2sub(size(endSurface), find(endSurface == numCell));

        [allXs, allYs, allZs] = ind2sub(size(obj_img), find(obj_img == numCell));

        allPixels = [allXs, allYs, allZs];
        startingPixels = [xStarting, yStarting, zStarting];
        endPixels = [xEnd, yEnd, zEnd];
        [distanceEndingStarting] = pdist2(endPixels, startingPixels);
        %[distanceStartingAllPixels] = pdist2(allPixels, startingPixels);
        [distanceEndingAllPixels] = pdist2(allPixels, endPixels);

        %surfaceRatioDistance = mean(min(distanceEndingStarting, [], 2));
        surfaceRatioDistance = mean(distanceEndingStarting(:));
        
        partitions = surfaceRatioDistance * (1:(totalPartitions-1))/totalPartitions;

        
        imageOfSurfaceRatios{1, 1} = endSurface;
        imageOfSurfaceRatios{1, 2} = 1;
        for numPartition = 1:(totalPartitions-1)
%             upperBoundStarting = ((ceil(partitions(totalPartitions - numPartition)*roundingFactor)/roundingFactor)+(1/roundingFactor)) >= distanceStartingAllPixels;
%             lowerBoundStarting = ((floor(partitions(totalPartitions - numPartition)*roundingFactor)/roundingFactor)-(1/roundingFactor)) <= distanceStartingAllPixels;
% 
%             upperBoundEnd = ((ceil(partitions(numPartition)*roundingFactor)/roundingFactor)+(1/roundingFactor)) >= distanceEndingAllPixels;
%             lowerBoundEnd = ((floor(partitions(numPartition)*roundingFactor)/roundingFactor)-(1/roundingFactor)) <= distanceEndingAllPixels;
% 
%             pixelsOfCurrentPartitionSurfaceRatioFromStarting = any(upperBoundStarting & lowerBoundStarting, 2);
%             pixelsOfCurrentPartitionSurfaceRatioFromEnd = any(upperBoundEnd & lowerBoundEnd, 2);
%             pixelsOfSR = allPixels(pixelsOfCurrentPartitionSurfaceRatioFromStarting & pixelsOfCurrentPartitionSurfaceRatioFromEnd, :);
            
            %pixelsCloserToEndSurface = partitions(numPartition) >= min(distanceEndingAllPixels, [], 2);
            pixelsCloserToEndSurface = partitions(numPartition) > distanceEndingAllPixels;
            pixelsOfSR = allPixels(any(pixelsCloserToEndSurface, 2), :);

            if isempty(pixelsOfSR) == 0
                x = pixelsOfSR(:, 1);
                y = pixelsOfSR(:, 2);
                z = pixelsOfSR(:, 3);

                indicesCell = sub2ind(size(obj_img), x, y, z);

                actualPartition = imageOfSurfaceRatios{numPartition+1};

                actualPartition(indicesCell) = numCell;

                imageOfSurfaceRatios{numPartition+1} = actualPartition;

%                 figure; paint3D(actualSurface, [], colours(2:end, :));
%                 hold on; paint3D(startingSurface == 1, [], colours);
%     
%                 for numIndex = 1:length(x)
%                    plot3(x(numIndex), y(numIndex), z(numIndex), '*r'); 
%                 end
            end
        end
    end
    
    imageOfSurfaceRatios(:, 2) = num2cell([1 realSurfaceRatio]);
    imageOfSurfaceRatios{totalPartitions+1, 1} = obj_img;
    imageOfSurfaceRatios{totalPartitions+1, 2} = apicoBasal_SurfaceRatio;
    
    for numPartition = 1:(totalPartitions+1)
        if numPartition > 1
            [imageOfSurfaceRatios{numPartition, 3}] = getBasalFrom3DImage(imageOfSurfaceRatios{numPartition, 1}, [], 4);
        else
            imageOfSurfaceRatios{numPartition, 3} = endSurface;
        end
        basal3dInfo = calculateNeighbours3D(imageOfSurfaceRatios{numPartition, 3});
        neighbours_data = table(apical3dInfo.neighbourhood, basal3dInfo.neighbourhood);
        neighbours_data.Properties.VariableNames = {'Apical','Basal'};
        [imageOfSurfaceRatios{numPartition, 4}, meanSurfaceRatio(numPartition)] = calculate_CellularFeatures(neighbours_data, apical3dInfo, basal3dInfo, endSurface, imageOfSurfaceRatios{numPartition, 3}, imageOfSurfaceRatios{numPartition, 1}, noValidCells, validCells, [], []);
        neighbours{numPartition} = basal3dInfo.neighbourhood;
        %figure; paint3D( imageOfSurfaceRatios{numPartition, 1}, [], colours);
        h = figure('Visible', 'off'); paint3D( ismember(imageOfSurfaceRatios{numPartition, 3}, validCells) .* imageOfSurfaceRatios{numPartition, 3}, [], colours);
        print(h, fullfile(selpath, ['gland_SR' num2str(meanSurfaceRatio(numPartition)), '.tif']),'-dtiff','-r300')
    end
    close all

    
%% eroding starting surface until it overlaps with any pixel of the end surface
%     while any(any(any(endSurface>0 & (ismember(obj_img, validCells) .*actualSurface)>0))) == 0
%         allSurfaceRatioImages{numSurface, 1} = obj_img .* actualSurface;
%         allSurfaceRatioImages{numSurface, 2} = calculateNeighbours3D(allSurfaceRatioImages{numSurface, 1});
%         
%         basal3dInfo = calculateNeighbours3D(allSurfaceRatioImages{numSurface, 1});
%         neighbours_data = table(apical3dInfo.neighbourhood, basal3dInfo.neighbourhood);
%         neighbours_data.Properties.VariableNames = {'Apical','Basal'};
%         allSurfaceRatioImages{numSurface, 3} = calculate_CellularFeatures(neighbours_data, apical3dInfo, basal3dInfo, endSurface, allSurfaceRatioImages{numSurface, 1}, obj_img .* (outsideObject == 0), noValidCells, '.');
%         
%         outsideObject(actualSurface) = 1;
%         
%         dilatedActualSurface = imdilate(imclose(actualSurface>0, strel('sphere', 1)), stepDilation);
%         
%         dilatedActualSurface(outsideObject) = 0;
%         numSurface = numSurface + 1;
%         actualSurface = bwmorph3(dilatedActualSurface, 'clean');
%         %figure; paint3D( obj_img .* actualSurface, [], colours);
%     end
%     figure; paint3D( obj_img .* actualSurface, [], colours);
%     hold on;
%     [indices] = find(endSurface>0 & (ismember(obj_img, validCells) .*actualSurface)>0);
%     [x, y, z] = ind2sub(size(endSurface), indices);
%     for numIndex = 1:length(x)
%        plot3(x(numIndex), y(numIndex), z(numIndex), '*r'); 
%     end
end