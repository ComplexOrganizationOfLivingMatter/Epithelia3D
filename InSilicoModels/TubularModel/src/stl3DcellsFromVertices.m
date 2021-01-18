close all 
clear all

addpath(genpath('src'))

%Draw 3D Voronoi cells from delaunay data
srSelected = [4];
cellIdsSelectedV1 = [60,100,102,150];
realizationSelected = 1;
voronoiNumber = 1:10;
path2save = 'D:\Pedro\Epithelia3D\3D_laws\delaunayData\stlCells';

resizeFactor = 0.5;
wImgApical = 512*resizeFactor;
hImg = 4096*resizeFactor;
R_apical = wImgApical/(2*pi);



for nSr = srSelected
    parfor nCell =  1:length(cellIdsSelectedV1)
        for nVor = voronoiNumber
            folderExcel = ['D:\Pedro\Epithelia3D\InSilicoModels\TubularModel\data\tubularVoronoiModel\expansion\512x4096_200seeds\diagram' num2str(nVor) '_Markov\verticesSamira\'];
            for nRea = realizationSelected
                maskTube3D = false(2*ceil(R_apical*nSr),2*ceil(R_apical*nSr),hImg);
                maskCell3D = maskTube3D;
                mask2DValidRegion = zeros(2*ceil(R_apical*nSr),2*ceil(R_apical*nSr));
                mask2DValidRegion(size(mask2DValidRegion,1)/2,size(mask2DValidRegion,2)/2)=1;
                maskApical = createCirclesMask([size(maskTube3D,1),size(maskTube3D,2)],round([size(mask2DValidRegion,1)/2,size(mask2DValidRegion,2)/2]),floor(R_apical));
                maskBasal = createCirclesMask([size(maskTube3D,1),size(maskTube3D,2)],round([size(mask2DValidRegion,1)/2,size(mask2DValidRegion,2)/2]),floor(R_apical*nSr));
                invalidRegion2D = maskApical==0 + maskBasal;
%                 limit3Dbasal = repmat(bwperim(maskBasal),[1,1,hImg]);
                [row2DInvalid,col2DInvalid] = find(invalidRegion2D);
                 
                nameExcel = ['Voronoi_realization' num2str(nRea) '_samirasFormat_26-Nov-2019.xls'];
                tableVertices = readtable([folderExcel nameExcel]);
                
                %find matching CellID (looking for the closest centroid)
                if nVor ==1
                    tableVerticesSelectedCell = tableVertices(ismember(tableVertices.CellIDs,cellIdsSelectedV1(nCell)),:);
                    sr1Id = ismember(tableVerticesSelectedCell.Radius,1);
                    tableCellV1 = tableVerticesSelectedCell(sr1Id,:);
                    verticesCellV1 = table2array(tableCellV1(1,5:end));
                    verticesCellV1 = verticesCellV1(~isnan(verticesCellV1))*resizeFactor;
                    vertV1XY = [verticesCellV1(1:2:end)',verticesCellV1(2:2:end)'];
                    centroidRef = mean(vertV1XY);
                    tableVerticesSelectedCell = tableVertices(ismember(tableVertices.CellIDs,cellIdsSelectedV1(nCell)),:);
                else
                    totalCells = unique(tableVertices.CellIDs)';
                    centroidsV = zeros(length(totalCells),2);
                    for n=1:length(totalCells)
                        tableVerticesSelectedCell = tableVertices(ismember(tableVertices.CellIDs,totalCells(n)),:);
                        tableVerticesSelectedCell(ismember(tableVerticesSelectedCell.BorderCell,2),:) = [];
                        sr1Id = ismember(tableVerticesSelectedCell.Radius,1);
                        tableCell = tableVerticesSelectedCell(sr1Id,:);
                        verticesCell = table2array(tableCell(1,5:end));
                        verticesCell = verticesCell(~isnan(verticesCell))*resizeFactor;
                        vertXY = [verticesCell(1:2:end)',verticesCell(2:2:end)'];
                        centroidsV(n,:) = mean(vertXY);
                    end
                    k = dsearchn(centroidsV,centroidRef);
                    centroidRef = centroidsV(k,:);
                    tableVerticesSelectedCell = tableVertices(ismember(tableVertices.CellIDs,totalCells(k)),:);
                end
                
                
                
                if any(ismember(tableVerticesSelectedCell.BorderCell,2))
                    disp([num2str(cellIdsSelectedV1(nCell)) ' is border a cell in V' num2str(nVor) ' realization ' num2str(nRea)])
                else
                    tableVerticesSelectedCell(ismember(tableVerticesSelectedCell.BorderCell,2),:) = [];
                    surfRatios = 1:0.25:nSr;
                    srOfInterest = ismember(tableVerticesSelectedCell.Radius,surfRatios);
                    tableVerticesSelectedCell = tableVerticesSelectedCell(srOfInterest,:);

                    %% Cylinder seeds position: x=R*cos(angle); y=R*sin(angle);    
                    vertPositionsX = cell(length(surfRatios),1);
                    vertPositionsY = cell(length(surfRatios),1);
                    vertPositionsZ = cell(length(surfRatios),1);
                    R_basal = R_apical*nSr;
                    for sr = 1 : length(surfRatios)
                        verticesCell = table2array(tableVerticesSelectedCell(sr,5:end));
                        verticesCell = verticesCell(~isnan(verticesCell))*resizeFactor;

                        %pixels relocation from cylinder angle
                        angleOfVertLocation=(360/(wImgApical*surfRatios(sr)))*verticesCell(2:2:end);
                        R_sr = R_apical*surfRatios(sr);
                        vertPositionsX{sr} = ceil(R_sr*cosd(angleOfVertLocation)+(R_basal));
                        vertPositionsY{sr} = ceil(R_sr*sind(angleOfVertLocation)+(R_basal));
                        vertPositionsZ{sr} = round(verticesCell(1:2:end));
                        indexes = sub2ind(size(maskTube3D),[vertPositionsX{sr}],[vertPositionsY{sr}],[vertPositionsZ{sr}]);
                        maskTube3D(indexes)=1;
                    end
    %                 [row,col,z]=ind2sub(size(maskTube3D),find(maskTube3D));
    %                 alpShape1 = alphaShape(row,col,z);
    %                 alpShape.Alpha=5000;

                    %%extra vertices
                    vertPositionsX{sr+1} = ceil(R_sr*1.25*cosd(angleOfVertLocation)+(R_basal));
                    vertPositionsY{sr+1} = ceil(R_sr*1.25*sind(angleOfVertLocation)+(R_basal));
                    vertPositionsZ{sr+1} = vertPositionsZ{sr};
    %                 
                    alpShape2 = alphaShape(horzcat(vertPositionsX{:})',horzcat(vertPositionsY{:})',horzcat(vertPositionsZ{:})');
                    alpShape2.Alpha=5000;

                    boundingBoxCell = regionprops3(double(maskTube3D),'BoundingBox');
                    boundCoord = round(boundingBoxCell.BoundingBox);

                    subBox = false(size(maskTube3D));
                    subBox(:,:,boundCoord(3):(boundCoord(3)+boundCoord(6))) = 1;
                    boxIds = find(subBox==1);
                    [rowBox,colBox,zBox]=ind2sub(size(maskTube3D),boxIds);

                    voxList=[rowBox,colBox,zBox];
                    novalidVoxels = ismember([colBox,rowBox],[col2DInvalid,row2DInvalid],'rows');
                    voxList(novalidVoxels,:)=[];
                    in = inShape(alpShape2,voxList(:,1),voxList(:,2),voxList(:,3));
                    voxIn = voxList(in,:);

                    idCel = sub2ind(size(maskTube3D),voxIn(:,1),voxIn(:,2),voxIn(:,3));
                    maskCell3D(idCel)=1;

%                     [row,col,z]=ind2sub(size(maskCell3D),find(bwperim(maskCell3D)));
                    [row,col,z]=ind2sub(size(maskCell3D),find(maskCell3D));

                    shp=alphaShape([row,col,z],5);
                    [F,V]=shp.boundaryFacets;
                     
                    stlwrite(fullfile(path2save,['V' num2str(nVor) '_realization' num2str(nRea) '_cell' num2str(cellIdsSelectedV1(nCell)) '_sr' num2str(nSr) '_resizeFactor' num2str(resizeFactor) '.stl']),F,V)               

    %                 k = boundary(horzcat(vertPositionsX{:})',horzcat(vertPositionsY{:})',horzcat(vertPositionsZ{:})');
    %                 hold on
    %                 trisurf(k,horzcat(vertPositionsX{:})',horzcat(vertPositionsY{:})',horzcat(vertPositionsZ{:})','Facecolor','red','FaceAlpha',0.1)

                end
            end


        end
    end
end