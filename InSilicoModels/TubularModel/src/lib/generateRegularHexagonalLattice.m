%% Generate hexagonal tessellations with different angles of rotation

pixelsHexSide = 120;
nSeedsW = 5;
nSeedsH = 5;
apotema = round(pixelsHexSide * cosd(30));

%create hexagonal lattice horizontal edge
x1 = (0:round(3*pixelsHexSide):nSeedsW*round(3*pixelsHexSide))+1;
y1 = (0:2*apotema:nSeedsH*2*apotema)+1;
x2 = x1 + round(3*pixelsHexSide)/2;
y2 = y1 + apotema;

wImg = max(x2) + pixelsHexSide + round(pixelsHexSide/2) -1;
hImg = max(y2);

seedsPosition1 = arrayfun(@(x) [repmat(x,length(x1),1), x1'],y1','UniformOutput',false);
seedsPosition1 = vertcat(seedsPosition1{:});
seedsPosition2 = arrayfun(@(x) [repmat(x,length(x2),1), x2'],y2','UniformOutput',false);
seedsPosition2 = vertcat(seedsPosition2{:});

seedsTotal = [seedsPosition1;seedsPosition2];
indSeeds = sub2ind([hImg,wImg],seedsTotal(:,1),seedsTotal(:,2));

maskImg = zeros(hImg,wImg);
maskImg(indSeeds) = 1;

bwMask =  bwdist(maskImg);
hexLattice = watershed(bwMask);
figure;imshow(double(hexLattice))
hold on;plot(seedsTotal(:,2),seedsTotal(:,1),'r*')
xlabel('x')
ylabel('y')

imgRotate = imrotate(maskImg,30,'bilinear');
bwMaskRot =  bwdist(imgRotate);
hexLatticeRot = watershed(bwMaskRot);
figure;imshow(double(hexLatticeRot))