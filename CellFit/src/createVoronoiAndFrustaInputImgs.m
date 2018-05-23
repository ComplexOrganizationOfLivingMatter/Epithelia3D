
surfaceRatio = 1./(1:-0.1:0.1);

imgOriginalApical = 1-im2bw(listLOriginalProjection(1,2).L_originalProjection{1});
for numImg = 1:size(listLOriginalProjection, 1)
    imgOriginal = 1-im2bw(listLOriginalProjection(numImg,2).L_originalProjection{1});
    imwrite(imgOriginal, strcat('D:\Pablo\Epithelia3D\CellFit\data\voronoi5_random1_SR', num2str(listLOriginalProjection(numImg, 1).surfaceRatio), '.tif'));
    imwrite(imresize(imgOriginalApical, [size(imgOriginalApical, 1) size(imgOriginalApical, 2)*surfaceRatio(numImg)]), strcat('D:\Pablo\Epithelia3D\CellFit\data\frusta5_random1_SR', num2str(listLOriginalProjection(numImg, 1).surfaceRatio), '.tif'));
end