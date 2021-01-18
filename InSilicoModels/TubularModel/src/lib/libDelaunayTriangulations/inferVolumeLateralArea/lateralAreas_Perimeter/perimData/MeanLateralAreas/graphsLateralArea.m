clear all
[totalMeansMean,totalStdsMean,totalMeansStd,totalStdsStd] = getMeans;

sr = 1:0.5:10;

xvalues = strsplit(num2str(sr));
yvalues = {'V1','V2','V3','V4','V5',...
    'V6','V7','V8','V9','V10'};

cmap = hot;
cmap = cmap(end:-1:1,:);

% %% HeatMap 1 -STD
% close all
% h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
% 
% 
% heatmap(xvalues,yvalues,totalMeansStd(:,1:2:end)./totalMeansMean(1,end),'CellLabelColor','none');
% 
% title('standard deviation lateral area');
% xlabel('surface ratio');
% ylabel('Voronoi type');
% colormap(cmap);
% 
% set(gca,'FontSize', 24,'FontName','Helvetica');
% 
% print(h,['heatMap_averageStdLateralArea_' date '.tif'],'-dtiff','-r300')
% savefig(h,['heatMap_averageStdLateral_' date  '.fig'])
% 
% 
% 
% %% HeatMap 2 - MEAN
% close all
% h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
% 
% 
% heatmap(xvalues,yvalues,totalMeansMean(:,1:2:end)./totalMeansMean(1,end),'CellLabelColor','none');
% 
% title('average lateral area');
% xlabel('surface ratio');
% ylabel('Voronoi type');
% colormap(cmap);
% 
% set(gca,'FontSize', 24,'FontName','Helvetica');
% 
% print(h,['heatMap_averageMeansLateralArea_' date '.tif'],'-dtiff','-r300')
% savefig(h,['heatMap_averageMeansLateralArea_' date  '.fig'])
% 
% close all

% %% Plot 1 -Means
% close all
% h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
% hold on
% sr = 1:0.25:10;
% for nVor = 1:10
%     switch nVor
%         case 1
%             colorPlot = [230/255,230/255,230/255];
%         case 2
%             colorPlot = [200/255,200/255,200/255];
%         case 3
%             colorPlot = [180/255,180/255,180/255];
%         case 4
%             colorPlot = [150/255,150/255,150/255];
%         case 5
%             colorPlot = [120/255,120/255,120/255];
%         case 6
%             colorPlot = [100/255,100/255,100/255];
%         case 7
%             colorPlot = [75/255,75/255,75/255];
%         case 8
%             colorPlot = [50/255,50/255,50/255];
%         case 9
%             colorPlot = [25/255,25/255,25/255];
%         case 10
%             colorPlot = [0/255,0/255,0/255];
%         case 0 %% Gland
%             colorPlot = [151 238 152]/255;
%     end
%     
%     plot(sr,totalMeansMean(nVor,:)./totalMeansMean(1,end),'LineWidth',2,'Color',colorPlot)
% %     errorbar(sr,totalMeansMean(nVor,:)./totalMeansMean(1,end),totalStdsMean(nVor,:)./totalMeansMean(1,end),'o','MarkerSize',5,...
% %             'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
% 
% end
% title('average lateral surface area');
% xlabel('surface ratio')
% ylabel('lateral surface area')
% xticks(1:0.5:10) 
% set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
% 
% legend({'V1','V2','V3','V4','V5','V6','V7','V8','V9','V10'})
% 
% print(h,['plot_averageLateralArea_' date '.tif'],'-dtiff','-r300')
% savefig(h,['plot_averageLateralArea_' date '.fig'])

%% Plot 2 - Fluctuations
close all
h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
hold on
sr = 1:0.25:10;
for nVor = 1:10
    switch nVor
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
        case 0 %% Gland
            colorPlot = [151 238 152]/255;
    end
    
    %plot(sr,totalMeansStd(nVor,:)./totalMeansMean(1,end),'LineWidth',2,'Color',colorPlot)
    errorbar(sr,totalMeansStd(nVor,:)./totalMeansMean(1,end),totalStdsStd(nVor,:)./totalMeansMean(1,end),'o','MarkerSize',5,...
            'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)

end
title('fluctuations lateral surface area');
xlabel('surface ratio')
ylabel('lateral surface area')
xticks(1:0.5:10) 
set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');

legend({'V1','V2','V3','V4','V5','V6','V7','V8','V9','V10'})

print(h,['plot_ErrorBar_FluctuationsLateralArea_' date '.tif'],'-dtiff','-r300')
savefig(h,['plot_ErrorBar_FluctuationsLateralArea_' date '.fig'])
