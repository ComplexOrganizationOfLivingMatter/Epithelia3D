function extrapolatedImageAndVertices2DCylinder(name,layer1,layer2,verticesInfoLayer1,verticesInfoLayer2)
    
    

    load(['data\' name],'centers','radiiBasalLayer1','radiiApicalLayer1','radiiBasalLayer2','radiiApicalLayer2');
    setOfVertices={verticesInfoLayer1.Outer,verticesInfoLayer1.Inner,verticesInfoLayer2.Outer,verticesInfoLayer2.Inner};
    setOfRadii={radiiBasalLayer1,radiiApicalLayer1,radiiBasalLayer2,radiiApicalLayer2};
    setOf3DImages={layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface};
    
    maxCell=max([unique(setOf3DImages{1});unique(setOf3DImages{2});unique(setOf3DImages{3});unique(setOf3DImages{4})]);
    c=colorcube(double(maxCell));
    indRand=randperm(maxCell);
    
    for nSet = 1:length(setOfRadii)

        %get 2D image from hypocotil surface
        [maskNewCyl] = extrapolate3DCylinder2Dplane(setOf3DImages{nSet},setOfRadii{nSet},centers{nSet});
        
        figure;imshow(maskNewCyl,c(indRand,:));
        axis equal
        %get vertices connections
%         connectVertices(setOfVertices{nSet},setOfRadii{nSet},centers)

        
    end
end