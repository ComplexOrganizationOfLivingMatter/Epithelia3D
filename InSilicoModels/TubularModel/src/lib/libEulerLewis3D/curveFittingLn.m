sr = 1./(1:-0.1:0.1);
sr = unique([sr,4,6:9,11:15]);

myfittypeLog=fittype('a +b*log(x)',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});

myfittypeExp=fittype('a+x^b',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});

myfittypePowFit=fittype('a*x^b',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});

meanNeighBasalAcum=cellfun(@(x) mean(x{:,:}),numNeighAccumPerSurfaces,'UniformOutput',false);

stdNeighBasalAcum = std(cat(1,meanNeighBasalAcum{:,:}));
meanNeighBasalAcum = mean(cat(1,meanNeighBasalAcum{:,:}));

meanNeighBasalAcum = meanNeighBasalAcum(1:length(sr));
stdNeighBasalAcum = stdNeighBasalAcum(1:length(sr));

myfitLog=fit(sr',meanNeighBasalAcum',myfittypeLog,'StartPoint',[1 6]);
figure;plot(myfitLog)
hold on; plot(sr',meanNeighBasalAcum')
title('Log')

myfitExp=fit(sr([1,3,5:end])',meanNeighBasalAcum([1,3,5:end])',myfittypeExp,'StartPoint',[1 6]);
figure;plot(myfitExp)
hold on; plot(sr([1,3,5:end])',meanNeighBasalAcum([1,3,5:end])')
title('Exponential')

myfitPow=fit(sr',meanNeighBasalAcum',myfittypePowFit,'StartPoint',[1 6]);
figure;plot(myfitPow)
hold on; plot(sr',meanNeighBasalAcum')
title('PowerFit')
