nameSurfaces = {'apicalToBasal', 'basalToApical'};
path2load = '..\Results\geometryMeasurementsVoronoiTubes\volumes\';

for kindSr = 1:2

    sr = 1:0.5:10;
    
    vor1Volume = table2array(readtable([path2load 'volumes_Voronoi_1_' nameSurfaces{kindSr} '.xls']));
    vor2Volume = table2array(readtable([path2load 'volumes_Voronoi_2_' nameSurfaces{kindSr} '.xls']));
    vor3Volume = table2array(readtable([path2load 'volumes_Voronoi_3_' nameSurfaces{kindSr} '.xls']));
    vor4Volume = table2array(readtable([path2load 'volumes_Voronoi_4_' nameSurfaces{kindSr} '.xls']));
    vor5Volume = table2array(readtable([path2load 'volumes_Voronoi_5_' nameSurfaces{kindSr} '.xls']));
    vor6Volume = table2array(readtable([path2load 'volumes_Voronoi_6_' nameSurfaces{kindSr} '.xls']));
    vor7Volume = table2array(readtable([path2load 'volumes_Voronoi_7_' nameSurfaces{kindSr} '.xls']));
    vor8Volume = table2array(readtable([path2load 'volumes_Voronoi_8_' nameSurfaces{kindSr} '.xls']));
    vor9Volume =  table2array(readtable([path2load 'volumes_Voronoi_9_' nameSurfaces{kindSr} '.xls']));
    vor10Volume =  table2array(readtable([path2load 'volumes_Voronoi_10_' nameSurfaces{kindSr} '.xls']));
    
    %%normalization using average total volume (sr10) of Voronoi 1
    valueToNormalize = mean(vor1Volume(1:2:end,:));
    valueToNormalize = valueToNormalize(end);
    
    meanVarianceVolumeVor1 = mean((vor1Volume(2:2:end,:)./valueToNormalize).^2);
    meanVarianceVolumeVor2 = mean((vor2Volume(2:2:end,:)./valueToNormalize).^2);
    meanVarianceVolumeVor3 = mean((vor3Volume(2:2:end,:)./valueToNormalize).^2);
    meanVarianceVolumeVor4 = mean((vor4Volume(2:2:end,:)./valueToNormalize).^2);
    meanVarianceVolumeVor5 = mean((vor5Volume(2:2:end,:)./valueToNormalize).^2);
    meanVarianceVolumeVor6 = mean((vor6Volume(2:2:end,:)./valueToNormalize).^2);
    meanVarianceVolumeVor7 = mean((vor7Volume(2:2:end,:)./valueToNormalize).^2);
    meanVarianceVolumeVor8 = mean((vor8Volume(2:2:end,:)./valueToNormalize).^2);
    meanVarianceVolumeVor9 = mean((vor9Volume(2:2:end,:)./valueToNormalize).^2);
    meanVarianceVolumeVor10 = mean((vor10Volume(2:2:end,:)./valueToNormalize).^2);

    meanVariancesVolume = [meanVarianceVolumeVor1;meanVarianceVolumeVor2;meanVarianceVolumeVor3;meanVarianceVolumeVor4;meanVarianceVolumeVor5;...
        meanVarianceVolumeVor6;meanVarianceVolumeVor7;meanVarianceVolumeVor8;meanVarianceVolumeVor9;meanVarianceVolumeVor10];

    xvalues = strsplit(num2str(sr));
    yvalues = {'V1','V2','V3','V4','V5',...
        'V6','V7','V8','V9','V10'};

    cmap = hot;
    cmap = cmap(end:-1:1,:);

    %% HeatMap Apico-Basal transitions VS Voronoi type VS Surface ratio
    close all
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');


    heatmap(xvalues,yvalues,meanVariancesVolume(:,1:2:end),'CellLabelColor','none');


    title('variance volume');
    xlabel('surface ratio');
    ylabel('Voronoi type');
    colormap(cmap);

    set(gca,'FontSize', 24,'FontName','Helvetica');

    print(h,['heatMap_averageVarianceVolume_'  nameSurfaces{kindSr} '_' date '.tif'],'-dtiff','-r300')
    savefig(h,['heatMap_averageVarianceVolume_' nameSurfaces{kindSr} '_' date  '.fig'])
    
end



