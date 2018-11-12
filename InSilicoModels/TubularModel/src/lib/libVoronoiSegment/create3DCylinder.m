function [maskCylinder3D]=create3DCylinder( initialSeeds, H_apical, W_apical,surfaceRatios, surfaceRatio,reductionFactor,imgApical,cyliderType)

    H_apical=round(H_apical/reductionFactor);
    W_apical=round(W_apical/reductionFactor);
    initialSeeds=initialSeeds/reductionFactor;
    
    %apical radius of cylinder from 2D voronoi cylindrical image
    R_apical=W_apical/(2*pi);
    R_apical=round(R_apical);
    R_basal=surfaceRatio*R_apical;
    R_basal=round(R_basal);
    R_basalMax=max(surfaceRatios)*R_apical;
    R_basalMax=round(R_basalMax);
    
    %% Get limitations of space and surfaces 3d indexes
    [imgInvalidRegion,~,~,~]=get3DCylinderLimitsBasalApicalandIntermediate(R_basal,R_basalMax,R_apical,H_apical,[]);
        
    if contains(lower(cyliderType),'frusta')
        imgBasal = imresize(imgApical,[size(imgApical,1),round(size(imgApical,2)*surfaceRatio)],'nearest');
        uniqCells = unique(imgApical);
        uniqCells = uniqCells(uniqCells>0);
        maskCylinder3D = zeros(size(imgInvalidRegion),'uint16');
        [xIn,yIn,zIn]=ind2sub(size(imgInvalidRegion),find(~imgInvalidRegion));

        for nCell = 1:max(uniqCells)
            %dilate for getting joined cells in basal
            [rowCoordApi,colCoordApi] = find(imgApical == uniqCells(nCell));
            [rowCoordBas,colCoordBas] = find(imgBasal == uniqCells(nCell));

            coordApical = [rowCoordApi, colCoordApi];
            coordApical = coordApical / reductionFactor;
            coordBasal = [rowCoordBas, colCoordBas];
            coordBasal = coordBasal / reductionFactor;

            %% Relocate coord from 2d image to cylinder image and extrapolate to basal
            [~,coordApicalCyl]=seedsRelocationInCylinderCoordinatesFrom2D(R_basal,R_apical,W_apical,coordApical);
            [~,coordBasalCyl]=seedsRelocationInCylinderCoordinatesFrom2D(R_basal,R_basal,round(W_apical*surfaceRatio),coordBasal);
            coord=[[coordBasalCyl.x;coordApicalCyl.x],[coordBasalCyl.y;coordApicalCyl.y],[coordBasalCyl.z;coordApicalCyl.z]];
                   
            idZrange = (zIn >= min(coord(:,3)) & zIn <= max(coord(:,3)));
            idYrange = (yIn >= min(coord(:,2)) & yIn <= max(coord(:,2)));
            idXrange = (xIn >= min(coord(:,1)) & xIn <= max(coord(:,1)));
            idBoundBox = idZrange & idYrange & idXrange;
            
            coordZrange = [xIn(idBoundBox),yIn(idBoundBox),zIn(idBoundBox)];
            shp=alphaShape(unique(coord, 'rows'),Inf);
            idIn=shp.inShape(coordZrange);
            labelInd = sub2ind(size(maskCylinder3D),coordZrange(idIn,1), coordZrange(idIn,2), coordZrange(idIn,3));
            %labelInd = sub2ind(size(maskCylinder3D), coord(:, 1), coord(:, 2), coord(:, 3));
            maskCylinder3D(labelInd) = uniqCells(nCell);
            
        end
        maskCylinder3D(imgInvalidRegion>0) = 0;

    else

        %% Relocate seeds from 2d image to cylinder image
        [basalCylinderSeedsPositions,apicalCylinderSeedsPositions]=seedsRelocationInCylinderCoordinatesFrom2D(R_basalMax,R_apical,W_apical,initialSeeds);

        %% Find pixels of a seed segment
        maskOfGlobalImage=zeros(2*R_basalMax+1,2*R_basalMax+1,H_apical,'uint16');
        for i=1:length(apicalCylinderSeedsPositions.x)
            maskOfGlobalImage=Drawline3D(maskOfGlobalImage,apicalCylinderSeedsPositions.x(i),apicalCylinderSeedsPositions.y(i),apicalCylinderSeedsPositions.z(i), basalCylinderSeedsPositions.x(i), basalCylinderSeedsPositions.y(i), basalCylinderSeedsPositions.z(i),i);
        end

        %% Calculation of distance matrix applying the invalid region
        distSegments=bwdist(maskOfGlobalImage);
        Cylinder3D=watershed(distSegments,26);
        Cylinder3D(imgInvalidRegion>0) = 0;

        %% Relabel 3D cells
        maskCylinder3D = Cylinder3D;
        for numSeed = 1:length(apicalCylinderSeedsPositions.x)
            cellLabelOld = unique(Cylinder3D(maskOfGlobalImage==numSeed));
            cellLabelOld = cellLabelOld(cellLabelOld>0);
            maskCylinder3D(Cylinder3D==cellLabelOld) = numSeed;
        end
    end

end