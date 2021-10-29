function [logEulerTable, piecewiseEulerTable, logisticEulerTable,logisticEulerTableBuceta] = delaunayGraphics(folderName,tableTotalResults,voronoiNumber,srOfInterest,dataDirection,neighsAccum,neighsPerLayer,nRealizations)
    
    addpath(genpath(fullfile('..','..','3D_laws','Code')))

    logEulerTable = [];
    piecewiseEulerTable = [];
    logisticEulerTable = [];
    logisticEulerTableBuceta=[];
    switch voronoiNumber
        case 1
            colorPlot = [230/255,230/255,230/255];
        case 2
            colorPlot = [200/255,200/255,200/255];
        case 3
            colorPlot = [180/255,180/255,180/255];
        case 4
            colorPlot = [150/255,150/255,150/255];
        case 5
            colorPlot = [120/255,120/255,120/255];
        case 6
            colorPlot = [100/255,100/255,100/255];
        case 7
            colorPlot = [75/255,75/255,75/255];
        case 8
            colorPlot = [50/255,50/255,50/255];
        case 9
            colorPlot = [25/255,25/255,25/255];
        case 10
            colorPlot = [0/255,0/255,0/255];
        case 0 %% Gland
            colorPlot = [151 238 152]/255;
        otherwise
            colorPlot = [0 0 0];
    end

    arrayTable = table2array(tableTotalResults);
    arrayTable(isnan(arrayTable)) = 0;
    srInd = ismember(arrayTable(1,:),srOfInterest);
    arrayTableInd = arrayTable(:,srInd);
    
    
%     if strcmp(dataDirection,'FromBasalToApical')
%         %arrayTableInd =  [arrayTableInd(1,:);fliplr(arrayTableInd(2:end,:))];
%     end
    
    nameData = dataDirection;

%     %% figure fitting Euler 3D - Logistic function
%     %Global min
%     
%     %fixing n(s=1)=6   ---->   b = (6*d - exp(1/c)*(Nmax-6))/Nmax;
%     %'n(s)= Nmax*(((6*d - exp(1/c)*(Nmax-6))/Nmax) + exp(s/c))/(d + exp(s/c))';
%   
%     %restrictions c>0,
%     
%     %c > 0      x(1)
%     %d < 0      x(2)
%     %If d < -1 then c*ln(-d) < 1.
%     %Nmax > 0   x(3) 
%     %d > b
%     %b is the dependent variable to force <m(s=1)> = 6. 
%  
%     b=1;
%     d=1;
%     c=-1;
%     nMax=0;
%     coeffvals = [b c d nMax];
%     
%     rng default % For reproducibility
%     gs = GlobalSearch;
%      
%     vBound = 0.1;
%     p0=[vBound,-vBound,6];
%     lb = [vBound,-inf,6];
%     ub = [inf,-vBound,inf];
%     global xdata;
%     global ydata;
%     xdata=arrayTableInd(1,:);
%     ydata=arrayTableInd(2,:);
% 
%     problem = createOptimProblem('fmincon','x0',p0,...
%         'objective',@fittingLogFunc,'lb',lb,'ub',ub);%),'options',options);
%     
%     sol = run(gs,problem);
%     c = sol(1);
%     d = sol(2);
%     Nmax = sol(3);
%     b = (6*d - exp(1/c)*(Nmax-6))/Nmax;
%     coeffvals = [b sol];
%     sse = fittingLogFunc(sol);
%     global rsquare_value;
%     
%     f = fittype('Nmax*(((6*d - exp(1/c)*(Nmax-6))/Nmax) + exp(s/c))/(d + exp(s/c))','independent','s','coefficients',{'c','d','Nmax'});
%     myfitLogConstrained = cfit(f,c,d,Nmax);
%     
%     logisticEulerTableBuceta = array2table([coeffvals sse rsquare_value],'VariableNames',{'b','c','d','Nmax','sse','rsquared'}, 'RowNames',{['Voronoi ' num2str(voronoiNumber)]});
% 
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
%    
%     opts = fitoptions('Method','NonlinearLeastSquares','Lower',0,...
%                'Upper',Inf,'StartPoint',0);
%     opts.Display = 'Off';
%     
%     plot(myfitLogConstrained, [1 max(arrayTableInd(1,:))+1], [6 myfitLogConstrained(max(arrayTableInd(1,:))+1)])
%     
%     children = get(gca, 'children');
%     delete(children(2));
%     set(children(1),'LineWidth',2,'Color',colorPlot)  
%     
%     hold on
%     errorbar(arrayTableInd(1,:),arrayTableInd(2,:),arrayTableInd(3,:),'o','MarkerSize',5,...
%             'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
%     title(['euler neighbours 3D - Voronoi ' num2str(voronoiNumber) ])
%     xlabel('surface ratio')
%     ylabel('neighbours total')
%     
% %     preD = predint(myfitLogConstrained,[arrayTableInd(1,:) max(arrayTableInd(1,:))+1],0.95,'observation','off');
% %     plot([arrayTableInd(1,:) max(arrayTableInd(1,:))+1],preD,'--','Color',colorPlot)
%     x = [0 max(arrayTableInd(1,:))+2];
%     y = [6 6];
%     line(x,y,'Color','red','LineStyle','--')
%     hold off
%     ylim([5,12]);
%     yticks(5:12)  
%     xlim([0,max(arrayTableInd(1,:))+2]);
%     xticks(0:max(arrayTableInd(1,:))+2)  
%    
%     legend('hide')
%     
%     print(h,[folderName 'euler3D_Voronoi' num2str(voronoiNumber) '_' nameData '_LogisticConstrained_noLegend_' date],'-dtiff','-r300')
%     legend({['Voronoi ' num2str(voronoiNumber) ' - R^2 ' num2str(rsquare_value)]})
%     savefig(h,[folderName 'euler3D_Voronoi' num2str(voronoiNumber) '_' nameData '_LogisticConstrained_' date])
%     print(h,[folderName 'euler3D_Voronoi' num2str(voronoiNumber) '_' nameData '_LogisticConstrained_legend_' date],'-dtiff','-r300')
    
    nTotalCells = 200;
    upperBoundNmax= (nTotalCells+5)/2; %theoretically calculated. Other option use upperBoundNmax = inf;
    n3d_0 = arrayTableInd(2,1); %other option use n3d_0 = 6;
    [logisticEulerTableBuceta] = fittingFlintstonesLaw(arrayTableInd(1,:),arrayTableInd(2,:),arrayTableInd(3,:),upperBoundNmax,n3d_0,colorPlot,[],['Voronoi ' num2str(voronoiNumber)]);

%     %% figure Apico-Basal transitions 3D
%     close all
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
%    
%     myfittypeLn=fittype('b*log(x)','dependent', {'y'}, 'independent',{'x'},'coefficients', {'b'});
%     [myfitLn,outputFitting]=fit(arrayTableInd(1,:)',arrayTableInd(4,:)',myfittypeLn,'StartPoint',[0]);
%     plot(myfitLn, [1 max(arrayTableInd(1,:))+1], [0 myfitLn(max(arrayTableInd(1,:))+1)])
%     children = get(gca, 'children');
%     delete(children(2));
%     set(children(1),'LineWidth',2,'Color',colorPlot)  
%     
%     hold on
%     errorbar(arrayTableInd(1,:),arrayTableInd(4,:),arrayTableInd(5,:),'o','MarkerSize',5,...
%             'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
%     title(['accumulative apico-basal transitions - Voronoi ' num2str(voronoiNumber) ])
%     xlabel('surface ratio')
%     ylabel('apico-basal transitions')
%     
%     preD = predint(myfitLn,[arrayTableInd(1,:) max(arrayTableInd(1,:))+1],0.95,'observation','off');
%     plot([arrayTableInd(1,:) max(arrayTableInd(1,:))+1],preD,'--','Color',colorPlot)
% 
%     hold off
%     ylim([0,11]);
%     yticks(0:11)  
%     xlim([0,12]);
%     xticks(0:12)  
%     
%     set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
%     legend('hide')
%     print(h,[folderName 'apicoBasalTransitions_Voronoi' num2str(voronoiNumber) '_' nameData '_noLegend_' date],'-dtiff','-r300')
%     legend({['Voronoi ' num2str(voronoiNumber) ' - R^2 ' num2str(outputFitting.rsquare)]})
%     savefig(h,[folderName 'apicoBasalTransitions_Voronoi' num2str(voronoiNumber) '_' nameData '_' date])
%     print(h,[folderName 'apicoBasalTransitions_Voronoi' num2str(voronoiNumber) '_' nameData '_legend_' date],'-dtiff','-r300')
% 
%     %% figure percentage of scutoids
%     close all
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
%    
%     hold on
%     errorbar(arrayTableInd(1,:),arrayTableInd(6,:),arrayTableInd(7,:),'o','MarkerSize',5,...
%             'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
%     title(['percentage of scutoids - Voronoi ' num2str(voronoiNumber)])
%     xlabel('surface ratio')
%     ylabel('scutoids proportion')
% 
%     hold off
%     ylim([0,1.2]);
%     yticks(0:0.1:1.2)  
%     xlim([0,11]);
%     xticks(0:11)  
%   
%     set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
%     legend('hide')
%     print(h,[folderName 'scutoidsProportion_Voronoi' num2str(voronoiNumber) '_' nameData '_noLegend_' date],'-dtiff','-r300')
%     legend(['Voronoi ' num2str(voronoiNumber)])
%     savefig(h,[folderName 'scutoidsProportion_Voronoi' num2str(voronoiNumber) '_' nameData '_' date])
%     print(h,[folderName 'scutoidsProportion_Voronoi' num2str(voronoiNumber) '_' nameData '_legend_' date],'-dtiff','-r300')
%     
%     
%     
%     % n total VS n apico_basal transitions
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
%     plot(arrayTableInd(4,:),arrayTableInd(2,:),'o','MarkerSize',5,'MarkerFaceColor',colorPlot,'MarkerEdgeColor',colorPlot)
%     legend(['Voronoi ' num2str(voronoiNumber)])
%     title(['n total vs n api-basal transitions - Voronoi ' num2str(voronoiNumber) ])
%     ylabel('n total')
%     xlabel('n apico basal transitions')
%     set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
% 
%     print(h,[folderName 'nApicoBasalTran_Ntotal_Voronoi' num2str(voronoiNumber) '_' nameData '_noLegend_' date],'-dtiff','-r300')
%     legend(['Voronoi ' num2str(voronoiNumber)])
%     savefig(h,[folderName 'nApicoBasalTran_Ntotal_Voronoi' num2str(voronoiNumber) '_' nameData '_' date])
%     print(h,[folderName 'nApicoBasalTran_Ntotal_Voronoi' num2str(voronoiNumber) '_' nameData '_legend_' date],'-dtiff','-r300')
%     
%     
%     % n total VS % scutoids
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
%     plot(arrayTableInd(6,:),arrayTableInd(2,:),'o','MarkerSize',5,'MarkerFaceColor',colorPlot,'MarkerEdgeColor',colorPlot)
%     title(['n total vs % scutoids - Voronoi ' num2str(voronoiNumber) ])
%     ylabel('n total')
%     xlabel('scutoids proportion')
%     set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
%     print(h,[folderName 'nTotal_Scutoids_Voronoi' num2str(voronoiNumber) '_' nameData '_noLegend_' date],'-dtiff','-r300')
%     legend(['Voronoi ' num2str(voronoiNumber)])
%     savefig(h,[folderName 'nTotal_Scutoids_Voronoi' num2str(voronoiNumber) '_' date])
%     print(h,[folderName 'nTotal_Scutoids_Voronoi' num2str(voronoiNumber) '_' nameData '_legend_' date],'-dtiff','-r300')
%     
%     
%     
%     % n apico basal transitions VS n scutoids
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
%     plot(arrayTableInd(6,:),arrayTableInd(4,:),'o','MarkerSize',5,'MarkerFaceColor',colorPlot,'MarkerEdgeColor',colorPlot)
%     title(['n api-basal transitions vs % scutoids - Voronoi ' num2str(voronoiNumber) ])
%     ylabel('n apico basal transitions')
%     xlabel('scutoids proportion')
%     set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
%     print(h,[folderName 'nApicoBasalTran_Scutoids_Voronoi' num2str(voronoiNumber) '_' nameData '_noLegend_' date],'-dtiff','-r300')
%     legend(['Voronoi ' num2str(voronoiNumber)])
%     savefig(h,[folderName 'nApicoBasalTran_Scutoids_Voronoi' num2str(voronoiNumber) '_' date])
%     print(h,[folderName 'nApicoBasalTran_Scutoids_Voronoi' num2str(voronoiNumber) '_' nameData '_legend_' date],'-dtiff','-r300')
%     
%     close all
end

