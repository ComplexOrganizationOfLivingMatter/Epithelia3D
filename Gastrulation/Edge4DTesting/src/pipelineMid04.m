function [ ] = pipelineMid04( labels3d )
%PIPELINEMID04 Summary of this function goes here
%   Detailed explanation goes here
    mkdir('results/mid04/segments');

    labels3d = double(labels3d);

    colors = [colorcube(256); jet(256); parula(256); colorcube(256)];

    for i = 1:size(labels3d, 3)
        img = labels3d(:, :, i);
        %img(img ~= 0) = img(img ~= 0) - min(img(img ~= 0));
        imwrite(img, colors, strcat('results/mid04/segments/segment_', num2str(i), '.jpg')); 
    end

end

