%% LEWIS - EULER 3D
addpath(genpath('src'))
%input parameters
initialDiagram  = 1;
nRealizations = 20;
W_init = 512;
H_init = 4096;
nSeeds = 200;
typeProjection = 'expansion';
surfaceRatios = 1./(1:-0.1:0.1);
reductionFactor = 5;
totalCells = 1:nSeeds;
namesSR = arrayfun(@(x) ['sr' strrep(num2str(x),'.','_')],surfaceRatios,'UniformOutput', false);
cyliderType = 'Frusta';%Voronoi


numNeighPerSurface = cell(nRealizations,1);
numNeighAccumPerSurfaces = cell(nRealizations,1);
areaCellsPerSurface = cell(nRealizations,1);
volumePerSurface = cell(nRealizations,1);

%path to load and save
rootPath =  ['data\tubularVoronoiModel\' typeProjection '\'];
folder = [num2str(W_init) 'x' num2str(H_init) '_' num2str(nSeeds) 'seeds\diagram' num2str(initialDiagram) '\'];

if ~exist([rootPath folder 'relationAreaVolumeSidesSurfaceRatio_' cyliderType '.mat'],'file')

    for nImg = 1 : nRealizations
        load([rootPath folder 'Image_' num2str(nImg) '_Diagram_' num2str(initialDiagram)...
            '\Image_' num2str(nImg) '_Diagram_' num2str(initialDiagram) '.mat'],'listLOriginalProjection','listSeedsProjected');
        if iscell(listSeedsProjected)
            listSeedsProjected= cell2table(listSeedsProjected,'VariableNames',{'surfaceRatio','seedsApical'});
            listLOriginalProjection = cell2table(listLOriginalProjection,'VariableName',{'surfaceRatio','L_originalProjection'});
        end
    
        seedsApical = listSeedsProjected.seedsApical{listSeedsProjected.surfaceRatio==1};
        noValidCells = cell(length(surfaceRatios),1);
        neighsSurface = cell(length(surfaceRatios),1);
        neighsAccumSurfaces = cell(length(surfaceRatios),1);
        areaCells = cell(length(surfaceRatios),1);
        volumes = cell(length(surfaceRatios),1);
        
        voronoi3D = [];
        for idSR = 1:length(surfaceRatios)

            L_img = listLOriginalProjection.L_originalProjection{listLOriginalProjection.surfaceRatio==surfaceRatios(idSR)};
            [neighsSurface{idSR},~] = calculateNeighbours(L_img);

            noValidCellSR = unique([unique(L_img(1,:)),unique(L_img(end,:))]);
            noValidCells{idSR} = noValidCellSR(noValidCellSR~=0);
            area = regionprops(L_img,'Area');
            areaCells{idSR} = cat(1,area.Area);

            if idSR == 1
                L_imgApical = L_img;
                neighsAccumSurfaces{idSR} = neighsSurface{idSR};
                volumes{idSR} =  areaCells{idSR};
                [voronoi3D] = create3DCylinder( seedsApical(:,2:3), H_init, W_init, surfaceRatios, max(surfaceRatios),reductionFactor,L_imgApical,cyliderType);

            else 
                %get invalid region
                H_init=round(H_init/reductionFactor);
                W_init=round(W_init/reductionFactor);
                R_apical=W_init/(2*pi);
                R_apical=round(R_apical);
                R_basal=surfaceRatios(idSR)*R_apical;
                R_basal=round(R_basal);
                R_basalMax=max(surfaceRatios)*R_apical;
                R_basalMax=round(R_basalMax);
                [imgInvalidRegion,~,~,~]=get3DCylinderLimitsBasalApicalandIntermediate(R_basal,R_basalMax,R_apical,H_init,[]);

                neighsAccumSurfaces{idSR}  = cellfun(@(x,y) unique([x;y]),neighsAccumSurfaces{idSR-1},neighsSurface{idSR},'UniformOutput',false);
                voronoi3DSR = voronoi3D;
                voronoi3DSR(imgInvalidRegion>0)=0;
                voronoi3Dresized = imresize(voronoi3DSR,reductionFactor,'nearest');
                totalLabelsRepeated = voronoi3Dresized(voronoi3Dresized(:)>0);
                if length(unique(totalLabelsRepeated)) < max(totalCells)
                    disp('ohhhh shit')
                end
                volumes{idSR} = arrayfun(@(x) sum(totalLabelsRepeated(:) == x),totalCells');
            end
            disp(['Completed volume realization - ' num2str(nImg) ' - SR - ' num2str(surfaceRatios(idSR))])
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
        
        
    end

    save([rootPath folder 'relationAreaVolumeSidesSurfaceRatio_' cyliderType '.mat'],'numNeighPerSurface','numNeighAccumPerSurfaces','areaCellsPerSurface','volumePerSurface')
    
else
    load([rootPath folder 'relationAreaVolumeSidesSurfaceRatioVoronoi_' cyliderType '.mat'],'numNeighPerSurface','numNeighAccumPerSurfaces','areaCellsPerSurface','volumePerSurface')
end

path2save = [rootPath folder 'lewisEuler\'];
getStatsAndRepresentationsEulerLewis3D(numNeighPerSurface,numNeighAccumPerSurfaces,areaCellsPerSurface,volumePerSurface,path2save);