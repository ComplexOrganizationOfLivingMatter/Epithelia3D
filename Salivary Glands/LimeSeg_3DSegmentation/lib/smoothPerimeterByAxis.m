function [imageToSmooth] = smoothPerimeterByAxis(imageToSmooth)
%SMOOTHPERIMETERBYAXIS Summary of this function goes here
%   Detailed explanation goes here
 % Obtaining the number of pixels of each circumference
    for coordY = 1 : size(imageToSmooth,3)
        actualPerim = bwperim(imageToSmooth(:, :, coordY));
        areaOfPerims = regionprops(actualPerim, 'Area');
        areaOfPerims = [areaOfPerims.Area];
        areaOfPerims(areaOfPerims<10) = [];
        %pixelsCircumferencePerCoord{coordY} = areaOfPerims;
        if isempty(areaOfPerims) == 0
            %imshow(actualPerim)
        end
        pixelsCircumferencePerCoord(coordY) = sum(actualPerim(:));
    end
    
    %allCircumferences = [pixelsCircumferencePerCoord{:}];
    allCircumferences = pixelsCircumferencePerCoord(pixelsCircumferencePerCoord~=0);
    
    quantilesCircumferences = quantile(allCircumferences,  [0.10, 0.5]);
    %discardedValues = quantilesCircumferences(1);
    discardedValues = 1;
    %medianPixelsCircumferenceOfGland = quantilesCircumferences(2);
    
    %Create array of strel neighborhoods
    for numStrel = 1:10
        strelNeighborhoods(numStrel) = sum(strel('disk', numStrel).Neighborhood(:))-1;
    end
    
    % Smoothing object regarding the difference between the number of
    % pixels in a particular coordY and the calculated median and previous
    % and next coordYs.
    for coordY = 1 : size(imageToSmooth, 3)
        if pixelsCircumferencePerCoord(coordY) >= discardedValues
            differenceToAdjust = pixelsCircumferencePerCoord(coordY) - mean(pixelsCircumferencePerCoord(coordY-2:coordY+2));
            
            [~, closestStrel] = min(abs(strelNeighborhoods - abs(differenceToAdjust)));
            
            if differenceToAdjust > 0 %Erode
                imageToSmooth(:, :, coordY) = imerode(imageToSmooth(:, :, coordY), strel('disk', closestStrel));
            else %Dilate
                imageToSmooth(:, :, coordY) = imdilate(imageToSmooth(:, :, coordY), strel('disk', closestStrel));
            end
        end
    end
end

