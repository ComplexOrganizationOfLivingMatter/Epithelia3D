myfittypeLog=fittype('a +b*log(x)',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});
sr = 1./(1:-0.1:0.1);

myfittypeExp=fittype('a+x^b',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});

myfittypePowFit=fittype('a*x^b',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});
sr = 1./(1:-0.1:0.1);

meanNeighBasalAcum=cellfun(@(x) mean(x{:,:}),numNeighAccumPerSurfaces,'UniformOutput',false);

stdNeighBasalAcum = std(cat(1,meanNeighBasalAcum{:,:}));
meanNeighBasalAcum = mean(cat(1,meanNeighBasalAcum{:,:}));

myfit=fit(sr',meanNeighBasalAcum',myfittypeLog,'StartPoint',[1 6]);
figure;plot(myfit)
hold on; plot(sr',meanNeighBasalAcum')
title('Log')

myfit=fit(sr([1,3,5:end])',meanNeighBasalAcum([1,3,5:end])',myfittypeExp,'StartPoint',[1 6]);
figure;plot(myfit)
hold on; plot(sr([1,3,5:end])',meanNeighBasalAcum([1,3,5:end])')
title('Exponential')

myfit=fit(sr',meanNeighBasalAcum',myfittypePowFit,'StartPoint',[1 6]);
figure;plot(myfit)
hold on; plot(sr',meanNeighBasalAcum')
title('PowerFit')
