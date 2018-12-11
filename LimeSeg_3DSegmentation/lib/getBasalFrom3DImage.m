function [basalLayer] = getBasalFrom3DImage(labelledImage, lumenImage, tipValue)
%GETBASALFROM3DIMAGE Summary of this function goes here
%   Detailed explanation goes here
    se = strel('sphere',tipValue);
    objectDilated = imdilate(labelledImage>0, se);
    objectDilated = imfill(objectDilated, 'holes');
    finalObject = imerode(objectDilated, se);
    finalObject = bwareaopen(finalObject, 5);
%     [x,y,z] = ind2sub(size(finalObject),find(finalObject>0));
%     figure;
%     pcshow([x,y,z]);
    
    se = strel('sphere', 1);
    finalObjectEroded = imerode(finalObject, se);
    basalLayer = finalObject - finalObjectEroded;
    basalLayer(:, :, end) = finalObject(:, :, end);
    basalLayer(:, :, 1) = finalObject(:, :, 1);
%     [x,y,z] = ind2sub(size(basalLayer),find(basalLayer>0));
%     figure;
%     pcshow([x,y,z]);
    if isempty(lumenImage) == 0
        basalLayer(imdilate(lumenImage, strel('sphere', 3))) = 0;
    end
    basalLayer = labelledImage .* basalLayer;
end

