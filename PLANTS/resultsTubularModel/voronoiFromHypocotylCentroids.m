%% Voronoi model from Hypocotyl seeds
surfaceRatios = [1.15, 1.333];
names = {'Hypocotyl A', 'Hypocotyl B'};

for nHyp = 1 : length(names)
    
    load(['..\data\' names{nHyp} '\imagesOfLayers\layersClean.mat'],'finalImages');

    for nSurfR = 1 : length(surfaceRatios)
        layerOuter = finalImages{nHyp + nSurfR -1};
        layerInner = finalImages{nHyp + nSurfR};
        
        innerVoronoiProjectionFromOuter = getVoronoiProjectionFromSurface(layerOuter,1/surfaceRatios(nSurfR));
        outerVoronoiProjectionFromInner = getVoronoiProjectionFromSurface(layerInner,surfaceRatios(nSurfR));
    end
    
    
       
end