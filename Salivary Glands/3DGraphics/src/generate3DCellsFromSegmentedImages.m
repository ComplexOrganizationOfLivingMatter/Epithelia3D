inputDir = 'D:\Pablo\Epithelia3D\Salivary Glands\data\25-04-17\Sqh 25-04-17 Phal GFP Dapi 40X 1a\Skel';
pixelsPerCell = {};
numPlane = 1;
for numStack = 4:2:28
    actualImg = imread(strcat(inputDir, num2str(numStack), '.tif'));
    pixels = regionprops(actualImg  == 0, {'PixelList', 'Centroid'});
    pixels = pixels(2:end);
    
    for numCell = 1:size(pixels, 1)
        pixelsCell = pixels(numCell).PixelList;
        pxBoundary = boundary(pixelsCell(:, 1), pixelsCell(:, 2), 0);
        if size(pixelsPerCell, 2) < numCell
            pixelsPerCell{numCell} = [pixelsCell(pxBoundary, :) ones(size(pxBoundary, 1), 1) * numStack];
        else
            pixelsPerCell{numCell} = vertcat(pixelsPerCell{numCell}, [pixelsCell(pxBoundary, :) ones(size(pxBoundary, 1), 1) * numStack]);
        end
    end
    numPlane = numPlane + 1;
end

%colours = [255 153 51; 102 153 255; 102 153 51; 204 0 102] / 255;
colours = [255 255 51; 102 153 255; 102 153 51; 255 0 0] / 255;
figure;
for numCell = 1:4
    pxCell = pixelsPerCell{numCell};
%     isosurface(pxCell);
%     for numZ = min(pxCell(:, 3))+2:2:max(pxCell(:, 3))
%         fill3(pxCell(pxCell(:,3) == numZ | pxCell(:,3) == numZ-2, 1), pxCell(pxCell(:,3) == numZ | pxCell(:,3) == numZ-2, 2), pxCell(pxCell(:,3) == numZ | pxCell(:,3) == numZ-2, 3), colours(numCell, :), 'EdgeColor', 'none');
%         hold on;
%     end
    k = boundary(pxCell, 0);
    if numCell == 1 || numCell == 4
        trisurf(k,pxCell(:, 1), pxCell(:, 2), pxCell(:, 3), 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.5, 'FaceAlpha', 0.5);
    else
        trisurf(k,pxCell(:, 1), pxCell(:, 2), pxCell(:, 3), 'FaceColor', colours(numCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.5);
    end
    hold on;
end
camlight left;
camlight right;
lighting flat