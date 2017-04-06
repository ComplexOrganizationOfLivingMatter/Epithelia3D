function CalculateProportionBrokenTolerance(L_img,valid_cells,pathToSaveData,setOfAngles,cellTolerancesVoronoi,ratioRadiusAreaCir_Heigh,transitionsProportion,curvature)

    %This function is needed to have a referenced height. We become mean
    %area of valid cells in a circular cell to get the ratio. This ratio
    %will be our reference for heights.
    area=regionprops(L_img,'Area');
    area=cat(1,area.Area);
    validArea=area(valid_cells);
    avgValidArea=mean(validArea);
    imaginaryCircRatio=sqrt(avgValidArea/pi);
    heightCell=ratioRadiusAreaCir_Heigh*imaginaryCircRatio;
    
    %define specific taus & angles
    tau1=min(cellTolerancesVoronoi)+0.0001;
    tau50=median(cellTolerancesVoronoi)+0.0001;
    tau99=max(cellTolerancesVoronoi);
    angle1=atand(tau1/heightCell)*curvature;
    angle50=atand(tau50/heightCell)*curvature;
    angle99=atand(tau99/heightCell)*curvature;
    
    
    %from this ratio and angles we get an struct with TAU
    anglesValues={};
    heightValues={};
    tauValues={};
    proportionBrokerTol={};
    
    for j=1:length(setOfAngles)
        heightValues{end+1}=heightCell;
        anglesValues{end+1}=setOfAngles(j)*curvature;
        tauValue=tand(setOfAngles(j))*heightCell;
        tauValues{end+1}=tauValue;

        proportionBrokerTol{end+1}=sum(cellTolerancesVoronoi<tauValue)/length(cellTolerancesVoronoi);

    end
    %structs organization
    brokenToleranceProportion = struct('AngleDegrees',anglesValues,'Heights',heightValues,'TAU',tauValues,'BrokenToleranceProportion',proportionBrokerTol);   
    
    
    %% Calculate proportion areas - angles & taus
    calculateTransitionProportionAnglesTaus(transitionsProportion,tau1,tau50,tau99,angle1,angle50,angle99,heightCell,pathToSaveData)

    
    save(pathToSaveData,'imaginaryCircRatio','brokenToleranceProportion','curvature','-append') 

end

