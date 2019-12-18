function [logEulerTable, piecewiseEulerTable, logisticEulerTable,logisticEulerTableBuceta] = delaunayGraphics(folderName,tableTotalResults,voronoiNumber,srOfInterest,dataDirection,neighsAccum,neighsPerLayer,nRealizations)
    
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
%     arrayTableInd = arrayTable(:,srInd);
%     
%     
%     if strcmp(dataDirection,'FromBasalToApical')
%         %arrayTableInd =  [arrayTableInd(1,:);fliplr(arrayTableInd(2:end,:))];
%     end
    
    nameData = dataDirection;
    
    
%    %% get accum neighs VS areas
     getDelaunayAreasAccumSides(neighsAccum,neighsPerLayer,folderName,voronoiNumber,srOfInterest,nRealizations,dataDirection);

%     %% figure Euler 3D
%     close all
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
%    
%     opts = fitoptions('Method','NonlinearLeastSquares','Lower',0,...
%                'Upper',Inf,'StartPoint',0);
%     opts.Display = 'Off';
%     
%     myfittypeLn=fittype('6 + b*log(x)','dependent', {'y'}, 'independent',{'x'},'coefficients', {'b'},'options',opts);
%     [myfitLn,outputFitting]=fit(arrayTableInd(1,:)',arrayTableInd(2,:)',myfittypeLn,'StartPoint',[6]);
%     plot(myfitLn, [1 max(arrayTableInd(1,:))+1], [6 myfitLn(max(arrayTableInd(1,:))+1)])
%     
%     coeffvals = coeffvalues(myfitLn);
%     logEulerTable = array2table([coeffvals outputFitting.rsquare],'VariableNames',{'p1','Rsquare'}, 'RowNames',{['Voronoi ' num2str(voronoiNumber)]});
% 
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
%     preD = predint(myfitLn,[arrayTableInd(1,:) max(arrayTableInd(1,:))+1],0.95,'observation','off');
%     plot([arrayTableInd(1,:) max(arrayTableInd(1,:))+1],preD,'--','Color',colorPlot)
%     x = [0 max(arrayTableInd(1,:))+2];
%     y = [6 6];
%     line(x,y,'Color','red','LineStyle','--')
%     hold off
%     ylim([5,12]);
%     yticks(5:12)  
%     xlim([0,max(arrayTableInd(1,:))+2]);
%     xticks(0:max(arrayTableInd(1,:))+2)  
%     set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
%     legend('hide')
%     
%     print(h,[folderName 'euler3D_Voronoi' num2str(voronoiNumber) '_' nameData '_noLegend_' date],'-dtiff','-r300')
%     legend({['Voronoi ' num2str(voronoiNumber) ' - R^2 ' num2str(outputFitting.rsquare)]})
%     savefig(h,[folderName 'euler3D_Voronoi' num2str(voronoiNumber) '_' nameData '_' date])
%     print(h,[folderName 'euler3D_Voronoi' num2str(voronoiNumber) '_' nameData '_legend_' date],'-dtiff','-r300')
%     
%     
%     %% figure fitting Euler 3D - piecewise
%     close all
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');  
%     
%     %fitting using master equation
%     opts = fitoptions('Method','NonlinearLeastSquares','Lower',[1,1,1],...
%                'Upper',[Inf,Inf,Inf],'StartPoint',[1 1 1]);
%     opts.Display = 'Off';
%     myFitTypeComplex =fittype('(6 + p1*log(x))*(x <= X0) + (6+p2*log(x)+(p1-p2)*log(X0))*(x > X0)','dependent', {'y'}, 'independent',{'x'},'options',opts);
% 
%     [myfitPiecewise,outputFitting]=fit(arrayTableInd(1,:)',arrayTableInd(2,:)',myFitTypeComplex);   
%     
%     coeffvals = coeffvalues(myfitPiecewise);
%     piecewiseEulerTable = array2table([coeffvals outputFitting.rsquare],'VariableNames',{'s0','p1','p2','Rsquare'}, 'RowNames',{['Voronoi ' num2str(voronoiNumber)]});
% 
% 
%     plot(myfitPiecewise, [1 max(arrayTableInd(1,:))+1], [6 myfitPiecewise(max(arrayTableInd(1,:))+1)])
%     children = get(gca, 'children');
%     delete(children(2));
%     set(children(1),'LineWidth',2,'Color',colorPlot)  
%     hold on
%     errorbar(arrayTableInd(1,:),arrayTableInd(2,:),arrayTableInd(3,:),'o','MarkerSize',5,...
%             'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
%     title(['euler neighbours 3D - Voronoi ' num2str(voronoiNumber) ])
%     xlabel('surface ratio')
%     ylabel('neighbours total')
%     
%     preD = predint(myfitPiecewise,[arrayTableInd(1,:) max(arrayTableInd(1,:))+1],0.95,'observation','off');
%     plot([arrayTableInd(1,:) max(arrayTableInd(1,:))+1],preD,'--','Color',colorPlot)
%     x = [0 max(arrayTableInd(1,:))+2];
%     y = [6 6];
%     line(x,y,'Color','red','LineStyle','--')
%     hold off
%     ylim([5,12]);
%     yticks(5:12)
%     xlim([0,max(arrayTableInd(1,:))+2]);
%     xticks(0:max(arrayTableInd(1,:))+2)  
%     set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
%     legend('hide')
% 
%     print(h,[folderName 'euler3D_Piecewise_Voronoi' num2str(voronoiNumber) '_' nameData '_noLegend_' date],'-dtiff','-r300')
%     legend({['Voronoi ' num2str(voronoiNumber) ' - R^2 ' num2str(outputFitting.rsquare)]})
%     savefig(h,[folderName 'euler3D_Piecewise_Voronoi' num2str(voronoiNumber) '_' nameData '_' date])
%     print(h,[folderName 'euler3D_Piecewise_Voronoi' num2str(voronoiNumber) '_' nameData '_legend_' date],'-dtiff','-r300')
%     
    
%     %% figure fitting Euler 3D - Logistic function
%     close all
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');  
%     outputFitting.rsquare = [];
%     opts = fitoptions('Method','NonlinearLeastSquares','Robust','on','Algorithm','levenberg-marquardt','TolFun',10^-3,'TolX',10^-3,'MaxFunEvals',10^3,'MaxIter',10^3);
%     %'Lower',[-4,-10,-10,40],'Upper',[0,0,0,100],
%     opts.Display = 'Off';
%     coeffvals = [1 1 -1 0];
%     while (isempty(outputFitting.rsquare) || outputFitting.rsquare < 0.985 || coeffvals(1)>0 || coeffvals(2)>0 || coeffvals(3)<0 || coeffvals(4)<0)
%         myFitLogistic =fittype('k*((1+a*exp(-x/c))/(1+b*exp(-x/c)))','dependent', {'y'}, 'independent',{'x'},'coefficients',{'a', 'b', 'c', 'k'},'options',opts);
%         try
%             [myfitLogistic,outputFitting]=fit(arrayTableInd(1,:)',arrayTableInd(2,:)',myFitLogistic); 
%             % Save the coeffiecient values for 'a', 'b', 'c' and 'k' in a vector
%             coeffvals=coeffvalues(myfitLogistic);
%         catch
%             outputFitting.rsquare = [];
%         end
%         
%     end
%     logisticEulerTable = array2table([coeffvals outputFitting.rsquare],'VariableNames',{'a','b','c','k','Rsquare'}, 'RowNames',{['Voronoi ' num2str(voronoiNumber)]});
%     
%     
%     plot(myfitLogistic, [1 max(arrayTableInd(1,:))+1], [6 myfitLogistic(max(arrayTableInd(1,:))+1)])
%     children = get(gca, 'children');
%     delete(children(2));
%     set(children(1),'LineWidth',2,'Color',colorPlot)  
%     hold on
%     errorbar(arrayTableInd(1,:),arrayTableInd(2,:),arrayTableInd(3,:),'o','MarkerSize',5,...
%             'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
%     title(['euler neighbours 3D - Voronoi ' num2str(voronoiNumber) ])
%     xlabel('surface ratio')
%     ylabel('neighbours total')
%     
%     preD = predint(myfitLogistic,[arrayTableInd(1,:) max(arrayTableInd(1,:))+1],0.95,'observation','off');
%     plot([arrayTableInd(1,:) max(arrayTableInd(1,:))+1],preD,'--','Color',colorPlot)
%     x = [0 max(arrayTableInd(1,:))+2];
%     y = [6 6];
%     line(x,y,'Color','red','LineStyle','--')
%     hold off
%     ylim([5,12]);
%     yticks(5:12) 
%     xlim([0,max(arrayTableInd(1,:))+2]);
%     xticks(0:max(arrayTableInd(1,:))+2)  
%     set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
%     legend('hide')
% 
%     print(h,[folderName 'euler3D_logistic_Voronoi' num2str(voronoiNumber) '_' nameData '_noLegend_' date],'-dtiff','-r300')
%     legend({['Voronoi ' num2str(voronoiNumber) ' - R^2 ' num2str(outputFitting.rsquare)]})
%     savefig(h,[folderName 'euler3D_logistic_Voronoi' num2str(voronoiNumber) '_' nameData '_' date])
%     print(h,[folderName 'euler3D_logistic_Voronoi' num2str(voronoiNumber) '_' nameData '_legend_' date],'-dtiff','-r300')
%     

    

%     %% figure fitting Euler 3D - Logistic function - 3 param.
%     %c>0, Nmax>0, b<0 y d<0
%     %'n(s)= Nmax*(b + exp(s/c))/(d + exp(s/c))';
%     %fixing n(s=1)=6   ---->   d=(Nmax*(exp(1/c)+b)/6) - exp(1/c);
%     %'n(s)= Nmax*(b + exp(s/c))/((Nmax*(exp(1/c)+b)/6) - exp(1/c)) + exp(s/c))';
%     close all
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');  
%     outputFitting.rsquare = [];
%     opts = fitoptions('Method','NonlinearLeastSquares','Robust','on','Algorithm','levenberg-marquardt','TolFun',10^-3,'TolX',10^-3,'MaxFunEvals',10^3,'MaxIter',10^3);
%     %'Lower',[-4,-10,-10,40],'Upper',[0,0,0,100],
%     opts.Display = 'Off';
%     coeffvals = [1 1 -1 0];
%     while (isempty(outputFitting.rsquare) || outputFitting.rsquare < 0.985 || coeffvals(1)>0 || coeffvals(2)>0 || coeffvals(3)<0 || coeffvals(4)<0)
%         myFitLogistic =fittype('Nmax*(b + exp(x/c))/(((Nmax*(exp(1/c)+b)/6) - exp(1/c)) + exp(x/c))','dependent', {'y'}, 'independent',{'x'},'coefficients',{'b', 'c', 'Nmax'},'options',opts);
%         try
%             [myfitLogistic,outputFitting]=fit(arrayTableInd(1,:)',arrayTableInd(2,:)',myFitLogistic); 
%             % Save the coeffiecient values for 'a', 'b', 'c' and 'k' in a vector
%             coeffvalsAux=coeffvalues(myfitLogistic);
%             coeffvals([1,3,4])=coeffvalsAux;
%             coeffvals(2)=(coeffvals(4)*(exp(1/coeffvals(3))+coeffvals(1))/6) - exp(1/coeffvals(3));
%         catch
%             outputFitting.rsquare = [];
%         end
%         
%     end
%     logisticEulerTableBuceta = array2table([coeffvals outputFitting.rsquare],'VariableNames',{'b','d','c','Nmax','Rsquare'}, 'RowNames',{['Voronoi ' num2str(voronoiNumber)]});
%     
%     
%     plot(myfitLogistic, [1 max(arrayTableInd(1,:))+1], [6 myfitLogistic(max(arrayTableInd(1,:))+1)])
%     children = get(gca, 'children');
%     delete(children(2));
%     set(children(1),'LineWidth',2,'Color',colorPlot)  
%     hold on
%     errorbar(arrayTableInd(1,:),arrayTableInd(2,:),arrayTableInd(3,:),'o','MarkerSize',5,...
%             'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
%     title(['euler neighbours 3D - Voronoi ' num2str(voronoiNumber) ])
%     xlabel('surface ratio')
%     ylabel('neighbours total')
%     
%     preD = predint(myfitLogistic,[arrayTableInd(1,:) max(arrayTableInd(1,:))+1],0.95,'observation','off');
%     plot([arrayTableInd(1,:) max(arrayTableInd(1,:))+1],preD,'--','Color',colorPlot)
%     x = [0 max(arrayTableInd(1,:))+2];
%     y = [6 6];
%     line(x,y,'Color','red','LineStyle','--')
%     hold off
%     ylim([5,12]);
%     yticks(5:12) 
%     xlim([0,max(arrayTableInd(1,:))+2]);
%     xticks(0:max(arrayTableInd(1,:))+2)  
%     set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
%     legend('hide')
% 
%     print(h,[folderName 'euler3D_logistic_Voronoi' num2str(voronoiNumber) '_bcNmax_sr10_' nameData '_noLegend_' date],'-dtiff','-r300')
%     legend({['Voronoi ' num2str(voronoiNumber) ' - R^2 ' num2str(outputFitting.rsquare)]})
%     savefig(h,[folderName 'euler3D_logistic_Voronoi' num2str(voronoiNumber) '_bcNmax_sr10_' nameData '_' date])
%     print(h,[folderName 'euler3D_logistic_Voronoi' num2str(voronoiNumber) '_bcNmax_sr10_' nameData '_legend_' date],'-dtiff','-r300')
%     
    

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

