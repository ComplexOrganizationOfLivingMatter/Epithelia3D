img3dRezDil = imdilate(imresize3(img3d,0.2,'nearest'),strel('sphere',1));
cMap = colorcube(double(max(img3dRezDil(:))));
cMap = cMap(randperm(max(img3dRezDil(:))), :);
figure;

for nCell = cellsCorrectLayer1'
    [x,y,z]=ind2sub(size(img3dRezDil),find(img3dRezDil==nCell));
    shp = alphaShape([x,y,z],Inf);
    plot(shp,'FaceColor',cMap(nCell,:),'EdgeColor',cMap(nCell,:))
    hold on
end