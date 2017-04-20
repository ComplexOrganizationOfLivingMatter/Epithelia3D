
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

load('D:\Pablo\Epithelia3D\Edge4DTesting\results\locationsOfMotifs.mat')
imshow(labels3d(:, :, 100));

positions = {[119.53 89.48 56.5 52.15]
[159.89 256.28 46.96 46.52]
[138.18 380.48 54.04 44.56]
[135.81 428.83 63.99 44.56]
[143.87 466.76 63.99 42.66]
[137.4 131.43 46.6 60.94]
[137.10 204.53 47.72 55.23]
[151.63 292.66 42.09 58.23]
[147.72 511.58 48.26 60.06]
[148.17 513.46 49.87 57.91]};
positionsVector = vertcat(positions{:});

% for i = 1:size(positionsVector, 1)
%     croppedImg = imcrop(segment_50, positionsVector(i, :));
%     imwrite(croppedImg, strcat('results\motifSegments_atSegment50\motif_', num2str(i), '.png'));
% end

selectedPairOfCells = [533, 780;
    557, 463;
    600, 692;
    618, 461;
    666, 714;
    410, 663;
    679, 308;
    636, 497;
    634, 447;
    631, 443;
    439, 338;
    425, 390;
    382, 587;
    584, 409;
    381, 616;
    617, 566;
    652, 358;
    564, 345;
    619, 198;
    299, 293;
    401, 682;
    83, 2;
    361, 209;
    532, 297];


% imgToShow = img;
% imgToShow(ismember(img, unique(selectedPairOfCells)) == 0) = 0;
% imshow(imgToShow);

img = labels3d(:, :, 50);
se = strel('disk', 3);
selectedCells = zeros(size(selectedPairOfCells, 1), 4);
infoCells = {};
for i = 1:size(selectedPairOfCells, 1)
    cell1 = selectedPairOfCells(i, 1);
    cell2 = selectedPairOfCells(i, 2);
    i
    cell1_dilate = imdilate(bwperim(img == cell1), se);
    cell2_dilate = imdilate(bwperim(img == cell2), se);
    
    neighboursCell1 = unique(img(cell1_dilate));
    neighboursCell2 = unique(img(cell2_dilate));
    
    neighboursCell1(neighboursCell1 == 0) = [];
    neighboursCell2(neighboursCell2 == 0) = [];
    selectedCells(i, :) = intersect(neighboursCell1, neighboursCell2);

    for numCell = 1:4
        regionPropsOfCells = [];
        for zPlane = 1:size(labels3d, 3)
            regionOfCell = struct2table(regionprops(labels3d(:, :, zPlane) == selectedCells(i, numCell), 'all'), 'AsArray', true);
            if size(regionOfCell, 1) == 1 && regionOfCell.Area > 10
                regionOfCell.zPlane = zPlane;
                if isempty(regionPropsOfCells)
                    regionPropsOfCells = regionOfCell;
                else
                    regionPropsOfCells(end+1, :) = regionOfCell;
                end
            end
        end
        infoCells{(4 * (i-1)) + numCell} = regionPropsOfCells;
    end
    
    
    if i == 20
        img = labels3d(:, :, 100);
    end
end

infoCells