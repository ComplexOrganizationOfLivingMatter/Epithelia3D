folderPath = 'D:\Pedro\Epithelia3D\InSilicoModels\TubularModel\data\';

numSeeds = 1000;
surfaceRatio = 2000;
name = ['delaunayEuler3D_' num2str(numSeeds) 'seeds_sr' num2str(surfaceRatio) '_31-Jan-2019.mat'];
load([folderPath name])

myfittypeLn=fittype('a +b*log(x)',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});

myfittypeLog10=fittype('a +b*log10(x)',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});


srRep = repmat(horzcat(table2array(tableEuler3D(1,:)))',1,20);
neighsSamples = horzcat(table2array(tableEuler3D(2:end,:)))';

myfitLn=fit(srRep(:),neighsSamples(:),myfittypeLn,'StartPoint',[1 6]);

myfitLog10=fit(srRep(:),neighsSamples(:),myfittypeLog10,'StartPoint',[1 6]);
figure;
plot(srRep,neighsSamples,'o')
hold on
plot(myfitLog10)
title('Log10')

figure;
surfaceRatios = horzcat(table2array(tableEuler3D(1,:)));
meanNeig = mean(neighsSamples');
stdNeigh = std(neighsSamples');
indices2plot = [1:3:15,18:5:33,38:10:68,78:20:surfaceRatio];

plot(myfitLog10)
    hold on

errorbar(surfaceRatios(indices2plot),meanNeig(indices2plot),stdNeigh(indices2plot),'o','CapSize',4,'MarkerSize',4,...
            'Color',[0.5 0.5 0.5],'MarkerEdgeColor',[0,0,0],'MarkerFaceColor',[0,0,0],'LineWidth',0.5)
    title('euler neighbours 3D')
    xlabel('surface ratio')
    ylabel('neighbours total')
    x = [0 surfaceRatio+2];
    y = [6 6];   

    line(x,y,'Color','red','LineStyle','--')
        
    
    hold off
    xticks([0:surfaceRatio/10:surfaceRatio])
    yticks([0:2:24])
    xlim([0 surfaceRatio+20])
    set(gca,'FontSize', 24,'FontName','Helvetica');

