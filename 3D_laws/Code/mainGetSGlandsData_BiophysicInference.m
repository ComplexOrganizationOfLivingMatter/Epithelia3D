clear all
close all
%1. Load final segmented glands
pathKindPhenotype = uigetdir(fullfile('E:','Pedro','SalivaryGlands','data'));

pathGlands = dir(fullfile(pathKindPhenotype,'**','layersTissue.mat'));

pathSectionsSRs = dir(fullfile(pathGlands(1).folder,'dividedGlandBySr','*mat'));
nSRsteps = size(pathSectionsSRs,1);

maxSR = 1+0.5*nSRsteps;
sr = 1:0.5:maxSR;

nOfSrs = length(sr);

%Init arrays to store data

tableAveragePerim=zeros(size(pathGlands,1),nOfSrs);
tableStdPerim=zeros(size(pathGlands,1),nOfSrs);
tableVarPerim=zeros(size(pathGlands,1),nOfSrs);
tableAveragePerim2=zeros(size(pathGlands,1),nOfSrs);
tableStdPerim2=zeros(size(pathGlands,1),nOfSrs);
tableVarPerim2=zeros(size(pathGlands,1),nOfSrs);

tableAverageLateralArea = zeros(size(pathGlands,1),nOfSrs);
tableStdLateralArea = zeros(size(pathGlands,1),nOfSrs);
tableVarLateralArea = zeros(size(pathGlands,1),nOfSrs);

tableAverageVolume = zeros(size(pathGlands,1),nOfSrs);
tableStdVolume = zeros(size(pathGlands,1),nOfSrs);
tableVarVolume = zeros(size(pathGlands,1),nOfSrs);

tableMeanIntercalations = zeros(size(pathGlands,1),nOfSrs);

%%get kind of gland
[~,kindGland,~] = fileparts(pathKindPhenotype);


% parpool(10)

parfor nGland = 1:size(pathGlands,1) 
    try
        for nSr = 1:nOfSrs 

            if nSr==1

                imgs = load(fullfile(pathGlands(nGland).folder,pathGlands(nGland).name),'apicalLayer','lumenImage','lateralLayer','basalLayer');
                apicalLayer = imgs.apicalLayer; lumenImage = imgs.lumenImage; lateralLayer=imgs.lateralLayer;basalLayer=imgs.basalLayer;

                validCells = load(fullfile(pathGlands(nGland).folder,'valid_cells.mat'),'validCells');
                validCells = validCells.validCells;

                pxScale = load(fullfile(pathGlands(nGland).folder,'pixelScaleOfGland.mat'),'pixelScale');
                pixelScale = pxScale.pixelScale;

                %% Get perimeters: <perim^2> and std(perim^2); perim> and std(perim)
                perimImage=imdilate(lateralLayer>0,strel('sphere',1));

                lateralLayerTips=imdilate(lateralLayer>0,strel('sphere',1)) & (apicalLayer>0 | basalLayer>0);


                perimImageTotal=apicalLayer;
                perimImageTotal((lateralLayer>0 | lateralLayerTips>0)==0)=0;

                for nCell = unique(perimImageTotal(perimImageTotal>0))'
                    cellSkel = bwskel(perimImageTotal==nCell);
                    perimImageTotal(perimImageTotal==nCell)=0;
                    perimImageTotal(cellSkel)=nCell;
                end

                vPerim=regionprops3(perimImageTotal,'Volume');
                perimValidCells=vPerim.Volume(validCells).*pixelScale;   


                %% Get volume -> <volume> and variance(volume)
                meanVolume = 0;
                stdVolume=0;
                varVolume=0;

                %% Get Lateral area -> <lateral area> and std(lateral area)
                meanLateralArea=0;
                stdLateralArea=0;
                varLateralArea=0;

                %% Get average intercalations
                meanIntercalations = 0;


            else
                features = load(fullfile(pathGlands(nGland).folder,'dividedGlandBySr',['Features_vx4_0.1_sr' num2str(sr(nSr))],'morphological3dFeatures.mat'),'cellularFeaturesValidCells');
                cellularFeaturesValidCells = features.cellularFeaturesValidCells;
                %load interpolated image
                img = load(fullfile(pathGlands(nGland).folder,'dividedGlandBySr',['sr_' num2str(sr(nSr)) '.mat']),'interpImageCells');
                interpImageCells = img.interpImageCells;

                %get basal Layer
                glandFilled = imfill(interpImageCells>0 | lumenImage>0,'holes');
                perimCystFilled = bwperim(glandFilled);
                outerLayer = zeros(size(interpImageCells));
                outerLayer(perimCystFilled) = interpImageCells(perimCystFilled);

                %% Get perimeters from basal layer: <perim^2> and std(perim^2); <perim> and std(perim)
                perimImageTotal=outerLayer;
                perimImageTotal((lateralLayer>0 | lateralLayerTips>0)==0)=0;

                for nCell = unique(perimImageTotal(perimImageTotal>0))'
                    cellSkel = bwskel(perimImageTotal==nCell);
                    perimImageTotal(perimImageTotal==nCell)=0;
                    perimImageTotal(cellSkel)=nCell;
                end

                vPerim=regionprops3(perimImageTotal,'Volume');
                perimValidCells=vPerim.Volume(validCells).*pixelScale; 


                %% Get volume -> <volume> and variance(volume)
                meanVolume = mean(cellularFeaturesValidCells.Volume);
                stdVolume = std(cellularFeaturesValidCells.Volume);
                varVolume = var(cellularFeaturesValidCells.Volume);

                %% Get Lateral area -> <lateral area> and std(lateral area)
                meanLateralArea = mean(cellularFeaturesValidCells.Lateral_area);
                stdLateralArea = std(cellularFeaturesValidCells.Lateral_area);
                varLateralArea = var(cellularFeaturesValidCells.Lateral_area);

                %% Get average intercalations
                meanIntercalations = mean(cellularFeaturesValidCells.apicoBasalTransitions);
            end

            tableAveragePerim(nGland,nSr) =  mean(perimValidCells);
            tableStdPerim(nGland,nSr) =  std(perimValidCells);
            tableVarPerim(nGland,nSr) =  var(perimValidCells);
            tableAveragePerim2(nGland,nSr) =  mean(perimValidCells.^2);
            tableStdPerim2(nGland,nSr) =  std(perimValidCells.^2);
            tableVarPerim2(nGland,nSr) =  var(perimValidCells.^2);

            tableAverageLateralArea(nGland,nSr) = meanLateralArea;
            tableStdLateralArea(nGland,nSr) = stdLateralArea;
            tableVarLateralArea(nGland,nSr) = varLateralArea;

            tableAverageVolume(nGland,nSr) = meanVolume;
            tableStdVolume(nGland,nSr) = stdVolume;
            tableVarVolume(nGland,nSr) = varVolume;

            tableMeanIntercalations(nGland,nSr) = meanIntercalations;
        
            
        end
    catch
        disp(['error in gland ' num2str(nGland) ' - sr ' numstr(sr(nSr))])
    end
    
end
save(fullfile('..','salivaryGlandsData','geometryMeasurementsSalivaryGlands', [kindGland '_geometricParamsForBiophysicInference_' date '.mat']),'tableAveragePerim','tableStdPerim','tableVarPerim','tableAveragePerim2','tableStdPerim2','tableVarPerim2','tableAverageLateralArea','tableStdLateralArea','tableVarLateralArea','tableAverageVolume','tableStdVolume','tableVarVolume','tableMeanIntercalations')