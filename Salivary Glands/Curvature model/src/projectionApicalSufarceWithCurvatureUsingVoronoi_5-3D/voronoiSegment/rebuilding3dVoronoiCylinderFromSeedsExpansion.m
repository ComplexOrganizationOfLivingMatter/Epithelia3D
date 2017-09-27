function seedsInfo=rebuilding3dVoronoiCylinderFromSeedsExpansion( initialSeeds, H_apical, W_apical, surfaceRatio, imgApical,reductionFactor,name2save)

    addpath('lib')
    addpath('..\lib')
    H_apical=round(H_apical/reductionFactor);
    W_apical=round(W_apical/reductionFactor);
    initialSeeds=initialSeeds/reductionFactor;
    
    %apical radius of cylinder from 2D voronoi cylindrical image
    R_apical=W_apical/(2*pi);
    R_apical=round(R_apical);
    %pixels relocation from cylinder angle
    angleOfSeedsLocation=(360/W_apical)*initialSeeds(:,2);

    %% Cylinder seeds position: x=R*cos(angle); y=R*sin(angle);
    %final location of seeds in basal region
    R_basal=surfaceRatio*R_apical;
    R_basal=round(R_basal);
    basalCylinderSeedsPositions.x=round(R_basal*cosd(angleOfSeedsLocation))+R_basal+1;
    basalCylinderSeedsPositions.y=round(R_basal*sind(angleOfSeedsLocation))+R_basal+1;
    basalCylinderSeedsPositions.z=round(initialSeeds(:,1));

    %initial location of seeds. 
    apicalCylinderSeedsPositions.x=round(R_apical*cosd(angleOfSeedsLocation))+R_basal+1;
    apicalCylinderSeedsPositions.y=round(R_apical*sind(angleOfSeedsLocation))+R_basal+1;
    apicalCylinderSeedsPositions.z=round(initialSeeds(:,1));

    %empty Region (lumen or out of cylinder)
    a_pointCentral=R_basal+1;
    b_pointCentral=R_basal+1;
    
    allXs=repmat(1:(2*R_basal+1),(2*R_basal+1),1)';
    allYs=repmat(1:(2*R_basal+1),(2*R_basal+1),1);
    majorThanBasalRadius=cell2mat(arrayfun(@(x,y) (x-a_pointCentral)^2+(y-b_pointCentral)^2 > R_basal^2 ,allXs,allYs,'UniformOutput',false));
    minorThanApicalRadius=cell2mat(arrayfun(@(x,y) (x-a_pointCentral)^2+(y-b_pointCentral)^2 < R_apical^2 ,allXs,allYs,'UniformOutput',false));
    imgInvalidRegion=majorThanBasalRadius+minorThanApicalRadius;
    imgInvalidRegion=repmat(imgInvalidRegion,1,1,H_apical);

    %find pixels of a seed segment
    maskOfGlobalImage=zeros(2*R_basal+1,2*R_basal+1,H_apical);
    for i=1:length(apicalCylinderSeedsPositions.x)
        maskOfGlobalImage=Drawline3D(maskOfGlobalImage,apicalCylinderSeedsPositions.x(i),apicalCylinderSeedsPositions.y(i),apicalCylinderSeedsPositions.z(i), basalCylinderSeedsPositions.x(i), basalCylinderSeedsPositions.y(i), basalCylinderSeedsPositions.z(i),i);
    end

    %calculation of distance matrix applying the invalid region
    distSegments=bwdist(maskOfGlobalImage);
    distSegments(imgInvalidRegion==1)=0;
    colours = colorcube(size(initialSeeds, 1));

    numTotalSeeds=size(initialSeeds, 1);
    seedsInfo=struct('ID',zeros(numTotalSeeds,1),'region',zeros(numTotalSeeds,1),'volume',zeros(numTotalSeeds,1),'colour',cell(numTotalSeeds,1),'pxCoordinates',cell(numTotalSeeds,1),'image3d',zeros(numTotalSeeds,1));
    
    parfor numSeed = 1:numTotalSeeds
        
        %chose a seed to work
        img3Dactual = zeros(2*R_basal+1,2*R_basal+1,H_apical);
        img3Dactual(maskOfGlobalImage==numSeed)=1;

        %check the distance matrix from a given segment of seeds and compare
        %with the global distance matrix
        imgDistPerSeed = bwdist(img3Dactual);

        %label 3d region and get indexes
        regionActual = imgDistPerSeed == distSegments;
        img3Dactual(regionActual) = numSeed;
        img3Dactual=bwperim(img3Dactual)*numSeed;
        [x, y, z] = findND(img3Dactual == numSeed);

        %store info of 3D voronoi cells
        seedsInfo(numSeed).ID = numSeed;
        seedsInfo(numSeed).region = regionActual;
        seedsInfo(numSeed).image3d = img3Dactual;
        seedsInfo(numSeed).volume = sum(sum(sum(regionActual)));
        seedsInfo(numSeed).colour = colours(numSeed, :);
        seedsInfo(numSeed).pxCoordinates = [x, y, z];

    end

    %plot 3d reconstruction ---- This section is out of the last loop
    %because we could not represent the cylinder due to the computational
    %cost.
    
%     f=figure('Visible','on');
%     for numSeed=1:numTotalSeeds
%         [voxelsCoordinates]=seedsInfo(numSeed).pxCoordinates;
%         cellFigure = alphaShape(voxelsCoordinates(:,1), voxelsCoordinates(:,2), voxelsCoordinates(:,3),4*reductionFactor);
%         plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 1);
%         hold on;
%     end
%     
%     

    %%Group pixels of 3d cells
    img3Dfinal= zeros(2*R_basal+1,2*R_basal+1,H_apical);
    for numSeed=1:numTotalSeeds
        cell3d=seedsInfo(numSeed).image3d;
        img3Dfinal(img3Dfinal==0)=img3Dfinal(img3Dfinal==0)+cell3d(img3Dfinal==0);
    end
    
    
    %%neighbours 3d
    [neigh3D,~]=calculate_neighbours3D(img3Dfinal);
    
%     save(['..\..\..\data\reconstructionVoronoiCylindricalSegment\' name2save '_surfaceRatio_' num2str(surfaceRatio) '_reductionFactorPixelsSize_' num2str(reductionFactor) '.mat'],'img3D', 'seedsInfo','apicalCylinderSeedsPositions','basalCylinderSeedsPositions','-v7.3');
%     savefig(f,['..\..\..\data\reconstructionVoronoiCylindricalSegment\' name2save '_surfaceRatio_' num2str(surfaceRatio) '_reductionFactorPixelsSize_' num2str(reductionFactor) '_.fig'])

end

