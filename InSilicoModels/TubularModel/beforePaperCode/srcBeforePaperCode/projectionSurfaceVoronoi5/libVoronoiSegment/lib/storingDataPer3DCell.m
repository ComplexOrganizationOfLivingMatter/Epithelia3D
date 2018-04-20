function [info3Dcell]=storingDataPer3DCell(numSeed,R_basal,H_apical,maskOfGlobalImage,colours,voronoi3D)
    
    %Initialize 3D cell
    info3Dcell=struct('ID',0,'region',0,'volume',0,'colour',0,'pxCoordinates',0,'image3d',0);
    %chose a seed to work
    img3Dactual = zeros(2*R_basal+1,2*R_basal+1,H_apical);  
    
    %label overlapping in watershed and initial seed
    uniqueIndex=voronoi3D(maskOfGlobalImage==numSeed);
    uniqueIndex=mode(uniqueIndex(uniqueIndex~=0));
    regionActual = voronoi3D == uniqueIndex;
    
    img3Dactual(regionActual) = 1;
	img3Dactual=bwperim(img3Dactual)*numSeed;
    [x, y, z] = findND(img3Dactual == numSeed);
    
    %seedsInfo acum
    info3Dcell.ID = numSeed;
    info3Dcell.region = regionActual;
    info3Dcell.image3d = img3Dactual;
    info3Dcell.volume = sum(sum(sum(regionActual)));
    info3Dcell.colour = colours(numSeed, :);
    info3Dcell.pxCoordinates = [x, y, z];


end