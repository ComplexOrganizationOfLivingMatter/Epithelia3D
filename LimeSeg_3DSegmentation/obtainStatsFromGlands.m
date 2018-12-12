

files = dir('**/3d_layers_info.mat');

numberOfSurfaceRatios = 2;

for numFile = 1:length(files)
    load(fullfile(files(numFile).folder, files(numFile).name));
    load(fullfile(files(numFile).folder, 'valid_cells.mat'));
    
    neighsSurface{1} = apical3dInfo.neighbourhood;
    neighsAccumSurfaces{1} = apical3dInfo.neighbourhood;
    
    for idSR = 2:numberOfSurfaceRatios
        [neighsSurface{idSR},~] = basal3dInfo.neighbourhood;
        neighsAccumSurfaces{idSR}  = cellfun(@(x,y) unique([x;y]),neighsAccumSurfaces{idSR-1},neighsSurface{idSR},'UniformOutput',false);
    end
    
    numNeighPerSurfaceRealization = cellfun(@(x) length(x),neighsSurface);
    numNeighAccumPerSurfacesRealization = cellfun(@(x) length(x),neighsAccumSurfaces);
    
    numNeighOfNeighPerSurfacesRealization = zeros(numberOfSurfaceRatios);
    numNeighOfNeighAccumPerSurfacesRealization = zeros(numberOfSurfaceRatios);
    for nSR = 1:numberOfSurfaceRatios
        numNeighOfNeighPerSurfacesRealization(:,nSR) = cellfun(@(x) sum(vertcat(numNeighPerSurfaceRealization(x,nSR)))/length(x),neighsSurface(:,nSR));
        numNeighOfNeighAccumPerSurfacesRealization(:,nSR) = cellfun(@(x) sum(vertcat(numNeighAccumPerSurfacesRealization(x,nSR)))/length(x),neighsAccumSurfaces(:,nSR));
    end

    numNeighPerSurface{numFile} = array2table(numNeighPerSurfaceRealization(validCells, :),'VariableNames',namesSR);
    numNeighAccumPerSurfaces{numFile} = array2table(numNeighAccumPerSurfacesRealization(validCells, :),'VariableNames',namesSR);
    numNeighOfNeighPerSurface{numFile} = array2table(numNeighOfNeighPerSurfacesRealization(validCells, :),'VariableNames',namesSR);
    numNeighOfNeighAccumPerSurface{numFile} = array2table(numNeighOfNeighAccumPerSurfacesRealization(validCells, :),'VariableNames',namesSR);
    areaCellsPerSurface{nImg} = array2table(areaCellsPerSurfaceRealization(validCells,:),'VariableNames',namesSR);
    volumePerSurface{nImg} = array2table(volumePerSurfaceRealization(validCells,:),'VariableNames',namesSR);
end
getStatsAndRepresentationsEulerLewis3D(numNeighOfNeighPerSurface,numNeighOfNeighAccumPerSurface,numNeighPerSurface,numNeighAccumPerSurfaces,areaCellsPerSurface,volumePerSurface,path2save,surfaceRatios);