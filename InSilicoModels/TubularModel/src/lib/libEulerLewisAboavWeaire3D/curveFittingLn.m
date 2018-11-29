sr = 1./(1:-0.1:0.1);
sr = unique([sr,4,6:9,11:15]);

myfittypeLn=fittype('a +b*log(x)',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});

myfittypeLog10=fittype('a +b*log10(x)',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});


myfittypeExp=fittype('a+x^b',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});

myfittypeSqrt=fittype('6+b*sqrt(x)',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'b'});

myfittypePowFit=fittype('a*x^b',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});

meanNeighBasalAcum=cellfun(@(x) mean(x{:,:}),numNeighAccumPerSurfaces,'UniformOutput',false);

stdNeighBasalAcum = std(cat(1,meanNeighBasalAcum{:,:}));
meanNeighBasalAcum = mean(cat(1,meanNeighBasalAcum{:,:}));

meanNeighBasalAcum = meanNeighBasalAcum(1:length(sr));
stdNeighBasalAcum = stdNeighBasalAcum(1:length(sr));

myfitSqrt=fit(sr',meanNeighBasalAcum',myfittypeSqrt,'StartPoint',[1]);
figure;plot(myfitSqrt)
hold on; plot(sr',meanNeighBasalAcum')
title('Sqrt')

myfitLn=fit(sr',meanNeighBasalAcum',myfittypeLn,'StartPoint',[1 6]);
figure;plot(myfitLn)
hold on; plot(sr',meanNeighBasalAcum')
title('Ln')

myfitLog10=fit(sr',meanNeighBasalAcum',myfittypeLog10,'StartPoint',[1 6]);
figure;plot(myfitLog10)
hold on; plot(sr',meanNeighBasalAcum')
title('Log10')

myfitExp=fit(sr([1,3,5:end])',meanNeighBasalAcum([1,3,5:end])',myfittypeExp,'StartPoint',[1 6]);
figure;plot(myfitExp)
hold on; plot(sr([1,3,5:end])',meanNeighBasalAcum([1,3,5:end])')
title('Exponential')

myfitPow=fit(sr',meanNeighBasalAcum',myfittypePowFit,'StartPoint',[1 6]);
figure;plot(myfitPow)
hold on; plot(sr',meanNeighBasalAcum')
title('PowerFit')
