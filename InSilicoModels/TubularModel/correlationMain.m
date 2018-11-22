%% LEWIS - EULER 3D
addpath(genpath('src'))
%input parameters
initialDiagrams = [1 5];

cylinderTypes = {'Voronoi', 'Frusta'};
basalExpansions= 1./([1:-0.1:0.1]);
surfaceRatios = sort([basalExpansions,[4 6 7 8 9 11 12 13 14 15]]);
reductionFactor = 2;
nRealizations = 20;
W_init = 512;
H_init = 4096;
nSeeds = 200;
typeProjection = 'expansion'; %or 'reduction'


for cylinderTypeNum = 1:length(cylinderTypes)
    for nDiagrams = length(initialDiagrams)
        
        correlationVolumeAreaSidesSurfaceRatio(cylinderTypes{cylinderTypeNum}, initialDiagrams(nDiagrams),surfaceRatios,reductionFactor,W_init,H_init,typeProjection,nSeeds,nRealizations)
        
    end
end
