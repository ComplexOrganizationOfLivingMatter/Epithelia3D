%% LEWIS - EULER 3D

initialDiagram  = 5;
nRealizations = 20;
W_init = 512;
H_init = 4096;
nSeeds = 200;
typeProjection = 'expansion';
surfaceRatios = 1./(1:-0.1:0.1);
reductionFactor = 6;

namesSR = arrayfun(@(x) ['sr' strrep(num2str(x),'.','_')],surfaceRatios,'UniformOutput', false);

totalCells = 1:nSeeds;

rootPath =  ['D:\Pedro\Epithelia3D\InSilicoModels\TubularModel\data\tubularVoronoiModel\' typeProjection '\'];

numNeighPerSurface = cell(nRealizations,1);
numNeighAccumPerSurfaces = cell(nRealizations,1);
areaCellsPerSurface = cell(nRealizations,1);
volumesPerSurface = cell(nRealizations,1);

if ~exist([rootPath folder 'relationAreaVolumeSidesSurfaceRatio.mat'],'file')

    for nImg = 1 : nRealizations
        folder = [num2str(W_init) 'x' num2str(H_init) '_' num2str(nSeeds) 'seeds\Image_' num2str(nImg) '_Diagram_' num2str(initialDiagram) '\'];
        load([rootPath folder 'Image_' num2str(nImg) '_Diagram_' num2str(initialDiagram) '.mat'],'listLOriginalProjection','listSeedsProjected');

        seedsApical = listSeedsProjected.seedsApical{listSeedsProjected.surfaceRatio==1};
        noValidCells = cell(length(surfaceRatios),1);
        neighsSurface = cell(length(surfaceRatios),1);
        neighsAccumSurfaces = cell(length(surfaceRatios),1);
        areaCells = cell(length(surfaceRatios),1);
        volumes = cell(length(surfaceRatios),1);
        for idSR = 1:length(surfaceRatios)

            L_img = listLOriginalProjection.L_originalProjection{listLOriginalProjection.surfaceRatio==surfaceRatios(idSR)};
            [neighsSurface{idSR},~] = calculateNeighbours(L_img);



            noValidCellSR = unique([unique(L_img(1,:)),unique(L_img(end,:))]);
            noValidCells{idSR} = noValidCellSR(noValidCellSR~=0);
            area = regionprops(L_img,'Area');
            areaCells{idSR} = cat(1,area.Area);

            if idSR == 1
                neighsAccumSurfaces{idSR} = neighsSurface{idSR};
                volumes{idSR} =  areaCells{idSR};
            else 
                neighsAccumSurfaces{idSR}  = cellfun(@(x,y) unique([x;y]),neighsAccumSurfaces{idSR-1},neighsSurface{idSR},'UniformOutput',false);
                [voronoi3D] = create3DCylinder( seedsApical(:,2:3), H_init, W_init, surfaceRatios(idSR),reductionFactor,[]);
                voronoi3D = imresize(voronoi3D,reductionFactor,'nearest');
                volumes{idSR} = arrayfun(@(x) sum(voronoi3D(:) == x),totalCells');
            end
        end
        numNeighPerSurfaceRealization = cellfun(@(x) length(x),cat(1,neighsSurface{:})');
        numNeighAccumPerSurfacesRealization = cellfun(@(x) length(x),cat(1,neighsAccumSurfaces{:})');
        areaCellsPerSurfaceRealization = cat(2,areaCells{:});
        volumesPerSurfaceRealization = cat(2,volumes{:});

        noValidCellsTotal = unique(cat(2,noValidCells{:}));
        validCellsTotal = setdiff(totalCells,noValidCellsTotal);

        numNeighPerSurface{nImg} = array2table(numNeighPerSurfaceRealization(validCellsTotal,:),'VariableNames',namesSR);
        numNeighAccumPerSurfaces{nImg} = array2table(numNeighAccumPerSurfacesRealization(validCellsTotal,:),'VariableNames',namesSR);
        areaCellsPerSurface{nImg} = array2table(areaCellsPerSurfaceRealization(validCellsTotal,:),'VariableNames',namesSR);
        volumesPerSurface{nImg} = array2table(volumesPerSurfaceRealization(validCellsTotal,:),'VariableNames',namesSR);
    end

    save([rootPath folder 'relationAreaVolumeSidesSurfaceRatio.mat'],'numNeighPerSurface','numNeighAccumPerSurfaces','areaCellsPerSurface','volumesPerSurface')
    
else
    load([rootPath folder 'relationAreaVolumeSidesSurfaceRatio.mat'],'numNeighPerSurface','numNeighAccumPerSurfaces','areaCellsPerSurface','volumesPerSurface')
end

% getStatsAndRepresentationsEulerLewis3D(numNeighPerSurface,numNeighAccumPerSurfaces,areaCellsPerSurface,volumesPerSurface);