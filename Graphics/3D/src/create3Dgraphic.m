% uiopen('D:\Pedro\Epithelia3D\docs\salivaryGlands_embryo_cultEpithelia\length-apicalReduction-angle_salivaryGlandsWT.xlsx',1)

path2save='D:\Pedro\Epithelia3D\docs\salivaryGlands_embryo_cultEpithelia\3dComparisons(angle-length-apicalReduction)\';

tableInfo = lengthapicalReductionanglesalivaryGlandsWT;
% scatter3(tableInfo.angle, tableInfo.length, tableInfo.apicalSurfaceReduction);

h = figure;
colorTransition = [0,153,0]/255;
colorNoTransition = [255 51 51]/255;
indexes1=1-isnan(tableInfo.apicalSurfaceReduction);
scatter3(tableInfo.angle(1:sum(indexes1)), tableInfo.length(1:sum(indexes1)), tableInfo.apicalSurfaceReduction(1:sum(indexes1)),36,colorTransition,'filled');
hold on;
indexes2=1-isnan(tableInfo.apicalSurfaceReduction2);
scatter3(tableInfo.angle2(1:sum(indexes2)), tableInfo.length2(1:sum(indexes2)), tableInfo.apicalSurfaceReduction2(1:sum(indexes2)),36,colorNoTransition,'filled');
legend('WT Transition', 'WT No Transition');
xlabel('edge angle (degrees)');
ylabel('edge length (micrometers)');
zlabel('apical surface reduction');
savefig(h,[path2save 'angleLengthApicalSurface.fig']);
close all

figure
scatter(tableInfo.angle(1:sum(indexes1)),tableInfo.length(1:sum(indexes1)),36,colorTransition,'filled')
hold on
scatter(tableInfo.angle2(1:sum(indexes2)),tableInfo.length2(1:sum(indexes2)),36,colorNoTransition,'filled')
legend('WT Transition', 'WT No Transition');
xlabel('edge angle (degrees)');
ylabel('edge length (micrometers)');
saveas(gca,[path2save 'angle-length.tiff'])
close all

figure
scatter(tableInfo.angle(1:sum(indexes1)),tableInfo.apicalSurfaceReduction(1:sum(indexes1)),36,colorTransition,'filled')
hold on
scatter(tableInfo.angle2(1:sum(indexes2)),tableInfo.apicalSurfaceReduction2(1:sum(indexes2)),36,colorNoTransition,'filled')
legend('WT Transition', 'WT No Transition');
xlabel('edge angle (degrees)');
ylabel('apical surface reduction');
saveas(gca,[path2save 'angle-apicalSurfaceReduction.tiff'])
close all

figure
scatter(tableInfo.length(1:sum(indexes1)),tableInfo.apicalSurfaceReduction(1:sum(indexes1)),36,colorTransition,'filled')
hold on
scatter(tableInfo.length2(1:sum(indexes2)),tableInfo.apicalSurfaceReduction2(1:sum(indexes2)),36,colorNoTransition,'filled')
legend('WT Transition', 'WT No Transition');
xlabel('edge length (micrometers)');
ylabel('apical surface reduction');
saveas(gca,[path2save 'length-apicalSurfaceReduction.tiff'])
close all
