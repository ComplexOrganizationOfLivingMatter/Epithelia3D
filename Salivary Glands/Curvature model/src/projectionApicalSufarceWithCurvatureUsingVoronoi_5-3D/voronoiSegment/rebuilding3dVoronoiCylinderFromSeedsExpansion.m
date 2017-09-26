function rebuilding3dVoronoiCylinderFromSeedsExpansion( initialSeeds, H_apical, W_apical, surfaceRatio,name2save)

addpath('lib')

% initialImg=listLOriginalProjection.L_originalProjection{1,1};
% initialSeeds=listSeedsProjected.seedsApical{1,1};
% initialSeeds=initialSeeds(:,2:end);
% surfaceRatio=5;
% [H,W]=size(initialImg);

%apical radius of cylinder from 2D voronoi cylindrical image
R_apical=W_apical/(2*pi);
R_apical=round(R_apical);
%pixels relocation from cylinder angle
angleOfSeedsLocation=(W_apical/360)*initialSeeds(:,2);

%% Cylinder seeds position: x=R*cos(angle); y=R*sin(angle);
%final location of seeds in basal region
R_basal=surfaceRatio*R_apical;
R_basal=round(R_basal);
basalCylinderSeedsPositions.x=round(R_basal*cosd(angleOfSeedsLocation))+R_basal+1;
basalCylinderSeedsPositions.y=round(R_basal*sind(angleOfSeedsLocation))+R_basal+1;
basalCylinderSeedsPositions.z=initialSeeds(:,1);

%initial location of seeds. 
apicalCylinderSeedsPositions.x=round(R_apical*cosd(angleOfSeedsLocation))+R_basal+1;
apicalCylinderSeedsPositions.y=round(R_apical*sind(angleOfSeedsLocation))+R_basal+1;
apicalCylinderSeedsPositions.z=initialSeeds(:,1);

%empty Region (lumen or out of cylinder)
maskCentralPoint=zeros(2*R_basal+1,2*R_basal+1);
maskCentralPoint(R_basal,R_basal)=1;
imgDiskBasal=imdilate(maskCentralPoint,strel('disk',R_basal,8));
imgDiskApical=imdilate(maskCentralPoint,strel('disk',R_apical,8));
imgInvalidRegion=1-(imgDiskBasal-imgDiskApical);
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
figure;
 
numTotalSeeds=size(initialSeeds, 1);
seedsInfo=struct('ID',cell(numTotalSeeds,1),'region',cell(numTotalSeeds,1),'volume',cell(numTotalSeeds,1),'colour',cell(numTotalSeeds,1),'pxCoordinates',cell(numTotalSeeds,1));
parfor numSeed = 1:size(initialSeeds, 1)
    numSeed
    
    %chose a seed to work
    img3DActual = zeros(2*R_basal+1,2*R_basal+1,H_apical);
    img3DActual(maskOfGlobalImage==numSeed)=1;
    
    %check the distance matrix from a given segment of seeds and compare
    %with the global distance matrix
    imgDistPerSeed = bwdist(img3DActual);

    %label 3d region and get indexes
    regionActual = imgDistPerSeed == distSegments;
    img3DActual(regionActual) = numSeed;
    [x, y, z] = findND(img3DActual == numSeed);
    cellFigure = alphaShape(x, y, z);
    plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
    hold on;
      
    %store info of 3D voronoi cells
    seedsInfo(numSeed).ID = numSeed;
    seedsInfo(numSeed).region = regionActual;
    seedsInfo(numSeed).volume = cellFigure.volume;
    seedsInfo(numSeed).colour = colours(numSeed, :);
    seedsInfo(numSeed).pxCoordinates = [x, y, z];
    
end


save(['..\..\..\data\reconstructionVoronoiCylindricalSegment\' name2save '_surfaceRatio_' num2str(surfaceRatio) '.mat'], 'seedsInfo','apicalCylinderSeedsPositions','basalCylinderSeedsPositions');


end

