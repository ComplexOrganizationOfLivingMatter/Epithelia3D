clear all
close all

addpath(genpath('src'))
%input parameters
initialDiagrams = 8;

cylinderTypes = {'Voronoi'};%, 'Frusta'};
surfaceRatios = 1:0.25:10;

%reduction factor to create a Voronoi tube 3D over a 3d image
reductionFactor = 2;
nRealizations = 20;
W_init = 512;
H_init = 4096;
nSeeds = 200;
typeProjection = 'expansion'; %or 'reduction'


for cylinderTypeNum = 1:length(cylinderTypes)
    for nDiagrams = 1:length(initialDiagrams)
        %% Get measurements such as area, sides, surface ratios and volumes
        correlationVolumeAreaSidesSurfaceRatio(cylinderTypes{cylinderTypeNum}, initialDiagrams(nDiagrams),surfaceRatios,reductionFactor,W_init,H_init,typeProjection,nSeeds,nRealizations)
        
    end
end
