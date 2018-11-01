function surfaceCells = getSuperficialCells(img3d)

    [allX,allY,allZ] = ind2sub(size(img3d),find(zeros(max(xCol),max(yRow),max(z))==0));
    shp = alphaShape([xCol,yRow,z],2);

    numPartitions = 100;
    partialPxs = ceil(length(allX)/numPartitions);
    idIn = false(length(allX),1);
    for nPart = 1 : numPartitions
        subIndCoord = (1 + (nPart-1) * partialPxs) : (nPart * partialPxs);
        if nPart == numPartitions
            subIndCoord = (1 + (nPart-1) * partialPxs) : length(allX);
        end
        idIn(subIndCoord) = shp.inShape([allX(subIndCoord),allY(subIndCoord),allZ(subIndCoord)]);
    end
    mask3d = false(size(img3d));
    mask3d(idIn) = 1;
    perimMask3dDil = imdilate(bwperim(mask3d),strel('sphere',3));
    surfaceCells = unique(newRotateImage(perimMask3dDil>0));
    surfaceCells =surfaceCells(surfaceCells>0);

end