function delaunayGraphics(folderName,tableTotalResults,voronoiNumber)

    switch voronoiNumber
        case 1
            colorPlot = [200/255,200/255,200/255];
        case 8
            colorPlot = [0.2,0.4,1];
        case 0 %% Gland
            colorPlot = [151 238 152]/255;
        otherwise
            colorPlot = [0 0 0];
    end

    srOfInterest = 1:0.25:10;
    arrayTable = table2array(tableTotalResults);
    arrayTable(isnan(arrayTable)) = 0;
    srInd = ismember(arrayTable(1,:),srOfInterest);
    arrayTableInd = arrayTable(:,srInd);
    %% figure Euler 3D
    close all
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
   
    myfittypeLn=fittype('6 + b*log(x)','dependent', {'y'}, 'independent',{'x'},'coefficients', {'b'});
    [myfitLn,outputFitting]=fit(arrayTableInd(1,:)',arrayTableInd(2,:)',myfittypeLn,'StartPoint',[6]);
    plot(myfitLn, [1 max(arrayTableInd(1,:))+1], [6 myfitLn(max(arrayTableInd(1,:))+1)])
    children = get(gca, 'children');
    delete(children(2));
    set(children(1),'LineWidth',2,'Color',colorPlot)  
    
    hold on
    errorbar(arrayTableInd(1,:),arrayTableInd(2,:),arrayTableInd(3,:),'o','MarkerSize',5,...
            'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
    title('euler neighbours 3D')
    xlabel('surface ratio')
    ylabel('neighbours total')
    
    preD = predint(myfitLn,[arrayTableInd(1,:) max(arrayTableInd(1,:))+1],0.95,'observation','off');
    plot([arrayTableInd(1,:) max(arrayTableInd(1,:))+1],preD,'--','Color',colorPlot)
    x = [0 11];
    y = [6 6];
    line(x,y,'Color','red','LineStyle','--')
    hold off
%     ylim([5,12]);
%     yticks(5:12)  
%     xlim([0,12]);
%     xticks(0:12)  
    set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
    legend('hide')
    print(h,[folderName 'delaunay_euler3D_Voronoi' num2str(voronoiNumber) '_noLegend_' date],'-dtiff','-r300')
    legend({['Voronoi ' num2str(voronoiNumber) ' - R^2 ' num2str(outputFitting.rsquare)]})
    savefig(h,[folderName 'delaunay_euler3D_Voronoi' num2str(voronoiNumber) '_' date])
    print(h,[folderName 'delaunay_euler3D_Voronoi' num2str(voronoiNumber) '_legend_' date],'-dtiff','-r300')
    
    
    %% figure Apico-Basal transitions 3D
    close all
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
   
    myfittypeLn=fittype('b*log(x)','dependent', {'y'}, 'independent',{'x'},'coefficients', {'b'});
    [myfitLn,outputFitting]=fit(arrayTableInd(1,:)',arrayTableInd(4,:)',myfittypeLn,'StartPoint',[0]);
    plot(myfitLn, [1 max(arrayTableInd(1,:))+1], [0 myfitLn(max(arrayTableInd(1,:))+1)])
    children = get(gca, 'children');
    delete(children(2));
    set(children(1),'LineWidth',2,'Color',colorPlot)  
    
    hold on
    errorbar(arrayTableInd(1,:),arrayTableInd(4,:),arrayTableInd(5,:),'o','MarkerSize',5,...
            'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
    title('accumulative apico-basal transitions')
    xlabel('surface ratio')
    ylabel('apico-basal transitions')
    
    preD = predint(myfitLn,[arrayTableInd(1,:) max(arrayTableInd(1,:))+1],0.95,'observation','off');
    plot([arrayTableInd(1,:) max(arrayTableInd(1,:))+1],preD,'--','Color',colorPlot)

    hold off
%     ylim([0,11]);
%     yticks(0:11)  
%     xlim([0,12]);
%     xticks(0:12)  
    
    set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
    legend('hide')
    print(h,[folderName 'delaunay_apicoBasalTransitions_Voronoi' num2str(voronoiNumber) '_noLegend_' date],'-dtiff','-r300')
    legend({['Voronoi ' num2str(voronoiNumber) ' - R^2 ' num2str(outputFitting.rsquare)]})
    savefig(h,[folderName 'delaunay_apicoBasalTransitions_Voronoi' num2str(voronoiNumber) '_' date])
    print(h,[folderName 'delaunay_apicoBasalTransitions_Voronoi' num2str(voronoiNumber) '_legend_' date],'-dtiff','-r300')

    %% figure percentage of scutoids
    close all
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
   
    hold on
    errorbar(arrayTableInd(1,:),arrayTableInd(6,:),arrayTableInd(7,:),'o','MarkerSize',5,...
            'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
    title('percentage of scutoids')
    xlabel('surface ratio')
    ylabel('scutoids proportion')

    hold off
%     ylim([0,1.2]);
%     yticks(0:0.1:1.2)  
%     xlim([0,11]);
%     xticks(0:11)  
  
    set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
    legend('hide')
    print(h,[folderName 'delaunay_scutoidsProportion_Voronoi' num2str(voronoiNumber) '_noLegend_' date],'-dtiff','-r300')
    legend(['Voronoi ' num2str(voronoiNumber)])
    savefig(h,[folderName 'delaunay_scutoidsProportion_Voronoi' num2str(voronoiNumber) '_' date])
    print(h,[folderName 'delaunay_scutoidsProportion_Voronoi' num2str(voronoiNumber) '_legend_' date],'-dtiff','-r300')
    
    
    
    % n total VS n apico_basal
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
    plot(arrayTableInd(4,:),arrayTableInd(2,:),'o','MarkerSize',5,'MarkerFaceColor',colorPlot,'MarkerEdgeColor',colorPlot)
    legend(['Voronoi ' num2str(voronoiNumber)])
    ylabel('n total')
    xlabel('n apico basal transitions')
    set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');

    print(h,[folderName 'delaunay_NapicoBasalTran_Ntotal_Voronoi' num2str(voronoiNumber) '_noLegend_' date],'-dtiff','-r300')
    legend(['Voronoi ' num2str(voronoiNumber)])
    savefig(h,[folderName 'delaunay_NapicoBasalTran_Ntotal_Voronoi' num2str(voronoiNumber) '_' date])
    print(h,[folderName 'delaunay_NapicoBasalTran_Ntotal_Voronoi' num2str(voronoiNumber) '_legend_' date],'-dtiff','-r300')
    
    
    % n total VS % scutoids
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
    plot(arrayTableInd(6,:),arrayTableInd(2,:),'o','MarkerSize',5,'MarkerFaceColor',colorPlot,'MarkerEdgeColor',colorPlot)
    ylabel('n total')
    xlabel('scutoids proportion')
    set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
    print(h,[folderName 'delaunay_Ntotal_Scutoids_Voronoi' num2str(voronoiNumber) '_noLegend_' date],'-dtiff','-r300')
    legend(['Voronoi ' num2str(voronoiNumber)])
    savefig(h,[folderName 'delaunay_Ntotal_Scutoids_Voronoi' num2str(voronoiNumber) '_' date])
    print(h,[folderName 'delaunay_Ntotal_Scutoids_Voronoi' num2str(voronoiNumber) '_legend_' date],'-dtiff','-r300')
    
    
    
    % n apico basal VS n scutoids
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
    plot(arrayTableInd(6,:),arrayTableInd(4,:),'o','MarkerSize',5,'MarkerFaceColor',colorPlot,'MarkerEdgeColor',colorPlot)
    ylabel('n apico basal transitions')
    xlabel('scutoids proportion')
    set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
    print(h,[folderName 'delaunay_NapicoBasalTran_Scutoids_Voronoi' num2str(voronoiNumber) '_noLegend_' date],'-dtiff','-r300')
    legend(['Voronoi ' num2str(voronoiNumber)])
    savefig(h,[folderName 'delaunay_NapicoBasalTran_Scutoids_Voronoi' num2str(voronoiNumber) '_' date])
    print(h,[folderName 'delaunay_NapicoBasalTran_Scutoids_Voronoi' num2str(voronoiNumber) '_legend_' date],'-dtiff','-r300')
    
    
end

