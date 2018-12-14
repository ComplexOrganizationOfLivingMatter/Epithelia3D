
clear all
files = dir('**/Salivary gland/**/Results/3d_layers_info.mat');

numberOfSurfaceRatios = 11;
%namesSR = arrayfun(@(x) ['sr' strrep(num2str(x),'.','_')],1:numberOfSurfaceRatios,'UniformOutput', false);
for numFile = 1:length(files)
    
    load(fullfile(files(numFile).folder, files(numFile).name));
    load(fullfile(files(numFile).folder, 'valid_cells.mat'));
    [infoPerSurfaceRatio, neighbours] = divideObjectInSurfaceRatios(labelledImage, basalLayer, apicalLayer, validCells, noValidCells, colours, files(numFile).folder);

    save(fullfile(files(numFile).folder, 'glandDividedInSurfaceRatios.mat'), 'infoPerSurfaceRatio', 'neighbours');
    
    neighsSurface = cell(numberOfSurfaceRatios,1);
    neighsAccumSurfaces = cell(numberOfSurfaceRatios,1);
    areaCells = cell(numberOfSurfaceRatios,1);
    volumes = cell(numberOfSurfaceRatios,1);
    
    neighsSurface{1} = neighbours{1}';
    neighsAccumSurfaces{1} = neighbours{1}';
    
    infoOfCells = infoPerSurfaceRatio{1, 4};
    
    areaCells(1) = {infoOfCells.Basal_area};
    volumes(1) = {infoOfCells.Volume};
    
    for idSR = 2:numberOfSurfaceRatios
        neighsSurface{idSR} = neighbours{idSR}';
        neighsAccumSurfaces{idSR} = cellfun(@(x,y) unique([x;y]),neighsAccumSurfaces{idSR-1},neighsSurface{idSR},'UniformOutput',false);
        
        infoOfCells = infoPerSurfaceRatio{idSR, 4};
        areaCells(idSR) = {infoOfCells.Basal_area};
        volumes(idSR) = {infoOfCells.Volume};
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

    %%
    meanNumNeighPerSurfaceRealization = mean(numNeighAccumPerSurfacesRealization(validCells, :), 1);
    stdNumNeighPerSurfaceRealization = std(numNeighAccumPerSurfacesRealization(validCells, :), 1);
    totalAreaPerSR = sum(areaCellsPerSurfaceRealization(validCells, :));
    
    surfaceRatioOfGland = vertcat(infoPerSurfaceRatio{:, 2})';
    
    infoEuler3D{numFile, 1} = vertcat(meanNumNeighPerSurfaceRealization, stdNumNeighPerSurfaceRealization, surfaceRatioOfGland)';
    
%     numNeighPerSurface{numFile, 1} = array2table(numNeighPerSurfaceRealization(validCells, :),'VariableNames',namesSR);
%     numNeighAccumPerSurfaces{numFile, 1} = array2table(numNeighAccumPerSurfacesRealization(validCells, :),'VariableNames',namesSR);
%     numNeighOfNeighPerSurface{numFile, 1} = array2table(numNeighOfNeighPerSurfacesRealization(validCells, :),'VariableNames',namesSR);
%     numNeighOfNeighAccumPerSurface{numFile, 1} = array2table(numNeighOfNeighAccumPerSurfacesRealization(validCells, :),'VariableNames',namesSR);
%     areaCellsPerSurface{numFile, 1} = array2table(areaCellsPerSurfaceRealization(validCells,:),'VariableNames',namesSR);
%     volumePerSurface{numFile, 1} = array2table(volumePerSurfaceRealization(validCells,:),'VariableNames',namesSR);
end

infoEuler3DCat = cat(1, infoEuler3D{:});

figure;
for numPoint = 1:size(infoEuler3DCat, 1)
    hold on;
    plot(infoEuler3DCat(numPoint, 3), infoEuler3DCat(numPoint, 1), '*k')
end
title('euler neighbours 3D')
xlabel('surface ratio')
ylabel('neighbours total')
xlim([1, 15]);
ylim([0,15]);

myfittypeLog10=fittype('6 +b*log10(x)',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'b'});

myfitLog10=fit(infoEuler3DCat(:, 3),infoEuler3DCat(:, 1),myfittypeLog10,'StartPoint',1);
hold on; plot(myfitLog10);

%getStatsAndRepresentationsEulerLewis3D(numNeighOfNeighPerSurface,numNeighOfNeighAccumPerSurface,numNeighPerSurface,numNeighAccumPerSurfaces,areaCellsPerSurface,volumePerSurface,'Results/SalivaryGlands/',[1 2]);