function [basalLayer] = getBasalFrom3DImage(labelledImage, tipValue)
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
    
    se = strel('sphere', 2);
    finalObjectEroded = imerode(finalObject, se);
    basalLayer = finalObject - finalObjectEroded;
    basalLayer(:, :, end) = finalObject(:, :, end);
    basalLayer(:, :, 1) = finalObject(:, :, 1);
    basalLayerPerim = bwperim(basalLayer);
%     [x,y,z] = ind2sub(size(basalLayer),find(basalLayer>0));
%     figure;
%     pcshow([x,y,z]);
    basalLayer = labelledImage .* basalLayerPerim;
end

