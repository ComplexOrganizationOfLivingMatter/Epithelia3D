function  [imgInvalidRegion,equalBasalRadius,equalApicalRadius,equalIntermediateRadius]=get3DCylinderLimitsBasalApicalandIntermediate(R_basal,R_basalMax,R_apical,H,intermediateSurfaceRatio)

%this function provides the invalid region in which we don't want operate
%and  the cylindrical surfaces from a given radius =
%(givenSurfaceRatio/apicalRadius).
    
    %empty Region (lumen or out of cylinder)
    a_pointCentral=R_basalMax+1;
    b_pointCentral=R_basalMax+1;
    
    allXs=repmat(1:(2*R_basalMax+1),(2*R_basalMax+1),1)';
    allYs=repmat(1:(2*R_basalMax+1),(2*R_basalMax+1),1);
    
    %basal limit
    majorThanBasalRadius=cell2mat(arrayfun(@(x,y) (x-a_pointCentral)^2+(y-b_pointCentral)^2 > R_basal^2 ,allXs,allYs,'UniformOutput',false));   
    %get basal layer
    equalBasalRadius=logical(imdilate(majorThanBasalRadius,strel('disk',1))-majorThanBasalRadius);
    equalBasalRadius=repmat(equalBasalRadius,1,1,H);
    %apical limit
    minorThanApicalRadius=cell2mat(arrayfun(@(x,y) (x-a_pointCentral)^2+(y-b_pointCentral)^2 < R_apical^2 ,allXs,allYs,'UniformOutput',false));
    %get apical layer
    equalApicalRadius=logical(imdilate(minorThanApicalRadius,strel('disk',1))-minorThanApicalRadius);
    equalApicalRadius=repmat(equalApicalRadius,1,1,H);
    %sum of invalid regions
    imgInvalidRegion=majorThanBasalRadius+minorThanApicalRadius;
    imgInvalidRegion=repmat(imgInvalidRegion,1,1,H);

    
    %work with intermediate radius that are smaller than R_basal
    intermediateRadius=intermediateSurfaceRatio(intermediateSurfaceRatio<(R_basal/R_apical))*R_apical;
    equalIntermediateRadius=cell(length(intermediateRadius),1);
    
    %get intermediate layers
    for nLayer=1:length(intermediateRadius)
        majorThanIntermediateRadius=cell2mat(arrayfun(@(x,y) (x-a_pointCentral)^2+(y-b_pointCentral)^2 > intermediateRadius(nLayer)^2 ,allXs,allYs,'UniformOutput',false));   
        equalIntermediateRadius2D=logical(imdilate(majorThanIntermediateRadius,strel('disk',1))-majorThanIntermediateRadius);
        equalIntermediateRadius{nLayer}=repmat(equalIntermediateRadius2D,1,1,H);
    end
    
    

end

