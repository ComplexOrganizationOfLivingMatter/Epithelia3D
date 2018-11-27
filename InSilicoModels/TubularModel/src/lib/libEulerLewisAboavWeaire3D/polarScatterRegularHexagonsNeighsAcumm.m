setOfDegrees = 0:5:30;

path2load = 'data\tubularVoronoiModel\expansion\regularHexagons\rotation';
figure;
pax = polaraxes;
for nDeg = 1:length(setOfDegrees)
    
    load([path2load num2str(setOfDegrees(nDeg)) '\rotation' num2str(setOfDegrees(nDeg)) 'degrees.mat'],'neighsAccum')
    
    neighsSR25_0 = vertcat(neighsAccum{49:-2:1});
    colors = bone(length(neighsSR25_0));
    
    
    for nDots = 1:length(neighsSR25_0)
        polarscatter(deg2rad(setOfDegrees(nDeg)),neighsSR25_0(nDots),50,'filled','MarkerFaceColor',colors(nDots,:),'MarkerEdgeColor',[0 0 0])
        hold on
    end
end

pax.ThetaLim = [0 30];
pax.RAxis.Label.String = 'number of neighbours 3D';
pax.RTick = [0 : 1 : 28];
legend(arrayfun(@(x) ['sr ' num2str(x)],25:-1:1,'UniformOutput',false))
title('rotated regular hexagons')