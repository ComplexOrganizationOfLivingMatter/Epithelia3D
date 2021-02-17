clear all
close all

path2load= '..\DelaunayData\geometryMeasurementsVoronoiTubes\volumeAreaPerimIntercalations_VoronoiTubes_apicalToBasal\';
SRs = 2:1:10;
nRealizations =20;
h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
for voronoiNumber = 1:10
    
    switch voronoiNumber
        case 1
            colorPlot = [230/255,230/255,230/255];
        case 2
            colorPlot = [200/255,200/255,200/255];
        case 3
            colorPlot = [180/255,180/255,180/255];
        case 4
            colorPlot = [150/255,150/255,150/255];
        case 5
            colorPlot = [120/255,120/255,120/255];
        case 6
            colorPlot = [100/255,100/255,100/255];
        case 7
            colorPlot = [75/255,75/255,75/255];
        case 8
            colorPlot = [50/255,50/255,50/255];
        case 9
            colorPlot = [25/255,25/255,25/255];
        case 10
            colorPlot = [0/255,0/255,0/255];
    end
    
    lateralAreas = cell(1,length(SRs));
    nIntercations = cell(1,length(SRs));
    volumes = cell(1,length(SRs));

    for nSr = 1:length(SRs)

        tableData = readtable(fullfile(path2load,['V' num2str(voronoiNumber) '_s' num2str(SRs(nSr)) '_volumeAreaPerimIntercalation_04-Feb-2021.xls']));

        lateralAreas{nSr} = tableData.lateralArea(:);
        nIntercations{nSr} = tableData.nIntercalations(:);
        volumes{nSr} = tableData.volume(:);
    end
    
   %classify per realizations
   cellIds = tableData.id(:);
   idsPerRealization = cell(1,nRealizations);
   nRea=1;
   idsPerRealization{nRea}=1;
   for nIds = 2:length(cellIds)
       if cellIds(nIds)>cellIds(nIds-1) || abs(cellIds(nIds)-cellIds(nIds-1))<35
        idsPerRealization{nRea} = [idsPerRealization{nRea},nIds];
       else
        nRea = nRea+1;
        idsPerRealization{nRea} = [idsPerRealization{nRea},nIds];
       end
   end
    
   allLateralAreas = [zeros(length(lateralAreas{1,1}),1),horzcat(lateralAreas{:})];
   allVolumes2 = [zeros(length(volumes{1,1}),1),horzcat(volumes{:})].^2;
   allIntercalations = [zeros(length(lateralAreas{1,1}),1),horzcat(nIntercations{:})];
   
   meanCorrRea1 = cell(1,nRealizations);
   meanCorrRea2 = cell(1,nRealizations);
   
   meanCorrOfMeansRea1 = cell(1,nRealizations);
   meanCorrOfMeansRea2 = cell(1,nRealizations);
   for nRealization = 1:nRealizations
       lateralAreasRealization = allLateralAreas(idsPerRealization{nRealization},:);
       intercalationsRealization = allIntercalations(idsPerRealization{nRealization},:);
       volumes2Realization = allVolumes2(idsPerRealization{nRealization},:);
       
       %cross-correlation lateral Area (s) VS intercalations (s)
       c1=cell(size(lateralAreasRealization,1),1);
       c2=cell(size(lateralAreasRealization,1),1);
       for nCell=1:length(lateralAreasRealization)
            [c1{nCell},lags1]=xcorr(lateralAreasRealization(nCell,:),intercalationsRealization(nCell,:),'normalized');
            [c2{nCell},lags2]=xcorr(volumes2Realization(nCell,:),intercalationsRealization(nCell,:),'normalized');
       end
       meanCorrRea1{nRealization}= mean(vertcat(c1{:}));
       meanCorrRea2{nRealization}= mean(vertcat(c2{:}));
       
       %croos correlation of the means
        meanLatArea = mean(lateralAreasRealization);
        meanIntercalations = mean(intercalationsRealization);
        fluctuationsVolume = std(volumes2Realization).^2;
        [meanCorrOfMeansRea1{nRealization},lagsMean1]=xcorr(meanLatArea,meanIntercalations,'normalized');
        [meanCorrOfMeansRea2{nRealization},lagsMean2]=xcorr(fluctuationsVolume,meanIntercalations,'normalized');

       
   end
   averageCrossCorrelation1 = mean(vertcat(meanCorrRea1{:})); 
   stdCrossCorrelation1 = std(vertcat(meanCorrRea1{:})); 
   
%    plot(lags1,averageCrossCorrelation1,'LineWidth',1,'Color',colorPlot)
%    hold on
    
   averageCrossCorrelation2 = mean(vertcat(meanCorrRea2{:})); 
   stdCrossCorrelation2 = std(vertcat(meanCorrRea2{:})); 
%    plot(lags2,averageCrossCorrelation2,'LineWidth',1,'Color',colorPlot)
%    hold on

   averageOfMeanCrossCorrelation1=mean(vertcat(meanCorrOfMeansRea1{:})); 
   averageOfMeanCrossCorrelation2=mean(vertcat(meanCorrOfMeansRea2{:})); 
   
   plot(lagsMean1,averageOfMeanCrossCorrelation1,'LineWidth',1,'Color',colorPlot)
   hold on
end
hold off

ylim([0 1])

set(gca,'FontSize', 24,'FontName','Helvetica');

% title('cross-correlation lateral area - intercalations')
% legend({'V1','V2','V3','V4','V5','V6','V7','V8','V9','V10'})
% 
% print(h,fullfile(path2load,['cross_correlation_lateralArea_nIntercalations_' date '.tif']),'-dtiff','-r300')
% savefig(h,fullfile(path2load,['cross_correlation_lateralArea_nIntercalations_' date '.fig']))


% title('cross-correlation volume^2 - intercalations')
% legend({'V1','V2','V3','V4','V5','V6','V7','V8','V9','V10'})
% 
% print(h,fullfile(path2load,['cross_correlation_volume^2_nIntercalations_' date '.tif']),'-dtiff','-r300')
% savefig(h,fullfile(path2load,['cross_correlation_volume^2_nIntercalations_' date '.fig']))

title('cross-correlation variance volume (s) - <intercalations(s)>')
legend({'V1','V2','V3','V4','V5','V6','V7','V8','V9','V10'})

print(h,fullfile(path2load,['cross_correlation_meanLateralArea(s)_meanIntercalations(s)_' date '.tif']),'-dtiff','-r300')
savefig(h,fullfile(path2load,['cross_correlation_meanLateralArea(s)_meanIntercalations(s)_' date '.fig']))


