function getStatsAndRepresentationsEulerLewis3D(numNeighOfNeighPerSurface,numNeighOfNeighAccumPerSurface,numNeighPerSurface,numNeighAccumPerSurfaces,areaCellsPerSurface,volumePerSurface,path2save,surfRatios,initialDiagram)

    if ~exist(path2save,'dir')
        mkdir(path2save)
    end
    
    totalNeigh = cat(1,numNeighPerSurface{:});
    totalNeighAccum = cat(1,numNeighAccumPerSurfaces{:});
    totalNeighOfNeigh = cat(1,numNeighOfNeighPerSurface{:});
    totalNeighOfNeighAccum = cat(1,numNeighOfNeighAccumPerSurface{:});
    totalArea = cat(1,areaCellsPerSurface{:});
%     totalVolume = cat(1,volumePerSurface{:});

    totalNeighApical = totalNeigh.('sr1');
    
    meanNeighBasal=cellfun(@(x) mean(x{:,:}),numNeighPerSurface,'UniformOutput',false);
    meanNeighBasalAcum=cellfun(@(x) mean(x{:,:}),numNeighAccumPerSurfaces,'UniformOutput',false);
    
    nUniqueNeighApical = unique(totalNeighApical);
    
    switch initialDiagram
        case 1
            colorPlot = [200/255,200/255,200/255];
        case 8
            colorPlot = [0.2,0.4,1];
        case 0 %% Gland
            colorPlot = [151 238 152]/255;
    end
        
    

    for SR = 1:length(surfRatios)
        
        totalNeighBasal = totalNeigh.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
        totalNeighBasalAccum = totalNeighAccum.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
%         totalVolumeBasal = totalVolume.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
        totalAreaBasal = totalArea.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
        totalAreaApical = totalArea.('sr1');
        
        nUniqueNeighBasal = unique(totalNeighBasal);
        nUniqueNeighBasalAccum = unique(totalNeighBasalAccum);  
        
        nCells = zeros(size(numNeighPerSurface,1),1);

        meanAreaApicalPerSideApical = zeros(size(numNeighPerSurface,1),length(nUniqueNeighApical));
        stdAreaApicalPerSideApical = zeros(size(numNeighPerSurface,1),length(nUniqueNeighApical));
        meanAreaApicalPerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        stdAreaApicalPerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        
        meanNeighOfNeighPerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        stdNeighOfNeighPerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        meanNeighOfNeighAccumPerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
        stdNeighOfNeighAccumPerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
        
        meanAreaApicalPerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
        stdAreaApicalPerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
        meanAreaBasalPerSideApical = zeros(size(numNeighPerSurface,1),length(nUniqueNeighApical));
        stdAreaBasalPerSideApical = zeros(size(numNeighPerSurface,1),length(nUniqueNeighApical));
        meanAreaBasalPerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        stdAreaBasalPerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
        meanAreaBasalPerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
        stdAreaBasalPerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
%         meanVolumePerSideApical = zeros(size(numNeighPerSurface,1),length(nUniqueNeighApical));
%         stdVolumePerSideApical = zeros(size(numNeighPerSurface,1),length(nUniqueNeighApical));
%         meanVolumePerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
%         stdVolumePerSideBasal = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasal));
%         meanVolumePerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
%         stdVolumePerSideBasalAccum = zeros(size(numNeighPerSurface,1),length(nUniqueNeighBasalAccum));
        
        allVolumeBasalNorm = cell(1,size(numNeighPerSurface,1));
        allAreaBasalNorm = cell(1,size(numNeighPerSurface,1));
        allAreaApicalNorm = cell(1,size(numNeighPerSurface,1));
        
        for nImg = 1:size(numNeighPerSurface,1)
            
            imgNeighBasal = numNeighPerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            imgNeighBasalAccum = numNeighAccumPerSurfaces{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            
            imgNeighOfNeighBasal = numNeighOfNeighPerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            imgNeighOfNeighBasalAccum = numNeighOfNeighAccumPerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            
%             imgVolumeBasal = volumePerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            
            imgAreaBasal = areaCellsPerSurface{nImg}.(['sr' strrep(num2str(surfRatios(SR)),'.','_')]);
            
            imgNeighApical = numNeighPerSurface{nImg}.('sr1');
            imgAreaApical = areaCellsPerSurface{nImg}.('sr1');

%             imgVolumeBasalNorm = imgVolumeBasal./mean(imgVolumeBasal);
            imgAreaBasalNorm = imgAreaBasal./mean(imgAreaBasal);
            imgAreaApicalNorm = imgAreaApical./mean(imgAreaApical);
%             allVolumeBasalNorm{nImg} = imgVolumeBasalNorm;
            allAreaBasalNorm{nImg} = imgAreaBasalNorm;
            allAreaApicalNorm{nImg} = imgAreaApicalNorm;
            
            nCells(nImg) = size(imgNeighBasal,1);
 
            %'1_1 area apical - n apical'
            meanAreaApicalPerSideApical(nImg,:) = arrayfun(@(x) mean(imgAreaApicalNorm(ismember(imgNeighApical,x))),nUniqueNeighApical);
            %'1_2 area apical - n basal'
            meanAreaApicalPerSideBasal(nImg,:) = arrayfun(@(x) mean(imgAreaApicalNorm(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
            %'1_3 area apical - n basal accum'
            meanAreaApicalPerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgAreaApicalNorm(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);
            %'2_1 area basal - n apical'
            meanAreaBasalPerSideApical(nImg,:) = arrayfun(@(x) mean(imgAreaBasalNorm(ismember(imgNeighApical,x))),nUniqueNeighApical);
            %'2_2 area basal - n basal'
            meanAreaBasalPerSideBasal(nImg,:) = arrayfun(@(x) mean(imgAreaBasalNorm(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
            %'2_3 area basal - n basal accum'
            meanAreaBasalPerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgAreaBasalNorm(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);
%             %'3_1 volume - n apical'
%             meanVolumePerSideApical(nImg,:) = arrayfun(@(x) mean(imgVolumeBasalNorm(ismember(imgNeighApical,x))),nUniqueNeighApical);
%             %'3_2 volume - n basal'
%             meanVolumePerSideBasal(nImg,:) = arrayfun(@(x) mean(imgVolumeBasalNorm(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
%             %'3_3 Volume - n basal accum'
%             meanVolumePerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgVolumeBasalNorm(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);
%             
            %'4_1 Neigh of neigh - n basal'
            meanNeighOfNeighPerSideBasal(nImg,:) = arrayfun(@(x) mean(imgNeighOfNeighBasal(ismember(imgNeighBasal,x))),nUniqueNeighBasal);
            %'4_2 Neigh of neigh accum - n basal accum'
            meanNeighOfNeighAccumPerSideBasalAccum(nImg,:) = arrayfun(@(x) mean(imgNeighOfNeighBasalAccum(ismember(imgNeighBasalAccum,x))),nUniqueNeighBasalAccum);

        end
        
        h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
        hold on
        %% ROW 1 -Area Apical VS Sides
        %1 area apical vs sides apical
        subplot(3,4,1) 
        errorbar(nUniqueNeighApical,mean(meanAreaApicalPerSideApical),std(meanAreaApicalPerSideApical),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
        ylim([0 max([meanAreaApicalPerSideApical(:);meanAreaApicalPerSideBasal(:);meanAreaApicalPerSideBasalAccum(:)])+max([stdAreaApicalPerSideApical(:);stdAreaApicalPerSideBasal(:);stdAreaApicalPerSideBasalAccum(:)])])
        title('area apical - n apical')
        ylabel('area apical')
        xlabel('sides apical')

        %2 area apical vs sides basal
        subplot(3,4,2)
        errorbar(nUniqueNeighBasal,mean(meanAreaApicalPerSideBasal),std(meanAreaApicalPerSideBasal),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
        ylim([0 max([meanAreaApicalPerSideApical(:);meanAreaApicalPerSideBasal(:);meanAreaApicalPerSideBasalAccum(:)])+max([stdAreaApicalPerSideApical(:);stdAreaApicalPerSideBasal(:);stdAreaApicalPerSideBasalAccum(:)])])
        title('area apical - n basal')
        ylabel('area apical')
        xlabel('sides basal')
        
        %3 area apical vs sides 3D
        subplot(3,4,3)
        errorbar(nUniqueNeighBasalAccum,mean(meanAreaApicalPerSideBasalAccum),std(meanAreaApicalPerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
        ylim([0 max([meanAreaApicalPerSideApical(:);meanAreaApicalPerSideBasal(:);meanAreaApicalPerSideBasalAccum(:)])+max([stdAreaApicalPerSideApical(:);stdAreaApicalPerSideBasal(:);stdAreaApicalPerSideBasalAccum(:)])])
        title('area apical - n basal accum')
        ylabel('area apical')
        xlabel('neighbours total')
        
%         %4 volume VS Area Apical
%         subplot(3,4,4)
%         plot(vertcat(allVolumeBasalNorm{:}),vertcat(allAreaApicalNorm{:}),'o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         title('volume - area apical')
%         ylabel('area apical')
%         xlabel('volume')
             
        %% ROW 2 - Area basal VS sides
        %1 area basal vs sides apical
        subplot(3,4,5) 
        errorbar(nUniqueNeighApical,mean(meanAreaBasalPerSideApical),std(meanAreaBasalPerSideApical),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
        ylim([0 max([meanAreaBasalPerSideApical(:);meanAreaBasalPerSideBasal(:);meanAreaBasalPerSideBasalAccum(:)])+max([stdAreaBasalPerSideApical(:);stdAreaBasalPerSideBasal(:);stdAreaBasalPerSideBasalAccum(:)])])
        title('area basal - n apical')
        ylabel('area basal')
        xlabel('sides apical')
        
        %2 area basal vs sides basal
        subplot(3,4,6)
        errorbar(nUniqueNeighBasal,mean(meanAreaBasalPerSideBasal),std(meanAreaBasalPerSideBasal),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
        ylim([0 max([meanAreaBasalPerSideApical(:);meanAreaBasalPerSideBasal(:);meanAreaBasalPerSideBasalAccum(:)])+max([stdAreaBasalPerSideApical(:);stdAreaBasalPerSideBasal(:);stdAreaBasalPerSideBasalAccum(:)])])
        title('area basal - n basal')
        ylabel('area basal')
        xlabel('sides basal')
        
        %3 area basal vs sides 3D
        subplot(3,4,7)
        errorbar(nUniqueNeighBasalAccum,mean(meanAreaBasalPerSideBasalAccum),std(meanAreaBasalPerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
        ylim([0 max([meanAreaBasalPerSideApical(:);meanAreaBasalPerSideBasal(:);meanAreaBasalPerSideBasalAccum(:)])+max([stdAreaBasalPerSideApical(:);stdAreaBasalPerSideBasal(:);stdAreaBasalPerSideBasalAccum(:)])])
        title('area basal - n basal accum')
        ylabel('area basal')
        xlabel('neighbours total')
        
%         %4 Area Basal VS Volume
%         subplot(3,4,8)
%         plot(vertcat(allVolumeBasalNorm{:}),vertcat(allAreaBasalNorm{:}),'o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         title('volume - area basal')
%         ylabel('area basal')
%         xlabel('volume')

%         %% ROW 3 - Volume VS sides
%         %1 volume vs sides apical
%         subplot(3,4,9) 
%         errorbar(nUniqueNeighApical,mean(meanVolumePerSideApical),std(meanVolumePerSideApical),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         ylim([0 max([meanVolumePerSideApical(:);meanVolumePerSideBasal(:);meanVolumePerSideBasalAccum(:)])+max([stdVolumePerSideApical(:);stdVolumePerSideBasal(:);stdVolumePerSideBasalAccum(:)])])
%         title('volume - n apical')
%         xlabel('sides apical')
%         ylabel('volume')
%         
%         %2 volume vs sides basal
%         subplot(3,4,10)
%         errorbar(nUniqueNeighBasal,mean(meanVolumePerSideBasal),std(meanVolumePerSideBasal),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         ylim([0 max([meanVolumePerSideApical(:);meanVolumePerSideBasal(:);meanVolumePerSideBasalAccum(:)])+max([stdVolumePerSideApical(:);stdVolumePerSideBasal(:);stdVolumePerSideBasalAccum(:)])])
%         title('volume - n basal')
%         ylabel('volume')
%         xlabel('sides basal')
% 
%         %3 volume vs sides 3D
%         subplot(3,4,11)
%         errorbar(nUniqueNeighBasalAccum,mean(meanVolumePerSideBasalAccum),std(meanVolumePerSideBasalAccum),'-o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%         ylim([0 max([meanVolumePerSideApical(:);meanVolumePerSideBasal(:);meanVolumePerSideBasalAccum(:)])+max([stdVolumePerSideApical(:);stdVolumePerSideBasal(:);stdVolumePerSideBasalAccum(:)])])
%         title('volume - n basal accum')
%         ylabel('volume')
%         xlabel('neighbours total')
        
        
        %4 Area Basal VS Area Apical
        subplot(3,4,12)
        plot(vertcat(allAreaApicalNorm{:}),vertcat(allAreaBasalNorm{:}),'o','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
        title('area apical - area basal')
        ylabel('area basal')
        xlabel('area apical')
        
        hold off
        

        
%         print(h,[path2save 'lewis3D_Voronoi' num2str(initialDiagram)  '_SR' strrep(num2str(surfRatios(SR)),'.','_')],'-dtiff','-r300')
        
        
%         if surfRatios(SR)==1.8 || surfRatios(SR)==4
% 
%             h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
%             %1.1 area apical vs sides apical
%             subplot(1,2,1) 
%             meanArea = mean(meanAreaApicalPerSideApical);
%             valInd=~isnan(meanArea);
%             p = polyfit(nUniqueNeighApical(valInd), meanArea(valInd)',1);
%             f = polyval(p,[min(nUniqueNeighApical(valInd))-0.5; nUniqueNeighApical(valInd); max(nUniqueNeighApical(valInd))+0.5]); 
%             hold on
% 
%             plot([min(nUniqueNeighApical(valInd))-0.5; nUniqueNeighApical(valInd); max(nUniqueNeighApical(valInd))+0.5],f,'Color',colorPlot,'LineWidth',1)
%             errorbar(nUniqueNeighApical,mean(meanAreaApicalPerSideApical),std(meanAreaApicalPerSideApical),'o','MarkerSize',5,...
%                 'Color',[0.5 0.5 0.5],'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0],'LineWidth',0.5)
% 
%             ylim([0 max(mean(meanAreaApicalPerSideApical))+min(mean(meanAreaApicalPerSideApical))])
%             title('apical')
%             ylabel('area apical')
%             xlabel('sides apical')
%             xticks(nUniqueNeighApical)
%             xlim([min(nUniqueNeighApical) max(nUniqueNeighApical)])
%             set(gca,'FontSize', 24,'FontName','Helvetica');
% 
%             %1.2 volume vs sides total
%             subplot(1,2,2) 
%             meanVol=mean(meanVolumePerSideBasalAccum);
%             stdVol=std(meanVolumePerSideBasalAccum);
%             valInd=~isnan(meanVol);
%             p = polyfit(nUniqueNeighBasalAccum(valInd), meanVol(valInd)',1);
%             f = polyval(p,[min(nUniqueNeighBasalAccum(valInd))-0.5; nUniqueNeighBasalAccum(valInd); max(nUniqueNeighBasalAccum(valInd))+0.5]); 
% 
%             hold on
%             plot([min(nUniqueNeighBasalAccum(valInd))-0.5; nUniqueNeighBasalAccum(valInd); max(nUniqueNeighBasalAccum(valInd))+0.5],f,'Color',colorPlot,'LineWidth',1)
%             errorbar(nUniqueNeighBasalAccum,mean(meanVolumePerSideBasalAccum),std(meanVolumePerSideBasalAccum),'o','MarkerSize',5,...
%                 'Color',[0.5 0.5 0.5],'MarkerEdgeColor',[0,0,0],'MarkerFaceColor',[0,0,0],'LineWidth',0.5)
%             
%             ylim([0 max(mean(meanVolumePerSideBasalAccum))+min(mean(meanVolumePerSideBasalAccum))])
%             title(['3D - SR ' num2str(surfRatios(SR))])
%             ylabel('volume')
%             xlabel('neighbours total')
%             xticks([min(nUniqueNeighBasalAccum):2:max(nUniqueNeighBasalAccum)])
%             xlim([min(nUniqueNeighBasalAccum) max(nUniqueNeighBasalAccum)])
%             set(gca,'FontSize', 24,'FontName','Helvetica');
% 
%             hold off
% %             savefig(h,[path2save 'Lewis3DVoronoi_apical_SR5.fig'])
% %             print(h,[path2save 'Lewis3DVoronoi_apical_SR5'],'-dtiff','-r300')
% 
%         end       
        
    end  
    
    
    %% Euler 3D
    close all
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
    stdNeighBasalAcum = std(cat(1,meanNeighBasalAcum{:,:}));
    meanNeighBasalAcum = mean(cat(1,meanNeighBasalAcum{:,:}));   
   
    myfittypeLog10=fittype('a +b*log10(x)','dependent', {'y'}, 'independent',{'x'},'coefficients', {'a','b'});
    [myfitLog10,outputFitting]=fit(surfRatios',meanNeighBasalAcum(1:length(surfRatios))',myfittypeLog10,'StartPoint',[1,6]);
    plot(myfitLog10, [1 11], [6 myfitLog10(11)])
    children = get(gca, 'children');
    delete(children(2));
    set(children(1),'LineWidth',2,'Color',colorPlot)  
    
    hold on
    errorbar(surfRatios,meanNeighBasalAcum(1:length(surfRatios)),stdNeighBasalAcum(1:length(surfRatios)),'o','MarkerSize',5,...
            'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
    title('euler neighbours 3D')
    xlabel('surface ratio')
    ylabel('neighbours total')
    
    preD = predint(myfitLog10,[surfRatios max(surfRatios)+1],0.95,'observation','off');
    plot([surfRatios max(surfRatios)+1],preD,'--','Color',colorPlot)
    x = [0 11];
    y = [6 6];
    line(x,y,'Color','red','LineStyle','--')
    hold off
    ylim([5,12]);
    yticks(5:12)  
    
    legend({['rsquare ' num2str(outputFitting.rsquare) ' - rmse ' num2str(outputFitting.rmse) ],['Voronoi ' num2str(initialDiagram)],['95% Confidence'],'','6-line'})
    set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
    savefig(h,[path2save 'euler3D_Voronoi' num2str(initialDiagram) '_' date])

    print(h,[path2save 'euler3D'],'-dtiff','-r300')
    
     %% Euler 3D (LOG10)
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
%     stdNeighBasalAcum = std(log10(cat(1,meanNeighBasalAcum{:,:})));
%     meanNeighBasalAcum = mean(log10(cat(1,meanNeighBasalAcum{:,:})));  
   
    myfittypePoly=fittype('a +b*x','dependent', {'y'}, 'independent',{'x'},'coefficients', {'a','b'});
   [myfitPoly,outputFitting]=fit(log10(surfRatios)',meanNeighBasalAcum(1:length(surfRatios))',myfittypePoly,'StartPoint',[1 6]);

    plot(myfitPoly, [min(log10(surfRatios)) max(log10(surfRatios))], [myfitPoly(1) myfitPoly(max(log10(surfRatios)))])
    children = get(gca, 'children');
    delete(children(2));
    set(children(1),'LineWidth',2,'Color',colorPlot)  
    
%      %% Euler 3D (LOG10)
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
% %     stdNeighBasalAcum = std(log10(cat(1,meanNeighBasalAcum{:,:})));
% %     meanNeighBasalAcum = mean(log10(cat(1,meanNeighBasalAcum{:,:})));  
%    
%     myfittypePoly=fittype('a +b*x','dependent', {'y'}, 'independent',{'x'},'coefficients', {'a','b'});
%    [myfitPoly,outputFitting]=fit(log10(surfRatios)',meanNeighBasalAcum(1:length(surfRatios))',myfittypePoly,'StartPoint',[1 6]);
% 
%     plot(myfitPoly, [min(log10(surfRatios)) max(log10(surfRatios))], [myfitPoly(1) myfitPoly(max(log10(surfRatios)))])
%     children = get(gca, 'children');
%     delete(children(2));
%     set(children(1),'LineWidth',2,'Color',colorPlot)  
%     
%     hold on
%     errorbar(log10(surfRatios),meanNeighBasalAcum(1:length(surfRatios)),stdNeighBasalAcum(1:length(surfRatios)),'o','MarkerSize',5,...
%             'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
%     title('euler neighbours 3D')
%     xlabel('surface ratio (log10)')
%     ylabel('neighbours total (log10)')
% %     x = [0 1.1];
% %     y = [6 6];
% %     line(x,y,'Color','red','LineStyle','--')
% %     hold off
% %     ylim([0,15]);
% %     yticks([0:2:15])
% 
%     legend({['fitting rsquare ' num2str(outputFitting.rsquare)],['Voronoi ' num2str(initialDiagram)],'6-line'})
%     set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
% %     savefig(h,[path2save 'euler3D_Voronoi' num2str(initialDiagram) '_log10'])
% %     print(h,[path2save 'euler3D_log10'],'-dtiff','-r300')

    close all

    %% Euler 2D
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');
%     
%     stdNeighBasal = std(cat(1,meanNeighBasal{:,:}));
%     meanNeighBasal = mean(cat(1,meanNeighBasal{:,:}));
%     
%     errorbar(surfRatios,meanNeighBasal(1:length(surfRatios)),stdNeighBasal(1:length(surfRatios)),'-o','MarkerSize',5,...
%     'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
%     title('euler 2D - per surface')
%     xlabel('surface ratio')
%     ylabel('sides')
%     ylim([0,10]);
%     print(h,[path2save 'euler2D'],'-dtiff','-r300')
%     close all
    
    %% Figure neighs exchange VS mean (total sides)
    splittedPath = strsplit(path2save,'\');
    path2save2 = strrep(path2save,[splittedPath{end-1} '\'],'');
    T = readtable([path2save2 'scutoidsProportion_threshold4_13-Mar-2019.xls']);
    
    numsSR = cellfun(@(x) str2double(strrep(x,'surfaceRatio','')),T.Row);
    indSR = ismember(round(numsSR,2),round(surfRatios,2));
    TindSR = T(indSR,:);
    averageApiBasTransition = TindSR.meanScutoidalEdgesPerCell;
    stdApiBasTransition = TindSR.stdScutoidalEdgesPerCell;
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');

    errorbar(averageApiBasTransition,meanNeighBasalAcum(1:length(surfRatios)),...
        stdNeighBasalAcum(1:length(surfRatios)),stdNeighBasalAcum(1:length(surfRatios)),...
        stdApiBasTransition,stdApiBasTransition,'o','MarkerSize',10,'Color','k',...
    'MarkerEdgeColor','black','MarkerFaceColor',colorPlot)
    legend({['Voronoi tube ' num2str(initialDiagram)]})
    
    xlabel('number of apico-basal transitions (mean)')
    ylabel('number of sides (mean)')
    ylim([5 12])
    xlim([0 8.5])

    yticks(5:12);
    xticks(0:9);

    set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off');
%     print(h,[path2save 'figApicoBasalTrasitionsNsides_' date],'-dtiff','-r300')
%     savefig(h,[path2save 'figApicoBasalTrasitionsNsides_' date '.fig'])
%     
end

