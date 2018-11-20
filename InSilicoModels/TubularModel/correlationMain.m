%% LEWIS - EULER 3D
addpath(genpath('src'))
%input parameters
initialDiagram = 5;

cylinderTypes = {'Voronoi', 'Frusta'};

for cylinderTypeNum = 1:2
    cyliderType = cylinderTypes{cylinderTypeNum};%Voronoi
    correlationVolumeAreaSidesSurfaceRatio(cyliderType, initialDiagram);
end
