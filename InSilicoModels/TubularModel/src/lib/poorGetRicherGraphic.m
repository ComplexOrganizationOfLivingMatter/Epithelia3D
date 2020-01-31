
matrixMeanHM15_cut = matrixMeanHM15([1,5,10],:);
matrixMeanHM2_cut = matrixMeanHM2([1,5,10],:);
matrixMeanHM5_cut = matrixMeanHM5([1,5,10],:);


Mhm = [matrixMeanHM15_cut(1,:);matrixMeanHM15_cut(2,:);matrixMeanHM15_cut(3,:);
    matrixMeanHM2_cut(1,:);matrixMeanHM2_cut(2,:);matrixMeanHM2_cut(3,:);
	matrixMeanHM5_cut(1,:);matrixMeanHM5_cut(2,:);matrixMeanHM5_cut(3,:);];

cmap = pink;
cmap = cmap(end:-1:1,:);

yvaluesAux={'V1 s1.5','V5 s1.5','V10 s1.5','V1 s2','V5 s2','V10 s2','V1 s5', 'V5 s5', 'V10 s5'};
xvalues = [4 5 6 7 8];

h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');

heatmap(xvalues,yvaluesAux,Mhm,'CellLabelColor','none');

set(gca,'FontSize', 24,'FontName','Helvetica');

title(['Average 3D neighbours - gaining']);
xlabel('number of sides cell-group');
ylabel('Voronoi type');
colormap(cmap);
print(h,['heatMapPoorGetRicher_reduced_noText_' date '.tif'],'-dtiff','-r300')
savefig(h,['heatMapPoorGetRicher_reduced_noText_' date '.fig'])


matrixMeanHM15_cut = matrixMeanHM15_cut-min(matrixMeanHM15_cut(:));
matrixMeanHM15_cut = matrixMeanHM15_cut./max(matrixMeanHM15_cut(:));

matrixMeanHM2_cut = matrixMeanHM2_cut-min(matrixMeanHM2_cut(:));
matrixMeanHM2_cut = matrixMeanHM2_cut./max(matrixMeanHM2_cut(:));

matrixMeanHM5_cut = matrixMeanHM5_cut-min(matrixMeanHM5_cut(:));
matrixMeanHM5_cut = matrixMeanHM5_cut./max(matrixMeanHM5_cut(:));

MhmNormalized = [matrixMeanHM15_cut(1,:);matrixMeanHM15_cut(2,:);matrixMeanHM15_cut(3,:);
    matrixMeanHM2_cut(1,:);matrixMeanHM2_cut(2,:);matrixMeanHM2_cut(3,:);
	matrixMeanHM5_cut(1,:);matrixMeanHM5_cut(2,:);matrixMeanHM5_cut(3,:);];
h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');

heatmap(xvalues,yvaluesAux,MhmNormalized,'CellLabelColor','none');

title(['Average 3D neighbours - gaining (normalized)']);
xlabel('number of sides cell-group');
ylabel('Voronoi type');
colormap(cmap);

set(gca,'FontSize', 24,'FontName','Helvetica');
print(h,['heatMapPoorGetRicher_reduced_Normalized_noText_' date '.tif'],'-dtiff','-r300')
savefig(h,['heatMapPoorGetRicher_reduced_Normalized_noText_' date '.fig'])