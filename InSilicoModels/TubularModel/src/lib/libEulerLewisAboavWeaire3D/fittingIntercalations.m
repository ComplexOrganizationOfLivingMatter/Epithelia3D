%% fitting intercalations with Buceta's formula
%%<i_formula>  = (2/p2)*log(1+(p1*p2*(s-1)/exp(6*p2)));


    path2save = 'D:\Pedro\Epithelia3D\3D_laws\from diagram 8 tube\';
    rootpath = 'D:\Pedro\Epithelia3D\InSilicoModels\TubularModel\data\tubularVoronoiModel\expansion\512x4096_200seeds\';

%     %% Voronoi 8
%     colorPlot = [0.2,0.4,1];
%     nDiagram = 8;
%     diagramFolder = ['diagram' num2str(nDiagram) '_Markov\'];
%     load([rootpath diagramFolder 'polygonsDistributions\dataPolygonDistributionAndPercentageScutoids_15-May-2019.mat'],'SR','tableTotalResults')
% 
%     stdIntercalations = [0 table2array(tableTotalResults(5,2:end))];
%     meanIntercalations = [0 table2array(tableTotalResults(4,2:end))]; 
%     
    %fitting using Buceta's equation
    opts = fitoptions('Method','NonlinearLeastSquares','Lower',[0.0001,0.0001],'Upper',[Inf,Inf],'StartPoint',[0 0]);
    opts.Display = 'Off';
    myFitTypeComplex =fittype('(2/p2)*log(1+(p1*p2*(x-1)/exp(6*p2)))','dependent', {'y'}, 'independent',{'x'},'options',opts);
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';

%     [myfitLn,outputFitting]=fit(SR',meanIntercalations',myFitTypeComplex);
%     myfitLn
%     
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
%     plot(myfitLn, [0 11], [0 myfitLn(11)])
%     children = get(gca, 'children');
%     delete(children(2));
%     set(children(1),'LineWidth',2,'Color',colorPlot)  
% 
%     hold on
%     errorbar(SR,meanIntercalations(1:length(SR)),stdIntercalations(1:length(SR)),'o','MarkerSize',5,...
%             'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
%     title('intercalations fitting')
%     xlabel('surface ratio')
%     ylabel('intercalations')
%     
%     preD = predint(myfitLn,[SR max(SR)+1],0.95,'observation','off');
%     plot([SR max(SR)+1],preD,'--','Color',colorPlot)
%     hold off
%     ylim([0,12]);
%     yticks(0:12)  
%     xticks(0:12)
%     legend({['Voronoi ' num2str(nDiagram) ' - R^2 ' num2str(outputFitting.rsquare,4)]})
%     set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
%    
%     savefig(h,[path2save 'intercalationsFitting_Voronoi' num2str(nDiagram) '_' date])
% 
%     print(h,[path2save 'intercalationsFitting_Voronoi' num2str(nDiagram) '_'  date],'-dtiff','-r300')
%     
    

% %% Voronoi 1
%     colorPlot = [200/255,200/255,200/255];
%     nDiagram = 1;
%     diagramFolder = ['diagram' num2str(nDiagram) '_Markov\'];
%     load([rootpath diagramFolder 'polygonsDistributions\dataPolygonDistributionAndPercentageScutoids_16-May-2019.mat'],'SR','tableTotalResults')
% 
%     stdIntercalations = [0 table2array(tableTotalResults(5,2:end))];
%     meanIntercalations = [0 table2array(tableTotalResults(4,2:end))]; 
% 
%     [myfitLn,outputFitting]=fit(SR',meanIntercalations',myFitTypeComplex);
%     myfitLn
% 
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
%     plot(myfitLn, [0 11], [0 myfitLn(11)])
%     children = get(gca, 'children');
%     delete(children(2));
%     set(children(1),'LineWidth',2,'Color',colorPlot)  
% 
%     hold on
%     errorbar(SR,meanIntercalations(1:length(SR)),stdIntercalations(1:length(SR)),'o','MarkerSize',5,...
%         'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
%     title('intercalations fitting')
%     xlabel('surface ratio')
%     ylabel('intercalations')
% 
%     preD = predint(myfitLn,[SR max(SR)+1],0.95,'observation','off');
%     plot([SR max(SR)+1],preD,'--','Color',colorPlot)
%     hold off
%     ylim([0,12]);
%     yticks(0:12)  
%     xticks(0:12)
%     legend({['Voronoi ' num2str(nDiagram) ' - R^2 ' num2str(outputFitting.rsquare,4)]})
%     set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
% 
%     savefig(h,[path2save 'intercalationsFitting_Voronoi' num2str(nDiagram) '_' date])
% 
%     print(h,[path2save 'intercalationsFitting_Voronoi' num2str(nDiagram) '_'  date],'-dtiff','-r300')

%% Salivary gland

rootpath ='D:\Pedro\LimeSeg_Pipeline\docs\figuresMathPaper\';
load([rootpath 'infoGlands_23-Jul-2019.mat']);

SR = infoEuler3D{1, 1}.Surface_Ratio';
meanAP = zeros([length(SR) size(infoEuler3D,1)]);
for nFold = 1:size(infoEuler3D,1)
    meanAP(:,nFold) = infoEuler3D{nFold, 1}.mean_apicoBasalTransitions;
end
meanIntercalations = mean(meanAP,2)';
stdIntercalations = std(meanAP,[],2)';

% load([rootpath 'apicoBasalIntercalations_Glands_23-Jul-2019.mat']);
colorPlot = [151 238 152]/255;

%     meanIntercalations = horzcat(mean_apicoBasalTransitionsPerGland{:}); 
%     SR = horzcat(surfaceRatiosPerFile{:});
    [myfitLn,outputFitting]=fit(SR',meanIntercalations',myFitTypeComplex);
    myfitLn

    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
    plot(myfitLn, [0 11], [0 myfitLn(11)])
    children = get(gca, 'children');
    delete(children(2));
    set(children(1),'LineWidth',2,'Color',colorPlot)  

    hold on
    
    
    errorbar(SR,meanIntercalations(1:length(SR)),stdIntercalations(1:length(SR)),'o','MarkerSize',5,...
        'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)

    preD = predint(myfitLn,[SR max(SR)+1],0.95,'observation','off');
    plot([SR max(SR)+1],preD,'--','Color',colorPlot)
    
%     plot(SR,meanIntercalations(1:length(SR)),'o','MarkerSize',5,...
%         'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
    title('intercalations fitting')
    xlabel('surface ratio')
    ylabel('intercalations')

    hold off
    ylim([0,5]);
    yticks(0:5)  
    xticks(0:6)
    legend({['Sal. Glands - R^2 ' num2str(outputFitting.rsquare,4)]})
    set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');

    savefig(h,[path2save 'intercalationsFitting_SalGlands_' date])

    print(h,[path2save 'intercalationsFitting_SalGlands_'  date],'-dtiff','-r300')

