clear
close all
names={'Hypocotyl A','Hypocotyl B','test','ara_cdka1_1','ara_col_1','ara_col_2',...
    'ara_col_3','ara_cvi_1','ara_cvi_2','ara_cvi_3','ara_ler_1','ara_ler_2','ara_ler_3',...
    'ara_monopteros_1','ara_monopteros_2','ara_monopteros_3','cdka1_2','cdka1_3',...
    'foxglove_1','foxglove_3','poppy_1','poppy_2','poppy_3'};

pixelWidth = 0.2767553;
voxelDepth= [0.4, 0.7, 0.7, 0.6, 0.4, 0.4,...
    0.7, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,...
    0.7, 0.7, 0.7, 0.6,...
    0.6, 0.4, 0.4, 0.5, 0.5, 0.5];
zScaleFactorHyp = voxelDepth./pixelWidth;

addpath(genpath('src'))

rangeMajorAxisPlant = {[700,1400],[700,1400],[500,1500],[500,1300],[600,1300],[400,1100],...
    [600,1350],[500,1400],[600,1600],[600,1600],[600,1300],[500,1200],[500,1200],...
    [400, 1000],[200,800], [0,0], [600,1400],...
    [600,1500],[200,900], [200,1100], [500,1000],[500,1100],[500,1100]};
folder = 'data/Hypocotyl/';

for nNam=[1:15,17:length(names)]
    rangeMajorAxis=rangeMajorAxisPlant{nNam};

    %%This complex process is only for detecting the cells belonging to each surface
    [setOfCells]=getCylindricalSurfaces(folder,names{nNam},rangeMajorAxis,zScaleFactorHyp(nNam));      

    %%Once we have the layer' cells, it is possible get the unrolled Hypocotyl using normal vector extrapolations
    %function that fill the Hyp perimeter using the vector imaginary with the centroid
    if exist([folder names{nNam} '/imagesOfLayers/layersClean.mat'],'file')
        load([folder names{nNam} '/imagesOfLayers/layersClean.mat'])
        if ~exist('unrolledImagesQuasiClean','var')
            [unrolledImagesQuasiClean] = unrollingHypocot(folder, names{nNam},rangeMajorAxis,layer1_3D,layer2_3D);
            save([folder names{nNam} '/imagesOfLayers/layersClean.mat'],'unrolledImagesQuasiClean','-append')
        end
    else
        [layer1_3D,layer2_3D]=assingCells2maskPerim(folder, names{nNam},rangeMajorAxis,setOfCells.Layer1,setOfCells.Layer2);
        mkdir([folder names{nNam} '/imagesOfLayers/'])
        save([folder names{nNam} '/imagesOfLayers/layersClean.mat'],'layer1_3D','layer2_3D','-v7.3')
        [unrolledImagesQuasiClean] = unrollingHypocot(folder, names{nNam},rangeMajorAxis,layer1_3D,layer2_3D);
        save([folder names{nNam} '/imagesOfLayers/layersClean.mat'],'unrolledImagesQuasiClean','-append')
    end
    [finalImages,~,~,finalCellsLayer1,finalCellsLayer2,noValidCellsLayer1,noValidCellsLayer2]=cleanUnrolledImages([folder names{nNam} '/'], unrolledImagesQuasiClean);
    save([folder names{nNam} '/imagesOfLayers/layersClean.mat'],'finalImages','finalCellsLayer1','finalCellsLayer2','noValidCellsLayer1','noValidCellsLayer2','-append')

    %%We get the cell properties
    getGeometricalFeaturesFrom2DImages([folder names{nNam} '/resultMeasurements/layer1'],finalImages(1:2),noValidCellsLayer1)      
    getGeometricalFeaturesFrom2DImages([folder names{nNam} '/resultMeasurements/layer2'],finalImages(3:4),noValidCellsLayer2)

    disp(names{nNam})
    checkRealScutoidsPresence([folder names{nNam}])
    
end

% system('rm -r data/Hypocotyl/*/resultMeasurements/')
% system('rm -r data/Hypocotyl/*/imagesOfLayers/')
% system('rm -r data/Hypocotyl/*/maskLayers/')