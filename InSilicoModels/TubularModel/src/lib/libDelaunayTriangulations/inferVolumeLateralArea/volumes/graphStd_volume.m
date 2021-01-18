
sr = 1:0.5:10;
meanVarianceVolumeVor1 = mean(vor1Volume(2:2:end,:).^2);
meanVarianceVolumeVor2 = mean(vor2Volume(2:2:end,:).^2);
meanVarianceVolumeVor3 = mean(vor3Volume(2:2:end,:).^2);
meanVarianceVolumeVor4 = mean(vor4Volume(2:2:end,:).^2);
meanVarianceVolumeVor5 = mean(vor5Volume(2:2:end,:).^2);
meanVarianceVolumeVor6 = mean(vor6Volume(2:2:end,:).^2);
meanVarianceVolumeVor7 = mean(vor7Volume(2:2:end,:).^2);
meanVarianceVolumeVor8 = mean(vor8Volume(2:2:end,:).^2);
meanVarianceVolumeVor9 = mean(vor9Volume(2:2:end,:).^2);
meanVarianceVolumeVor10 = mean(vor10Volume(2:2:end,:).^2);

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

print(h,['heatMap_averageVarianceVolume_' date '.tif'],'-dtiff','-r300')
savefig(h,['heatMap_averageVarianceVolume_' date  '.fig'])


% %%normalize data between sr 1.75
% vor10VolumeNorm = vor10Volume(:,1:4);
% for i = 1:size(vor10Volume,1)
%     if mod(i,2)~=0
%         vor10VolumeNorm(i:i+1,:)= vor10VolumeNorm(i:i+1,:)/vor10Volume(i,4);
%     end
% end



