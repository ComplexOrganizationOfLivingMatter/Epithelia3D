%% embryo Mid
alpha = 0.246508; % microns
w = 418;
h = 332;
d = 248;
fid = fopen('D:\Pablo\Epithelia3D\Edge4DTesting\data\OR_OliGreen_BP106_mid04.raw');
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

labels3d = double(labels3d);

colors = [colorcube(256); jet(256); parula(256); colorcube(256)];

% for i = 1:size(labels3d, 3)
%     img = labels3d(:, :, i);
%     %img(img ~= 0) = img(img ~= 0) - min(img(img ~= 0));
%     imwrite(img, colors, strcat('results/segments/segment_', num2str(i), '.jpg')); 
% end

gettingInfoFromMotifs();

roiCells = [105;107;119;123;131;144;149;158;179;194;215;218;221;223;229;282;289;292;301;304;308;320;323;331;335;339;341;346;350;360;364;366;372;373;375;381;382;385;389;390;406;409;410;422;425;426;429;430;436;437;438;440;443;445;447;460;461;462;463;464;471;472;476;477;497;501;503;505;506;510;514;516;517;530;531;539;545;547;550;557;559;566;568;569;571;572;573;576;584;585;587;595;597;598;599;600;604;606;609;613;614;617;618;631;634;636;639;645;648;659;660;663;666;667;677;678;679;688;692;694;697;700;705;712;714;728;780];
imgPlaneWithLabels = labels3d(:, :, 40);

%Getting mean area
meanAreasAtROI1 = [];
for numPlane = 1:size(labels3d, 3)
    imgPlaneWithLabels = labels3d(:, :, numPlane);
    imgPlaneWithLabelsCropped = imgPlaneWithLabels .* ismember(imgPlaneWithLabels, roiCells);
    imgPlaneWithLabelsNoHoles = imfill(imgPlaneWithLabelsCropped, 8, 'holes');
    neighbourhoodAreas = arrayfun(@(x) sum(sum(imgPlaneWithLabelsNoHoles == x)), roiCells);
    meanAreasAtROI1(numPlane) = mean(neighbourhoodAreas);
end

numMotif = 1;
imshow(ismember(labels3d(:, :, 71), [172	297	532	638]))