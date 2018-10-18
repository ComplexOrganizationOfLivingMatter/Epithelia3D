function getVoronoiProjectionFromSurface(imgLayer, surfaceRatio)

    %read centroids
    cent = regionprops(imgLayer,'Centroid');
    cent = cat(1,cent.Centroid);
    
    %generate mask for new surface ratio
    mask = zeros(size(imgLayer,1),round(size(imgLayer,2)*surfaceRatio));
    
    %select no valid cells
    seedsProj = cent;
    seedsProj(:,1) = round(cent(:,1) * surfaceRatio);
    seedsProjId = sub2ind(size(mask),seedsProj(:,2),seedsProj(:,1));
    
    mask(seedsProjId) = 1;
    maskDist = bwdist(mask);
    watershed(maskDist);
    

end