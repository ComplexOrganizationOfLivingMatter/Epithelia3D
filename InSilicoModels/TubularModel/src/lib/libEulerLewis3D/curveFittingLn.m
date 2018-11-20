myfittype=fittype('a +b*log(x)',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});
sr = 1./(1:-0.1:0.1);

meanNeighBasalAcum=cellfun(@(x) mean(x{:,:}),numNeighAccumPerSurfaces,'UniformOutput',false);

stdNeighBasalAcum = std(cat(1,meanNeighBasalAcum{:,:}));
meanNeighBasalAcum = mean(cat(1,meanNeighBasalAcum{:,:}));

sr([1,3,5:end])

myfit=fit(sr([1,3,5:end])',meanNeighBasalAcum([1,3,5:end])',myfittype,'StartPoint',[1 6]);