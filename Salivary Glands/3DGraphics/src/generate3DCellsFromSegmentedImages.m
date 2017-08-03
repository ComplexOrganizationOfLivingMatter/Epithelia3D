%% Drawing a motif

inputDir = 'D:\Pablo\Epithelia3D\Salivary Glands\data\25-04-17\Sqh 25-04-17 Phal GFP Dapi 40X 1a\Skel';
pixelsPerCell = {};
Zs = 4:28;
motifAngle = 7.81;
for numStack = Zs
    numStack
    actualImg = imread(strcat(inputDir, num2str(numStack), '.tif'));
    actualImg = imrotate(actualImg, motifAngle);
    imgBorder1 = watershed(actualImg > 0);
    pixels = regionprops(imgBorder1 > 1, 'PixelList');
    
    for numCell = 1:size(pixels, 1)
        pixelsCell = pixels(numCell).PixelList;
        pxBoundary = boundary(pixelsCell(:, 1), pixelsCell(:, 2), 0);
        if size(pixelsPerCell, 2) < numCell
            pixelsPerCell{numCell} = [pixelsCell(pxBoundary, :) ones(size(pxBoundary, 1), 1) * (max(Zs) - numStack)];
        else
            pixelsPerCell{numCell} = vertcat(pixelsPerCell{numCell}, [pixelsCell(pxBoundary, :) ones(size(pxBoundary, 1), 1) * (max(Zs) - numStack)]);
        end
    end
end





%colours = [255 153 51; 102 153 255; 102 153 51; 204 0 102] / 255;
colours = [255 255 51;  255 0 0; 102 153 51; 102 153 255] / 255;
plotFigure3DFromCellBoundaries( pixelsPerCell, colours)

% %% A 3D gland
% 
% load('D:\Pablo\Epithelia3D\Salivary Glands\Confocal stacks\Segmented images data\Wild type\21-03-16\gland 6 (sqhgfp ecadh gfp ed 2a 20x)\Label_sequence.mat')
% pixelsPerCell = {};
% for numStack = 1:length(Seq_Img_L)/2
%     numStack
%     actualImg = Seq_Img_L{numStack};
%     pixels = regionprops(actualImg, actualImg, {'PixelList', 'MeanIntensity'});
%     %pixels = pixels(2:end);
%     
%     for numCell = 1:size(pixels, 1)
%         pixelsCell = pixels(numCell).PixelList;
%         pxBoundary = boundary(pixelsCell(:, 1), pixelsCell(:, 2), 0);
%         numLabel = pixels(numCell).MeanIntensity;
%         if isnan(numLabel) == 0
%             if size(pixelsPerCell, 2) < numLabel
%                 pixelsPerCell{numLabel} = [pixelsCell(pxBoundary, :) ones(size(pxBoundary, 1), 1) * numStack * 10];
%             else
%                 pixelsPerCell{numLabel} = vertcat(pixelsPerCell{numLabel}, [pixelsCell(pxBoundary, :) ones(size(pxBoundary, 1), 1) * numStack * 10]);
%             end
%         end
%     end
% end
% 
% colours = colorcube(length(pixelsPerCell));
% %colours = [255 255 51; 102 153 255; 102 153 51; 255 0 0] / 255;
% pixelsPerCell(cellfun(@(x) isempty(x) == 0, pixelsPerCell))
% plotFigure3DFromCellBoundaries( pixelsPerCell(cellfun(@(x) isempty(x) == 0, pixelsPerCell)), colours)