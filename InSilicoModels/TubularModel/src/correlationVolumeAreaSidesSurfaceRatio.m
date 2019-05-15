function [] = correlationVolumeAreaSidesSurfaceRatio(cyliderType, initialDiagram,surfaceRatios,reductionFactor,W_init,H_init,typeProjection,nSeeds,nRealizations)

    totalCells = 1:nSeeds;
    namesSR = arrayfun(@(x) ['sr' strrep(num2str(x),'.','_')],surfaceRatios,'UniformOutput', false);
    numNeighPerSurface = cell(nRealizations,1);
    numNeighAccumPerSurfaces = cell(nRealizations,1);
    numNeighOfNeighPerSurface = cell(nRealizations,1);
    numNeighOfNeighAccumPerSurface = cell(nRealizations,1);
    areaCellsPerSurface = cell(nRealizations,1);
    volumePerSurface = cell(nRealizations,1);

    %path to load and save
    rootPath =  ['data\tubularVoronoiModel\' typeProjection '\'];
    folder = [num2str(W_init) 'x' num2str(H_init) '_' num2str(nSeeds) 'seeds\diagram' num2str(initialDiagram) '_Markov\'];

    path2save = [rootPath folder cyliderType 'LewisEuler_redFactor_' num2str(reductionFactor)  '\'];


    if ~exist([path2save 'relationAreaVolumeSidesSurfaceRatio.mat'],'file')

        mkdir(path2save)
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

                %% Data from apical
                if idSR == 1
                    L_imgApical = L_img;
                    noValidCellSR = unique([unique(L_imgApical(1,:)),unique(L_imgApical(end,:))]);
                    noValidCells{idSR} = noValidCellSR(noValidCellSR~=0);
                    [neighboursApical,~] = calculateNeighbours(L_imgApical);
                    neighsSurface{idSR} = neighboursApical;
                    area = regionprops(L_img,'Area');
                    areaCells{idSR} = cat(1,area.Area);
                    neighsAccumSurfaces{idSR} = neighsSurface{idSR};
%                     volumes{idSR} =  areaCells{idSR};
%                     %% Get total 3D cylinder
%                     [voronoi3D] = create3DCylinder( seedsApical(:,2:3), H_init, W_init, surfaceRatios, max(surfaceRatios),reductionFactor,L_imgApical,cyliderType);
                    disp(['created 3D cylinder ' num2str(nImg) ' - starting measurements'])
                else 
%                     %% get invalid region for each surface ratio
%                     H_apical=round(H_init/reductionFactor);
%                     W_apical=round(W_init/reductionFactor);
%                     R_apical=round(W_apical/(2*pi));
%                     R_basal=round(surfaceRatios(idSR)*R_apical);
%                     R_basalMax=round(max(surfaceRatios)*R_apical);
%                     [imgInvalidRegion,~,~,~]=get3DCylinderLimitsBasalApicalandIntermediate(R_basal,R_basalMax,R_apical,H_apical,[]);

                    %% get area, neighbours and no valid cells in Voronoi cases
                    if contains(lower(cyliderType),'voronoi')
                        noValidCellSR = unique([unique(L_img(1,:)),unique(L_img(end,:))]);
                        noValidCells{idSR} = noValidCellSR(noValidCellSR~=0);
                        area = regionprops(L_img,'Area');
                        areaCells{idSR} = cat(1,area.Area);
                        [neighsSurface{idSR},~] = calculateNeighbours(L_img);
                        neighsAccumSurfaces{idSR}  = cellfun(@(x,y) unique([x;y]),neighsAccumSurfaces{idSR-1},neighsSurface{idSR},'UniformOutput',false);
                    %% get area, neighbours and no valid cells in Frusta cases
                    else
                        noValidCells{idSR} = noValidCellSR(noValidCellSR~=0);
                        L_imgFrusta2D = imresize(L_imgApical,[size(L_imgApical,1),round(size(L_imgApical,2)*surfaceRatios(idSR))],'nearest');
                        area = regionprops(L_imgFrusta2D,'Area');
                        areaCells{idSR} = cat(1,area.Area);
                        neighsSurface{idSR} = neighboursApical;
                        neighsAccumSurfaces{idSR} = neighboursApical;
                    end

%                     %% quantify volume per cell and SR
%                     voronoi3DSR = voronoi3D;
%                     voronoi3DSR(imgInvalidRegion>0)=0;
%                     voronoi3Dresized = imresize(voronoi3DSR,reductionFactor,'nearest');
%                     totalLabelsRepeated = voronoi3Dresized(voronoi3Dresized(:)>0);
%                     if length(unique(totalLabelsRepeated)) < max(totalCells)
%                         disp('Resolution error. Seeds overlapping')
%                     end
%                     volumes{idSR} = arrayfun(@(x) sum(totalLabelsRepeated(:) == x),totalCells');
                end
                disp(['Completed volume realization - ' num2str(nImg) ' - SR - ' num2str(surfaceRatios(idSR))])
            end

            %get neighs per surface, and the average of neighs surrounding
            %the cells
            neighsSurface = cat(1,neighsSurface{:})';
            neighsAccumSurfaces = cat(1,neighsAccumSurfaces{:})';
            numNeighPerSurfaceRealization = cellfun(@(x) length(x),neighsSurface);
            numNeighAccumPerSurfacesRealization = cellfun(@(x) length(x),neighsAccumSurfaces);
            
            numNeighOfNeighPerSurfacesRealization = zeros(size(neighsSurface));
            numNeighOfNeighAccumPerSurfacesRealization = zeros(size(neighsSurface));
            for nSR = 1:size(neighsAccumSurfaces,2)
                numNeighOfNeighPerSurfacesRealization(:,nSR) = cellfun(@(x) sum(vertcat(numNeighPerSurfaceRealization(x,nSR)))/length(x),neighsSurface(:,nSR));
                numNeighOfNeighAccumPerSurfacesRealization(:,nSR) = cellfun(@(x) sum(vertcat(numNeighAccumPerSurfacesRealization(x,nSR)))/length(x),neighsAccumSurfaces(:,nSR));
            end
            
            areaCellsPerSurfaceRealization = cat(2,areaCells{:});
            volumePerSurfaceRealization = cat(2,volumes{:});

            %get valid and no valid cells
            noValidCellsTotal = unique(cat(2,noValidCells{:}));
            validCellsTotal = setdiff(totalCells,noValidCellsTotal);

            %store information from valid cells
            numNeighPerSurface{nImg} = array2table(numNeighPerSurfaceRealization(validCellsTotal,:),'VariableNames',namesSR);
            numNeighAccumPerSurfaces{nImg} = array2table(numNeighAccumPerSurfacesRealization(validCellsTotal,:),'VariableNames',namesSR);
            numNeighOfNeighPerSurface{nImg} = array2table(numNeighOfNeighPerSurfacesRealization(validCellsTotal,:),'VariableNames',namesSR);
            numNeighOfNeighAccumPerSurface{nImg} = array2table(numNeighOfNeighAccumPerSurfacesRealization(validCellsTotal,:),'VariableNames',namesSR);
            areaCellsPerSurface{nImg} = array2table(areaCellsPerSurfaceRealization(validCellsTotal,:),'VariableNames',namesSR);
%             volumePerSurface{nImg} = array2table(volumePerSurfaceRealization(validCellsTotal,:),'VariableNames',namesSR);
            save([path2save 'relationAreaVolumeSidesSurfaceRatio.mat'],'numNeighOfNeighPerSurface','numNeighOfNeighAccumPerSurface','numNeighPerSurface','numNeighAccumPerSurfaces','areaCellsPerSurface','volumePerSurface')

        end
        
    else
        load([path2save 'relationAreaVolumeSidesSurfaceRatio.mat'],'numNeighOfNeighPerSurface','numNeighOfNeighAccumPerSurface','numNeighPerSurface','numNeighAccumPerSurfaces','areaCellsPerSurface','volumePerSurface')
    end

    getStatsAndRepresentationsEulerLewis3D(numNeighOfNeighPerSurface,numNeighOfNeighAccumPerSurface,numNeighPerSurface,numNeighAccumPerSurfaces,areaCellsPerSurface,volumePerSurface,path2save,surfaceRatios,initialDiagram);
end

