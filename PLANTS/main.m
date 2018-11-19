clear
close all
names={'Hypocotyl A','Hypocotyl B','test','ara_cdka1_1','ara_col_1','ara_col_2',...
    'ara_col_3','ara_cvi_1','ara_cvi_2','ara_cvi_3','ara_ler_1','ara_ler_2','ara_ler_3',...
    'ara_monopteros_1','ara_monopteros_2','ara_monopteros_3','cdka1_2','cdka1_3',...
    'foxglove_1','foxglove_3','poppy_1','poppy_2','poppy_3'};

zScaleFactorHyp = [0.4, 0.7, 0.7, 0.6, 0.4, 0.4,...
    0.7, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,...
    0.7, 0.7, 0.7, 0.6,...
    0.6, 0.4, 0.4, 0.5, 0.5];

addpath(genpath('src'))

rangeYPlant = {[700,1400],[700,1400],[500,1500]};
folder = 'data/Hypocotyl/';
for nNam=3%length(names)
    resizeFactor=0.3;
    rangeY=rangeYPlant{nNam};

    %% This complex process is only for detecting the cells belonging to each surface
    if ~exist([folder names{nNam} '/unrolledHypocotyl.mat'],'file')
        [layer1,layer2,setOfCells]=getCylindricalSurfaces(folder,names{nNam},rangeY,zScaleFactorHyp(nNam));      
        [unrolledImages] = unrollingHypocot(folder, names{nNam},rangeY,layer1,layer2);
        [~,cellsLayer1,cellsLayer2,~,~,~,~]=cleanAndGetMeasurements([folder names{nNam} '/'], unrolledImages);
        save([folder names{nNam} '/unrolledHypocotyl.mat'],'unrolledImages','cellsLayer1','cellsLayer2')
    else
        load([folder names{nNam} '/unrolledHypocotyl.mat'],'unrolledImages','cellsLayer1','cellsLayer2')
    end

    %% Once we have the layer' cells, it is possible get the unrolled Hypocotyl using normal vector extrapolations
    if ~exist([folder names{nNam} '/imagesOfLayers/layersClean.mat'],'file')
%             function that fill the Hyp perimeter using the vector imaginary with the centroid
        [layer1_3D,layer2_3D]=assingCells2maskPerim(folder, names{nNam},rangeY,cellsLayer1,cellsLayer2);
        [unrolledImagesQuasiClean] = unrollingHypocot(folder, names{nNam},rangeY,layer1_3D,layer2_3D);
        save([folder names{nNam} '/imagesOfLayers/layersClean.mat'],'layer1_3D','layer2_3D','unrolledImagesQuasiClean')

        [finalImages,~,~,finalCellsLayer1,finalCellsLayer2,noValidCellsLayer1,noValidCellsLayer2]=cleanUnrolledImages(['data/' names{nNam} '/'], unrolledImagesQuasiClean);
        save([folder names{nNam} '/imagesOfLayers/layersClean.mat'],'finalImages','finalCellsLayer1','finalCellsLayer2','noValidCellsLayer1','noValidCellsLayer2','-append')
    else
        load([folder names{nNam} '/imagesOfLayers/layersClean.mat'],'finalImages','finalCellsLayer1','finalCellsLayer2','noValidCellsLayer1','noValidCellsLayer2','layer1_3D','layer2_3D','unrolledImagesQuasiClean')
    end

    %% We get the cell properties
    getGeometricalFeaturesFrom2DImages([folder names{nNam} '/resultMeasurements/layer1'],finalImages(1:2),noValidCellsLayer1)      
    getGeometricalFeaturesFrom2DImages([folder names{nNam} '/resultMeasurements/layer2'],finalImages(3:4),noValidCellsLayer2)

end

% names={''};
% 
% for nNam=1 : length(names)
%         [layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface,setOfCells.Layer1,setOfCells.Layer2]=getMeristemPerSurfaces(names{nNam});        
% end