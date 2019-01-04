% clear all
% close all

sr = 1./(1:-0.1:0.1);
sr = unique([sr,4,6:9,11:15]);
voronoiDiagram = 1;

folderPath = 'D:\Pedro\Epithelia3D\InSilicoModels\TubularModel\data\tubularVoronoiModel\expansion\512x4096_200seeds\diagram';

file1 = 'polygonsDistributions\dataPolygonDistributionAndPercentageScutoids.mat';
file2 = 'VoronoiLewisEuler_redFactor_2\relationAreaVolumeSidesSurfaceRatio.mat';

load([folderPath num2str(voronoiDiagram) '\' file1])
load([folderPath num2str(voronoiDiagram) '\' file2])

% myfittypeLn=fittype('a +b*log(x)',...
% 'dependent', {'y'}, 'independent',{'x'},...
% 'coefficients', {'a','b'});

myfittypeLog10=fittype('a +b*log10(x)',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});


% myfittypeExp=fittype('a+x^b',...
% 'dependent', {'y'}, 'independent',{'x'},...
% 'coefficients', {'a','b'});
% 
% myfittypeSqrt=fittype('6+b*sqrt(x)',...
% 'dependent', {'y'}, 'independent',{'x'},...
% 'coefficients', {'b'});
% 
myfittypePowFit=fittype('a*x^b+c',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b', 'c'});

neighBasalAcum=cellfun(@(x) mean(x{:,:}),numNeighAccumPerSurfaces,'UniformOutput',false);

stdNeighBasalAcum = std(cat(1,neighBasalAcum{:,:}));
allNeighBasal3D = cat(1,neighBasalAcum{:,:});
meanNeighBasalAcum = mean(cat(1,neighBasalAcum{:,:}));

meanNeighBasalAcum = meanNeighBasalAcum(1:length(sr));
stdNeighBasalAcum = stdNeighBasalAcum(1:length(sr));

allPercentageScutoids = cell2mat(percentageScutoids);
meanPercScutoids = mean(cell2mat(percentageScutoids));
stdPercScutoids = std(cell2mat(percentageScutoids));
meanPercScutoids = meanPercScutoids(1:length(sr));
stdPercScutoids = stdPercScutoids(1:length(sr));

% 
% myfitSqrt=fit(sr',meanNeighBasalAcum',myfittypeSqrt,'StartPoint',[1]);
% figure;plot(myfitSqrt)
% hold on; plot(sr',meanNeighBasalAcum')
% title('Sqrt')

% myfitLn=fit(sr',meanNeighBasalAcum',myfittypeLn,'StartPoint',[1 6]);
% figure;plot(myfitLn)
% hold on; plot(sr',meanNeighBasalAcum')
% title('Ln')

myfitLog10=fit(sr',meanNeighBasalAcum',myfittypeLog10,'StartPoint',[1 6]);
figure;plot(myfitLog10)
hold on; plot(sr',meanNeighBasalAcum')
title('Log10')

figure;
e = errorbar(meanNeighBasalAcum(1:8),meanPercScutoids(1:8),stdNeighBasalAcum(1:8), 'horizontal');
%e.Color = 'Red';
%e.Color = [255 132 0];
ylabel('Percentage scutoids')
xlabel('Total neighbours 3D')
title(['Voronoi ' num2str(voronoiDiagram)])
xlim([6 9.5])
ylim([0  1.05])
hold on;
%powerFit=fit(allNeighBasal3D(:), allPercentageScutoids(:),  myfittypePowFit, 'StartPoint',[-100 12 1]);
plot(fittedmodel)

powerFit=fit(allNeighBasal3D(:), allPercentageScutoids(:), 'power2');

xx = meanPercScutoids(1:8);
yy = meanNeighBasalAcum(1:8);

figure;
errorbar(sr(1:8),meanNeighBasalAcum(1:8),stdNeighBasalAcum(1:8))
xlabel('sr')
ylabel('neighs 3d')
title(['Voronoi ' num2str(voronoiDiagram)])

% myfitExp=fit(sr([1,3,5:end])',meanNeighBasalAcum([1,3,5:end])',myfittypeExp,'StartPoint',[1 6]);
% figure;plot(myfitExp)
% hold on; plot(sr([1,3,5:end])',meanNeighBasalAcum([1,3,5:end])')
% title('Exponential')
% 
% myfitPow=fit(sr',meanNeighBasalAcum',myfittypePowFit,'StartPoint',[1 6]);
% figure;plot(myfitPow)
% hold on; plot(sr',meanNeighBasalAcum')
% title('PowerFit')
