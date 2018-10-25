function [basalCylinderSeedsPositions,apicalCylinderSeedsPositions]=seedsRelocationInCylinderCoordinatesFrom2D(R_basal,R_apical,W_apical,initialSeeds)
   
    %pixels relocation from cylinder angle
    angleOfSeedsLocation=(360/W_apical)*initialSeeds(:,2);

    %% Cylinder seeds position: x=R*cos(angle); y=R*sin(angle);
    %final location of seeds in basal region
    
    basalCylinderSeedsPositions.x=round(R_basal*cosd(angleOfSeedsLocation))+R_basal+1;
    basalCylinderSeedsPositions.y=round(R_basal*sind(angleOfSeedsLocation))+R_basal+1;
    

    %initial location of seeds. 
    apicalCylinderSeedsPositions.x=round(R_apical*cosd(angleOfSeedsLocation))+R_basal+1;
    apicalCylinderSeedsPositions.y=round(R_apical*sind(angleOfSeedsLocation))+R_basal+1;
    
    if sum(initialSeeds(:,1)<0.5) > 0
        basalCylinderSeedsPositions.z=floor(initialSeeds(:,1))+1;
        apicalCylinderSeedsPositions.z=floor(initialSeeds(:,1))+1;
    else
        basalCylinderSeedsPositions.z=round(initialSeeds(:,1));
        apicalCylinderSeedsPositions.z=round(initialSeeds(:,1));
    end
    
end

