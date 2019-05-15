function delaunayGraphics(folderName,tableTotalResults,voronoiNumber)

    switch voronoiNumber
        case 1
            colorPlot = [200/255,200/255,200/255];
        case 8
            colorPlot = [0.2,0.4,1];
        case 0 %% Gland
            colorPlot = [151 238 152]/255;
    end

    srOfInterest = 1:0.25:10;
    arrayTable = table2array(tableTotalResults);
    arrayTable(isnan(arrayTable)) = 0;
    srInd = ismember(arrayTable(1,:),srOfInterest);
    arrayTableInd = arrayTable(:,srInd);
    %% figure Euler 3D
    close all
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
   
    myfittypeLog10=fittype('a +b*log10(x)','dependent', {'y'}, 'independent',{'x'},'coefficients', {'a','b'});
    [myfitLog10,outputFitting]=fit(arrayTableInd(1,:)',arrayTableInd(2,:)',myfittypeLog10,'StartPoint',[1,6]);
    plot(myfitLog10, [1 max(arrayTableInd(1,:))+1], [6 myfitLog10(max(arrayTableInd(1,:))+1)])
    children = get(gca, 'children');
    delete(children(2));
    set(children(1),'LineWidth',2,'Color',colorPlot)  
    
    hold on
    errorbar(arrayTableInd(1,:),arrayTableInd(2,:),arrayTableInd(3,:),'o','MarkerSize',5,...
            'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
    title('euler neighbours 3D')
    xlabel('surface ratio')
    ylabel('neighbours total')
    
    preD = predint(myfitLog10,[arrayTableInd(1,:) max(arrayTableInd(1,:))+1],0.95,'observation','off');
    plot([arrayTableInd(1,:) max(arrayTableInd(1,:))+1],preD,'--','Color',colorPlot)
    x = [0 11];
    y = [6 6];
    line(x,y,'Color','red','LineStyle','--')
    hold off
    ylim([5,12]);
    yticks(5:12)  
    xlim([0,12]);
    xticks(0:12)  
    set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
    legend('hide')
    print(h,[folderName 'delaunay_euler3D_Voronoi' num2str(voronoiNumber) '_noLegend_' date],'-dtiff','-r300')
    legend({['rsquare ' num2str(outputFitting.rsquare) ' - rmse ' num2str(outputFitting.rmse) ],['Voronoi ' num2str(voronoiNumber)],['95% Confidence'],'','6-line'})
    savefig(h,[folderName 'delaunay_euler3D_Voronoi' num2str(voronoiNumber) '_' date])
    print(h,[folderName 'delaunay_euler3D_Voronoi' num2str(voronoiNumber) '_legend_' date],'-dtiff','-r300')
    
    
    %% figure Apico-Basal transitions 3D
    close all
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
   
    myfittypeLog10=fittype('a +b*log10(x)','dependent', {'y'}, 'independent',{'x'},'coefficients', {'a','b'});
    [myfitLog10,outputFitting]=fit(arrayTableInd(1,:)',arrayTableInd(4,:)',myfittypeLog10,'StartPoint',[0,0]);
    plot(myfitLog10, [1 max(arrayTableInd(1,:))+1], [0 myfitLog10(max(arrayTableInd(1,:))+1)])
    children = get(gca, 'children');
    delete(children(2));
    set(children(1),'LineWidth',2,'Color',colorPlot)  
    
    hold on
    errorbar(arrayTableInd(1,:),arrayTableInd(4,:),arrayTableInd(5,:),'o','MarkerSize',5,...
            'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
    title('accumulative apico-basal transitions')
    xlabel('surface ratio')
    ylabel('apico-basal transitions')
    
    preD = predint(myfitLog10,[arrayTableInd(1,:) max(arrayTableInd(1,:))+1],0.95,'observation','off');
    plot([arrayTableInd(1,:) max(arrayTableInd(1,:))+1],preD,'--','Color',colorPlot)

    hold off
    ylim([0,11]);
    yticks(0:11)  
    xlim([0,12]);
    xticks(0:12)  
    
    set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
    legend('hide')
    print(h,[folderName 'delaunay_apicoBasalTransitions_Voronoi' num2str(voronoiNumber) '_noLegend_' date],'-dtiff','-r300')
    legend({['rsquare ' num2str(outputFitting.rsquare) ' - rmse ' num2str(outputFitting.rmse) ],['Voronoi ' num2str(voronoiNumber)],['95% Confidence'],'','6-line'})
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
    ylim([0,1.2]);
    yticks(0:0.1:1.2)  
    xlim([0,11]);
    xticks(0:11)  
    
    set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
    legend('hide')
    print(h,[folderName 'delaunay_scutoidsProportion_Voronoi' num2str(voronoiNumber) '_noLegend_' date],'-dtiff','-r300')
    legend(['Voronoi ' num2str(voronoiNumber)])
    savefig(h,[folderName 'delaunay_scutoidsProportion_Voronoi' num2str(voronoiNumber) '_' date])
    print(h,[folderName 'delaunay_scutoidsProportion_Voronoi' num2str(voronoiNumber) '_legend_' date],'-dtiff','-r300')


end

