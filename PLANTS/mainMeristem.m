clear
close all
names={'katanin meristem A','katanin meristem B','SAM kt1 Rep 1','SAM kt1 Rep 2',...
    'SAM kt1 Rep 3','SAM kt1 Rep 4','SAM R1','SAM R2','SAM R3','SAM R4','WT meristem A','WT meristem'};

pixelWidth = [0.4,0.4,0.4,0.4,0.36,0.3276,0.4805,0.4805,0.424,0.4505,0.4805,0.4805];
voxelDepth = 0.5;
zScaleFactorHyp = voxelDepth./pixelWidth;

addpath(genpath('src'))

orderVault = {'zInvert','zInvert','zInvert','zInvert','zInvert','zInvert','','','','','','','','','',''};

folder = 'data/Meristem/';

for nNam=1:length(names)

    %%This complex process is only for detecting the cells belonging to each surface
    [projectedImages,setOfCellsLayer1,setOfCellsLayer2] = getMeristemPerSurfaces(folder,names{nNam},zScaleFactorHyp(nNam),orderVault{nNam});
   
    if ~exist([folder names{nNam} '/imagesOfLayers/layersClean.mat'],'file')
        [finalImages,~,~,finalCellsLayer1,finalCellsLayer2,noValidCellsLayer1,noValidCellsLayer2]=cleanUnrolledImages([folder names{nNam} '/'], projectedImages);
        save([folder names{nNam} '/imagesOfLayers/layersClean.mat'],'finalImages','finalCellsLayer1','finalCellsLayer2','noValidCellsLayer1','noValidCellsLayer2')
    end
    %%We get the cell properties
%     getGeometricalFeaturesFrom2DImages([folder names{nNam} '/resultMeasurements/layer1'],finalImages(1:2),noValidCellsLayer1)      
%     getGeometricalFeaturesFrom2DImages([folder names{nNam} '/resultMeasurements/layer2'],finalImages(3:4),noValidCellsLayer2)
% 
%     disp(names{nNam})
%     checkRealScutoidsPresence([folder names{nNam}])
%     
end

% system('rm -r data/Hypocotyl/*/resultMeasurements/')
% system('rm -r data/Hypocotyl/*/imagesOfLayers/')
% system('rm -r data/Hypocotyl/*/maskLayers/')