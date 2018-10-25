function createFrustaCylinderStl(W_apical, H_apical,imgApical, surfaceRatio,reductionFactor,intermediateSurfaceRatios,name2save,dir2save)

    H_apical=round(H_apical/reductionFactor);
    W_apical=round(W_apical/reductionFactor);
    
    %apical radius of cylinder from 2D voronoi cylindrical image
    R_apical=W_apical/(2*pi);
    R_apical=round(R_apical);
    R_basal=surfaceRatio*R_apical;
    R_basal=round(R_basal);
    
    uniqCells = unique(imgApical(:));
    uniqCells = uniqCells(uniqCells~=0);
    
    %delimited invalid region
    [imgInvalidRegion,~,~]=get3DCylinderLimitsBasalApicalandIntermediate(R_basal,R_apical,H_apical,[]);
    [xIn,yIn,zIn]=ind2sub(size(imgInvalidRegion),find(~imgInvalidRegion));
    mkdir(dir2save)   
    
    %% filling zero pixels as outlinesCells
    outlinesCells = (imgApical==0);
    idOutlCells = find(outlinesCells);
    [xZer,yZer,zZer] = ind2sub(size(imgApical),idOutlCells);
    
    mask1 = imgApical;
    for nZPix = idOutlCells'
        maskPx = false(size(imgApical));
        maskPx(nZPix)=1;
        pxDil = imdilate(maskPx,strel('disk',2));
        pxOverl = mask1(pxDil);
        try
            [a,b] = hist(pxOverl(pxOverl>0),unique(pxOverl(pxOverl>0)));
            [~,posMax]=max(a);
            mask1(nZPix) = b(posMax);
        catch
        end
    end    
    imgApical(idOutlCells) = mask1(idOutlCells);
    imgBasal = imresize(mask1,[size(imgApical,1),round(size(imgApical,2)*surfaceRatio)],'nearest');
    
    for nCell = uniqCells'
        %dilate for getting joined cells in basal
        [rowCoordApi,colCoordApi] = find(imgApical == nCell);
        [rowCoordBas,colCoordBas] = find(imgBasal == nCell);

        coordApical = [rowCoordApi, colCoordApi];
        coordApical = coordApical / reductionFactor;
        coordBasal = [rowCoordBas, colCoordBas];
        coordBasal = coordBasal / reductionFactor;
        %%Relocate coord from 2d image to cylinder image and extrapolate to basal
        
        [~,coordApicalCyl]=seedsRelocationInCylinderCoordinatesFrom2D(R_basal,R_apical,W_apical,coordApical);
        [~,coordBasalCyl]=seedsRelocationInCylinderCoordinatesFrom2D(R_basal,R_basal,round(W_apical*surfaceRatio),coordBasal);
        coord=[[coordBasalCyl.x;coordApicalCyl.x],[coordBasalCyl.y;coordApicalCyl.y],[coordBasalCyl.z;coordApicalCyl.z]];
               
        idZrange = (zIn >= min(coord(:,3)) & zIn <= max(coord(:,3)));
        idYrange = (yIn >= min(coord(:,2)) & yIn <= max(coord(:,2)));
        idXrange = (xIn >= min(coord(:,1)) & xIn <= max(coord(:,1)));
        idBoundBox = idZrange & idYrange & idXrange;
        
        coordZrange = [xIn(idBoundBox),yIn(idBoundBox),zIn(idBoundBox)];
        shp=alphaShape(coord,Inf);
        idIn=shp.inShape(coordZrange);
        shp=alphaShape(coordZrange(idIn,:),3);
        [F,V]=shp.boundaryFacets;
        stlwrite([dir2save name2save '_sltCell' num2str(nCell) '_redFactor_' num2str(reductionFactor) '.stl'],F,V)
        
    end


end