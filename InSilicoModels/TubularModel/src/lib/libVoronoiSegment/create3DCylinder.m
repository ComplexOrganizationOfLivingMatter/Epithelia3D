function [voronoi3D]=create3DCylinder( initialSeeds, H_apical, W_apical, surfaceRatio,reductionFactor,intermediateSurfaceRatios)

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
    [imgInvalidRegion,~,~,~]=get3DCylinderLimitsBasalApicalandIntermediate(R_basal,R_apical,H_apical,intermediateSurfaceRatios);
        
    %% Find pixels of a seed segment
    maskOfGlobalImage=zeros(2*R_basal+1,2*R_basal+1,H_apical,'uint16');
    for i=1:length(apicalCylinderSeedsPositions.x)
        maskOfGlobalImage=Drawline3D(maskOfGlobalImage,apicalCylinderSeedsPositions.x(i),apicalCylinderSeedsPositions.y(i),apicalCylinderSeedsPositions.z(i), basalCylinderSeedsPositions.x(i), basalCylinderSeedsPositions.y(i), basalCylinderSeedsPositions.z(i),i);
    end

    %% Calculation of distance matrix applying the invalid region
    distSegments=bwdist(maskOfGlobalImage);
	voronoi3D=watershed(distSegments,26);
    voronoi3D(imgInvalidRegion>0) = 0;

end