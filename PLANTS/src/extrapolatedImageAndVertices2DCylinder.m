function extrapolatedImageAndVertices2DCylinder(name,layer1,layer2,verticesInfoLayer1,verticesInfoLayer2)
    
    

    load(['data\' name],'centers','radiiBasalLayer1','radiiApicalLayer1','radiiBasalLayer2','radiiApicalLayer2');
    setOfVertices={verticesInfoLayer1.Outer,verticesInfoLayer1.Inner,verticesInfoLayer2.Outer,verticesInfoLayer2.Inner};
    setOfRadii={radiiBasalLayer1,radiiApicalLayer1,radiiBasalLayer2,radiiApicalLayer2};
    setOf3DImages={layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface};
    
    for nSet = 1:length(setOfRadii)

        %get 2D image from hypocotil surface
        [maskNewCyl] = extrapolate3DCylinder2Dplane(setOf3DImages{nSet},setOfRadii{nSet},centers);
        figure;imshow(maskNewCyk,colorcube(2000));
        %get vertices connections
        connectVertices(setOfVertices{nSet},setOfRadii{nSet},centers)

        
    end
end