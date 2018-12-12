
clear all
files = dir('**/Salivary gland/**/Results/3d_layers_info.mat');

numberOfSurfaceRatios = 2;
namesSR = arrayfun(@(x) ['sr' strrep(num2str(x),'.','_')],1:numberOfSurfaceRatios,'UniformOutput', false);
for numFile = 1:length(files)
    load(fullfile(files(numFile).folder, files(numFile).name));
    load(fullfile(files(numFile).folder, 'valid_cells.mat'));
    
    neighsSurface = cell(numberOfSurfaceRatios,1);
    neighsAccumSurfaces = cell(numberOfSurfaceRatios,1);
    areaCells = cell(numberOfSurfaceRatios,1);
    volumes = cell(numberOfSurfaceRatios,1);
    
    neighsSurface{1} = apical3dInfo.neighbourhood';
    neighsAccumSurfaces{1} = apical3dInfo.neighbourhood';
    area = regionprops(apicalLayer,'Area');
    areaCells{1} = cat(1,area.Area);
    volume = regionprops3(labelledImage,'Volume');
    volumes{1} = cat(1,volume.Volume);
    
    for idSR = 2:numberOfSurfaceRatios
        neighsSurface{idSR} = basal3dInfo.neighbourhood';
        neighsAccumSurfaces{idSR}  = cellfun(@(x,y) unique([x;y]),neighsAccumSurfaces{idSR-1},neighsSurface{idSR},'UniformOutput',false);
        
        area = regionprops(basalLayer,'Area');
        areaCells{idSR} = cat(1,area.Area);
        volume = regionprops3(labelledImage,'Volume');
        volumes{idSR} = cat(1,volume.Volume);
    end
    
    areaCellsPerSurfaceRealization = cat(2,areaCells{:});
    volumePerSurfaceRealization = cat(2,volumes{:});
    neighsSurface = cat(1,neighsSurface{:})';
    neighsAccumSurfaces = cat(1,neighsAccumSurfaces{:})';
    
    numNeighPerSurfaceRealization = cellfun(@(x) length(x),neighsSurface);
    numNeighAccumPerSurfacesRealization = cellfun(@(x) length(x),neighsAccumSurfaces);
    
    numNeighOfNeighPerSurfacesRealization = zeros(size(neighsSurface));
    numNeighOfNeighAccumPerSurfacesRealization = zeros(size(neighsSurface));
    for nSR = 1:numberOfSurfaceRatios
        numNeighOfNeighPerSurfacesRealization(:,nSR) = cellfun(@(x) sum(vertcat(numNeighPerSurfaceRealization(x,nSR)))/length(x),neighsSurface(:,nSR));
        numNeighOfNeighAccumPerSurfacesRealization(:,nSR) = cellfun(@(x) sum(vertcat(numNeighAccumPerSurfacesRealization(x,nSR)))/length(x),neighsAccumSurfaces(:,nSR));
    end

    numNeighPerSurface{numFile, 1} = array2table(numNeighPerSurfaceRealization(validCells, :),'VariableNames',namesSR);
    numNeighAccumPerSurfaces{numFile, 1} = array2table(numNeighAccumPerSurfacesRealization(validCells, :),'VariableNames',namesSR);
    numNeighOfNeighPerSurface{numFile, 1} = array2table(numNeighOfNeighPerSurfacesRealization(validCells, :),'VariableNames',namesSR);
    numNeighOfNeighAccumPerSurface{numFile, 1} = array2table(numNeighOfNeighAccumPerSurfacesRealization(validCells, :),'VariableNames',namesSR);
    areaCellsPerSurface{numFile, 1} = array2table(areaCellsPerSurfaceRealization(validCells,:),'VariableNames',namesSR);
    volumePerSurface{numFile, 1} = array2table(volumePerSurfaceRealization(validCells,:),'VariableNames',namesSR);
end
getStatsAndRepresentationsEulerLewis3D(numNeighOfNeighPerSurface,numNeighOfNeighAccumPerSurface,numNeighPerSurface,numNeighAccumPerSurfaces,areaCellsPerSurface,volumePerSurface,'Results/SalivaryGlands/',[1 2]);