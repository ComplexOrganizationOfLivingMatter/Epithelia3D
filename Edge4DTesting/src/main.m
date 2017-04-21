
% isotropic voxel dimensions
alpha = 0.246508; % microns
w = 665;
h = 332;
d = 211;
fid = fopen('D:\Pablo\Epithelia3D\Edge4DTesting\data\OR_OliGreen_BP106_early03.raw');
label_matrix = fread(fid, w * h * d, '*int32');
labels3d = reshape(label_matrix, [w h d]);
fclose(fid);

labels3d = double(labels3d);

colors = [colorcube(256); jet(256); parula(256); colorcube(256)];

% for i = 1:size(labels3d, 3)
%     img = labels3d(:, :, i);
%     %img(img ~= 0) = img(img ~= 0) - min(img(img ~= 0));
%     imwrite(img, colors, strcat('results/segments/segment_', num2str(i), '.jpg')); 
% end

gettingInfoFromMotifs();

numMotif = 1;
imshow(ismember(labels3d(:, :, 71), [172	297	532	638]))