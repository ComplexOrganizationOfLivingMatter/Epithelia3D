function [info3DCell,img3Dfinal,img3DApicalSurface,img3DBasalSurface,img3DIntermediateSurface]=rebuilding3dVoronoiCylinderFromSeedsExpansion( initialSeeds, H_apical, W_apical, surfaceRatio,reductionFactor,intermediateSurfaceRatios,name2save,path2save)

    H_apical=round(H_apical/reductionFactor);
    W_apical=round(W_apical/reductionFactor);
    initialSeeds=initialSeeds/reductionFactor;
    
    %apical radius of cylinder from 2D voronoi cylindrical image
    R_apical=W_apical/(2*pi);
    R_apical=round(R_apical);
    R_basal=surfaceRatio*R_apical;
    R_basal=round(R_basal);
    
    
    %% Relocate seeds from 2d image to cylinder image
    [basalCylinderSeedsPositions,apicalCylinderSeedsPositions]=seedsRelocationInCylinderCoordinatesFrom2D(R_basal,R_apical,W_apical,initialSeeds);

    %% Get limitations of space and surfaces 3d indexes
    [imgInvalidRegion,equalBasalRadius,equalApicalRadius,equalIntermediateRadius]=get3DCylinderLimitsBasalApicalandIntermediate(R_basal,R_apical,H_apical,intermediateSurfaceRatios);
        
    %% Find pixels of a seed segment
    maskOfGlobalImage=zeros(2*R_basal+1,2*R_basal+1,H_apical,'uint16');
    for i=1:length(apicalCylinderSeedsPositions.x)
        maskOfGlobalImage=Drawline3D(maskOfGlobalImage,apicalCylinderSeedsPositions.x(i),apicalCylinderSeedsPositions.y(i),apicalCylinderSeedsPositions.z(i), basalCylinderSeedsPositions.x(i), basalCylinderSeedsPositions.y(i), basalCylinderSeedsPositions.z(i),i);
    end

    %% Calculation of distance matrix applying the invalid region
    distSegments=bwdist(maskOfGlobalImage);
	voronoi3D=watershed(distSegments,26);

    %% filling zero pixels as outlinesCells
    outlinesCells = (voronoi3D==0 & imgInvalidRegion==0);
    idOutlCells = find(outlinesCells);
    [xZer,yZer,zZer] = ind2sub(size(voronoi3D),idOutlCells);

    seedsId = find(maskGlobalImage);
    [xSeeds,ySeeds,zSeeds] = ind2sub(size(voronoi3D),seedsId);
    pD = pdist2([xZer,yZer,zZer],[xSeeds,ySeeds,zSeeds]);
    [~,posMin] = min(pD,[],2);
    voronoi3D(idOutlCells) = voronoi3D(seedsId(posMin));
    voronoi3D(imgInvalidRegion==1)=0;

    nCells = unique(voronoi3D);
    nCells = nCells(nCells~=0);

    mask1 = zeros(size(voronoi3D));
    for nC = nCells'
        mask2 = zeros(size(voronoi3D));
        mask2(voronoi3D==nC)=1;
        imgErode = imerode(mask2,strel('sphere',1));
        imgDilate = imdilate(imgErode,strel('sphere',1));
        mask1(imgDilate>0) = nC;
    end

    idZerosIsolated = find(mask1 == 0 & imgInvalidRegion == 0);

    for nZPix = idZerosIsolated'
        maskPx = false(size(voronoi3D));
        maskPx(nZPix)=1;
        pxDil = imdilate(maskPx,strel('sphere',1));
        pxOverl = mask1(pxDil);
        try
            [a,b] = hist(pxOverl(pxOverl>0),unique(pxOverl(pxOverl>0)));
            [~,posMax]=max(a);
            mask1(nZPix) = b(posMax);
        catch
        end
    end

	voronoi3D(imgInvalidRegion==1)=0;
    colours = colorcube(size(initialSeeds, 1));

    %% Store info per each 3d cell and relabel waterImage with the label seeds
    numTotalSeeds=size(initialSeeds, 1);
    info3DCell=cell(numTotalSeeds,1);
    for numSeed = 1:numTotalSeeds
        [info3DCell{numSeed}]=storingDataPer3DCell(numSeed,R_basal,H_apical,maskOfGlobalImage,colours,voronoi3D);
    end

    %% plot 3d reconstruction ---- This section is out of the last loop
    %because we could not represent the cylinder due to the computational
    %cost.
    
%     f=figure('Visible','on');
    for numSeed=1:numTotalSeeds
        [voxelsCoordinates]=info3DCell{numSeed}.pxCoordinates;
%         cellFigure = alphaShape(voxelsCoordinates(:,1), voxelsCoordinates(:,2), voxelsCoordinates(:,3),10);
%         plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
%         hold on;
    end
    

    %% Get final image and surfaces of interest
%     img3Dfinal= zeros(2*R_basal+1,2*R_basal+1,H_apical);
%     for numSeed=1:numTotalSeeds
%         cell3d=info3DCell{numSeed}.image3d;
%         img3Dfinal(img3Dfinal==0)=img3Dfinal(img3Dfinal==0)+cell3d(img3Dfinal==0);
%     end
%     
%     [img3DApicalSurface,img3DBasalSurface,img3DIntermediateSurface]=get3dImageAndSurfaces(R_basal,H_apical,equalBasalRadius,equalApicalRadius,equalIntermediateRadius,intermediateSurfaceRatios,img3Dfinal);  

    mkdir(path2save)
    save([path2save name2save '_surfaceRatio_' num2str(surfaceRatio) '_reductionFactorPixelsSize_' num2str(reductionFactor) '.mat'],'info3Dcell','apicalCylinderSeedsPositions','basalCylinderSeedsPositions','-v7.3');
    savefig(f,[path2save name2save '_surfaceRatio_' num2str(surfaceRatio) '_reductionFactorPixelsSize_' num2str(reductionFactor) '_.fig'])

end

