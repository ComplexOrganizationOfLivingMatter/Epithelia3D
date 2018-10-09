function [apicalLayer] = getApicalFrom3DImage(lumenImage, labelledImage)
%GETAPICALFRO3DIMAGE Summary of this function goes here
%   Detailed explanation goes here
    se = strel('sphere', 3);
    dilatedLumen = imdilate(lumenImage, se);
    apicalLayer = dilatedLumen .* labelledImage;
    
%     [x,y,z] = ind2sub(size(apicalLayer),find(apicalLayer>0));
%     figure;
%     pcshow([x,y,z]);
end

