function [rotSeeds,indCentralSeed] = generateSeedsOfRegularVoronoiHexagonalLattice(sideHexagon,nSeedsW,nSeedsH,angleRot)
%% Generate hexagonal tessellations with different angles of rotation

    apotema = sideHexagon * cosd(30);

    %create hexagonal lattice horizontal edge
    x1 = (0:round(3*sideHexagon):nSeedsW*round(3*sideHexagon));
    y1 = (0:2*apotema:nSeedsH*2*apotema);
    x2 = x1 + 3*sideHexagon/2;
    y2 = y1 + apotema;

    seedsPosition1 = arrayfun(@(x) [repmat(x,length(x1),1), x1'],y1','UniformOutput',false);
    seedsPosition1 = vertcat(seedsPosition1{:});
    seedsPosition2 = arrayfun(@(x) [repmat(x,length(x2),1), x2'],y2','UniformOutput',false);
    seedsPosition2 = vertcat(seedsPosition2{:});

    seedsTotal = [seedsPosition1;seedsPosition2];
    
    % Create rotation matrix
    theta = angleRot; % to rotate angleRot counterclockwise
    R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
    % Rotate your point(s)
    rotSeeds = (R*(seedsTotal'))';
    
    centralCoord = mean(rotSeeds);

    d = pdist2(centralCoord,rotSeeds);
    [~,indMD] = min(d);
    
    indCentralSeed = indMD(1);
    

end