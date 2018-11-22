function [hexLattice,seedsImg] = generateRegularHexagonalLattice(pixelsHexSide,nSeedsW,nSeedsH)
%% Generate hexagonal tessellations with different angles of rotation

    apotema = round(pixelsHexSide * cosd(30));

    %create hexagonal lattice horizontal edge
    x1 = (0:round(3*pixelsHexSide):nSeedsW*round(3*pixelsHexSide))+1;
    y1 = (0:2*apotema:nSeedsH*2*apotema)+1;
    x2 = x1 + round(3*pixelsHexSide)/2;
    y2 = y1 + apotema;

    wImg = round(max(x2) + pixelsHexSide + round(pixelsHexSide/2) -1);
    hImg = max(y2);

    seedsPosition1 = arrayfun(@(x) [repmat(x,length(x1),1), x1'],y1','UniformOutput',false);
    seedsPosition1 = vertcat(seedsPosition1{:});
    seedsPosition2 = arrayfun(@(x) [repmat(x,length(x2),1), x2'],y2','UniformOutput',false);
    seedsPosition2 = vertcat(seedsPosition2{:});

    seedsTotal = [seedsPosition1;seedsPosition2];
    indSeeds = sub2ind([hImg,wImg],seedsTotal(:,1),seedsTotal(:,2));

    seedsImg = zeros(hImg,wImg);
    seedsImg(indSeeds) = 1;

    bwMask =  bwdist(seedsImg>0);
    hexLattice = watershed(bwMask);
    seedsImg = seedsImg.*double(hexLattice);

end


