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
    mkdir(dir2save)   
    for nCell = uniqCells'
        [rowCoord,colCoord] = find(imgApical == nCell);
        coordApical = [rowCoord, colCoord];
        coordApical = coordApical / reductionFactor;
        %% Relocate coord from 2d image to cylinder image and extrapolate to basal
        [coordBasalCyl,coordApicalCyl]=seedsRelocationInCylinderCoordinatesFrom2D(R_basal,R_apical,W_apical,coordApical);
        
        coord=[coordBasalCyl;coordApicalCyl];
        shp=alphaShape(coord,Inf);
        
        [F,V]=shp.boundaryFacets;
        stlwrite([path2save 'Image_' num2str(numImage) 'sltCell' num2str(numSeed) '_redFactor_' num2str(reductionFactor) '.stl'],F,V)
        try
            save([path2save name2save '_surfaceRatio_' num2str(surfaceRatio) '_reductionFactorPixelsSize_' num2str(reductionFactor) '.mat'],'-struct','infoCell','-append');
        catch
            disp(['info_' nStruct ' not saved'])
        end
    end


end