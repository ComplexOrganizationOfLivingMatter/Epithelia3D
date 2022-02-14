clear all

path2save=fullfile('D:','Pedro','Epithelia3D','3D_laws','salivaryGlandsData','heatMaps','Ecadh RNAi');
mkdir(path2save)

%WT glands
% meanLateralArea = [0 2557.14 4586.22 6627.64 8735.81 10966.82 13305.14 15751.43 18331.99 21035.82 23795.96 26442.85];
% varianceVolume = [0 153986219.82 325523835.44 615625208.03 1059379722.69 1696708019.17 2543846589.68 3626137658.60 5002735926.79 6763769343.32 8930023543.02 11516764664.28];
% meanVolume = [0	 29483.87 56093.13 88333.26 126150.57 169930.17 219144.97 273797.61 334298.06 400964.44 472614.54 547817.76];
% meanIntercalations = [0 0.17 0.24 0.33 0.43 0.56 0.68 0.78 0.91 0.97 1.03 1.09];
% sr = [1:0.5:6.5];

%Ecadh RNAi flatten
meanLateralArea = [0, 2090.12, 3893.26, 5824.53, 7870.28, 10030.71, 12310.94, 14716.73, 17210.43, 19764.40];
varianceVolume = [0, 66132356.65, 161190258.49, 324834777.42, 569665580.85, 910229063.61, 1359973216.87, 1918030498.64, 2599986607.88, 3455272781.28];
meanVolume = [0, 22460.71, 43900.80, 70114.43, 100805.69, 136017.41, 175652.70, 220005.38, 268707.31, 321584.04];
meanIntercalations = [0, 0.08, 0.14, 0.21, 0.28, 0.40, 0.52, 0.65, 0.76, 0.88];
sr = [1:0.5:5.5];

varianceVolumeNormalized=(sqrt(varianceVolume)/meanVolume(end)).^2;

xvalues = strsplit(num2str(sr));
yvalues = {'S.Gland'};

cmap = hot;
cmap = cmap(end:-1:1,:);

%% HeatMap 1 - Lateral area
close all
h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
% h = figure;

heatmap(xvalues,yvalues,meanLateralArea./meanLateralArea(end),'CellLabelColor','none');

title('lateral area: surface-tension energy');
xlabel('surface ratio');
% ylabel('salivary gland');
colormap(cmap);

set(gca,'FontSize', 24,'FontName','Helvetica');
set(gca,'innerposition',[0.1,0.75,0.75,0.2]);

% print(h,fullfile(path2save,['heatMap_averageLateralArea_Gland_' date '.tif']),'-dtiff','-r300')
ax = gca;
exportgraphics(ax,fullfile(path2save,['heatMap_averageLateralArea_Gland_' date  '.png']),'Resolution',600)
savefig(h,fullfile(path2save,['heatMap_averageLateralArea_Gland_' date  '.fig']))

close all;

%% HeatMap 2 - Fluctuations Volume
h2 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
% h2 = figure;
heatmap(xvalues,yvalues,varianceVolumeNormalized,'CellLabelColor','none');

title('cellular size fluctuations: elastic energy');
xlabel('surface ratio');
% ylabel('salivary gland');
colormap(cmap);

set(gca,'FontSize', 24,'FontName','Helvetica');
set(gca,'innerposition',[0.1,0.75,0.75,0.2]);

ax = gca;
exportgraphics(ax,fullfile(path2save,['heatMap_varianceVolume_Gland_' date '.png']),'Resolution',600)
savefig(h2,fullfile(path2save,['heatMap_varianceVolume_Gland_' date  '.fig']))

close all;


%% HeatMap 3 - Intercalations
cmap = pink;
cmap = cmap(end:-1:1,:);

h3 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
% h2 = figure;
heatmap(xvalues,yvalues,meanIntercalations,'CellLabelColor','none');

title('intercalations');
xlabel('surface ratio');
% ylabel('salivary gland');
colormap(cmap);

set(gca,'FontSize', 24,'FontName','Helvetica');
set(gca,'innerposition',[0.1,0.75,0.75,0.2]);

ax = gca;
exportgraphics(ax,fullfile(path2save,['heatMap_intercalations_Gland_' date  '.png']),'Resolution',600)
savefig(h3,fullfile(path2save,['heatMap_intercalations_Gland_' date  '.fig']))

close all;
