clear all


meanLateralArea = [0	1820.224188	4045.723433	6524.923013	9286.836582	12284.01086	15426.7709];
varianceVolume = [0	10674789.26	45167145.07	113427003.5	229957230.9	412181536.3	723925887.4];
meanVolume = [0	13827.07972	31161.86169	53129.3643	80028.22813	111676.6693	149405.3066];
varianceVolumeNormalized=(sqrt(varianceVolume)/meanVolume(end)).^2;
sr = [1	 1.42 	 1.83 	 2.25 	 2.67 	 3.08 	3.5];

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

print(h,['heatMap_averageLateralArea_Gland_' date '.tif'],'-dtiff','-r300')
savefig(h,['heatMap_averageLateral_Gland_' date  '.fig'])

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

print(h2,['heatMap_varianceVolume_Gland_' date '.tif'],'-dtiff','-r300')
savefig(h2,['heatMap_varianceVolume_Gland_' date  '.fig'])