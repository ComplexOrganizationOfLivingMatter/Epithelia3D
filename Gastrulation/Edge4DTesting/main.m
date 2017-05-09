%% embryo Mid
alpha = 0.246508; % microns
w = 418;
h = 332;
d = 248;
fid = fopen('data/OR_OliGreen_BP106_mid04.raw');
label_matrix = fread(fid, w * h * d, '*int32');
labels3d = reshape(label_matrix, [w h d]);
fclose(fid);


% %% EMBRYO EARLY
% % isotropic voxel dimensions
% alpha = 0.246508; % microns
% w = 665;
% h = 332;
% d = 211;
% fid = fopen('D:\Pablo\Epithelia3D\Edge4DTesting\data\OR_OliGreen_BP106_early03.raw');
% label_matrix = fread(fid, w * h * d, '*int32');
% labels3d = reshape(label_matrix, [w h d]);
% fclose(fid);
% pipelineEarly(labels3d);



