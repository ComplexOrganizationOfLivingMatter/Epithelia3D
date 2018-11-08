%% LEWIS - EULER 3D
addpath(genpath('src'))
%input parameters
initialDiagram  = 5;
nRealizations = 20;
W_init = 512;
H_init = 4096;
nSeeds = 200;
typeProjection = 'expansion';
surfaceRatios = 1./(1:-0.1:0.1);
reductionFactor = 1;
totalCells = 1:nSeeds;
namesSR = arrayfun(@(x) ['sr' strrep(num2str(x),'.','_')],surfaceRatios,'UniformOutput', false);


numNeighPerSurface = cell(nRealizations,1);
numNeighAccumPerSurfaces = cell(nRealizations,1);
areaCellsPerSurface = cell(nRealizations,1);
volumePerSurface = cell(nRealizations,1);

%path to load and save
rootPath =  ['D:\Pedro\Epithelia3D\InSilicoModels\TubularModel\data\tubularVoronoiModel\' typeProjection '\'];
folder = [num2str(W_init) 'x' num2str(H_init) '_' num2str(nSeeds) 'seeds\'];

% if ~exist([rootPath folder 'relationAreaVolumeSidesSurfaceRatio.mat'],'file')

    for nImg = 1 : nRealizations
        load([rootPath folder 'Image_' num2str(nImg) '_Diagram_' num2str(initialDiagram)...
            '\Image_' num2str(nImg) '_Diagram_' num2str(initialDiagram) '.mat'],'listLOriginalProjection','listSeedsProjected');

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
%                 voronoi3D = imresize(voronoi3D,reductionFactor,'nearest');
                volumes{idSR} = arrayfun(@(x) sum(voronoi3D(:) == x),totalCells');
            end
        end
        numNeighPerSurfaceRealization = cellfun(@(x) length(x),cat(1,neighsSurface{:})');
        numNeighAccumPerSurfacesRealization = cellfun(@(x) length(x),cat(1,neighsAccumSurfaces{:})');
        areaCellsPerSurfaceRealization = cat(2,areaCells{:});
        volumePerSurfaceRealization = cat(2,volumes{:});

        noValidCellsTotal = unique(cat(2,noValidCells{:}));
        validCellsTotal = setdiff(totalCells,noValidCellsTotal);

        numNeighPerSurface{nImg} = array2table(numNeighPerSurfaceRealization(validCellsTotal,:),'VariableNames',namesSR);
        numNeighAccumPerSurfaces{nImg} = array2table(numNeighAccumPerSurfacesRealization(validCellsTotal,:),'VariableNames',namesSR);
        areaCellsPerSurface{nImg} = array2table(areaCellsPerSurfaceRealization(validCellsTotal,:),'VariableNames',namesSR);
        volumePerSurface{nImg} = array2table(volumePerSurfaceRealization(validCellsTotal,:),'VariableNames',namesSR);
        
        disp(['Completed volume realization - ' num2str(nImg)])
    end

%     save([rootPath folder 'relationAreaVolumeSidesSurfaceRatio.mat'],'numNeighPerSurface','numNeighAccumPerSurfaces','areaCellsPerSurface','volumePerSurface')
    
% else
%     load([rootPath folder 'relationAreaVolumeSidesSurfaceRatio.mat'],'numNeighPerSurface','numNeighAccumPerSurfaces','areaCellsPerSurface','volumePerSurface')
% end

% path2save = [rootPath folder 'lewisEuler\'];
% 
% getStatsAndRepresentationsEulerLewis3D(numNeighPerSurface,numNeighAccumPerSurfaces,areaCellsPerSurface,volumePerSurface,path2save);