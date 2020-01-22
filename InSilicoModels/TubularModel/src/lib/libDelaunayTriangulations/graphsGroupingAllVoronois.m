function graphsGroupingAllVoronois(folderName,srOfInterest,cellTotalVoronoiResults,totalVoronoiWonNeigh,totalVoronoiNeighPerLayer,namePoorGetRicher,labelHyde)

    
    voronoiNResults = cellTotalVoronoiResults{1};
    
    surfRatios = table2array(voronoiNResults(1,:));
    idOfInterest = ismember(surfRatios,srOfInterest);
    surfRatios = surfRatios(idOfInterest);
    voronoiNResults = voronoiNResults(:,idOfInterest);
    
    voronoiNScutoids = zeros(size(cellTotalVoronoiResults,1),length(surfRatios));
    voronoiNTransitions = zeros(size(cellTotalVoronoiResults,1),length(surfRatios));
    voronoiN3DNeighs = zeros(size(cellTotalVoronoiResults,1),length(surfRatios));

    voronoiNScutoids (1,:) =table2array(voronoiNResults(6,:));
    voronoiNTransitions (1,:) =table2array(voronoiNResults(4,:));
    voronoiN3DNeighs (1,:) =table2array(voronoiNResults(2,:));
    for n= 2 : length(cellTotalVoronoiResults)
        voronoiNResults = cellTotalVoronoiResults{n};
        voronoiNResults = voronoiNResults(:,idOfInterest);
        voronoiNScutoids (n,:) =table2array(voronoiNResults(6,:));
        voronoiNTransitions (n,:) =table2array(voronoiNResults(4,:));
        voronoiN3DNeighs (n,:) =table2array(voronoiNResults(2,:));
    end
    
   voronoiNTransitions(isnan(voronoiNTransitions)) = 0;
   
   xvalues = strsplit(num2str(surfRatios));
   yvalues = {'V1','V2','V3','V4','V5',...
        'V6','V7','V8','V9','V10'};
   cmap = pink;
   cmap = cmap(end:-1:1,:);
   %% HeatMap Apico-Basal transitions VS Voronoi type VS Surface ratio
%    close all
%    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
%     
%    if labelHyde
%         heatmap(xvalues,yvalues,voronoiNTransitions,'CellLabelColor','none');
%    else
%         heatmap(xvalues,yvalues,voronoiNTransitions,'CellLabelFormat','%.2f');
%    end
%    title('Average apico-basal transitions');
%    xlabel('surface ratio');
%    ylabel('Voronoi type');
%    colormap(cmap);
%    
%    set(gca,'FontSize', 24,'FontName','Helvetica');
%    
% %    if labelHyde
% %        print(h,[folderName 'heatMaps\heatMapApico-basalTransitions_noText_sr' num2str(max(srOfInterest)) '_' date '.tif'],'-dtiff','-r300')
% %        savefig(h,[folderName 'heatMaps\heatMapApico-basalTransitions_noText_sr' num2str(max(srOfInterest)) '_' date '.fig'])
% %    else
% %        print(h,[folderName 'heatMaps\heatMapApico-basalTransitions_sr' num2str(max(srOfInterest)) '_' date '.tif'],'-dtiff','-r300')
% %        savefig(h,[folderName 'heatMaps\heatMapApico-basalTransitions_sr' num2str(max(srOfInterest)) '_' date '.fig'])
% %    end
% 
%    
%    %% HeatMap %Scutoids VS Voronoi type VS Surface ratio
%    close all
%    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
%     
%    if labelHyde
%           heatmap(xvalues,yvalues,voronoiNScutoids*100,'CellLabelColor','none');
%    else
%           heatmap(xvalues,yvalues,voronoiNScutoids*100,'CellLabelFormat','%.1f %%');
%    end
%    title('Average percentage of scutoids');
%    xlabel('surface ratio');
%    ylabel('Voronoi type');
%    colormap(cmap);
% 
%    set(gca,'FontSize', 24,'FontName','Helvetica');
%    
% %    if labelHyde
% %        print(h,[folderName 'heatMaps\heatMapPercentageScutoids_noText_sr' num2str(max(srOfInterest)) '_' date '.tif'],'-dtiff','-r300')
% %        savefig(h,[folderName 'heatMaps\heatMapPercentageScutoids_noText_sr' num2str(max(srOfInterest)) '_' date '.fig'])
% %    else
% %        print(h,[folderName 'heatMaps\heatMapPercentageScutoids_sr' num2str(max(srOfInterest)) '_'  date],'-dtiff','-r300')
% %        savefig(h,[folderName 'heatMaps\heatMapPercentageScutoids_sr' num2str(max(srOfInterest)) '_' date])
% %    end
% 
% 
%    %% HeatMap 3DNeighs VS Voronoi type VS Surface ratio
%    close all
%    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
%     
%    if labelHyde
%         heatmap(xvalues,yvalues,voronoiN3DNeighs,'CellLabelColor','none');
%    else
%         heatmap(xvalues,yvalues,voronoiN3DNeighs,'CellLabelFormat','%.2f');
%    end
%    title('Average 3D neighbours');
%    xlabel('surface ratio');
%    ylabel('Voronoi type');
%    colormap(cmap);
%    
%    set(gca,'FontSize', 24,'FontName','Helvetica');
%    
% %    if labelHyde
% %        print(h,[folderName 'heatMaps\heatMap3DNeighs_noText_sr' num2str(max(srOfInterest)) '_' date '.tif'],'-dtiff','-r300')
% %        savefig(h,[folderName 'heatMaps\heatMap3DNeighs_noText_sr' num2str(max(srOfInterest)) '_' date '.fig'])
% %    else
% %        print(h,[folderName 'heatMaps\heatMap3DNeighs_sr' num2str(max(srOfInterest)) '_' date '.tif'],'-dtiff','-r300')
% %        savefig(h,[folderName 'heatMaps\heatMap3DNeighs_sr' num2str(max(srOfInterest)) '_' date '.fig'])
% %    end

    %% HeatMap poorGetRicher at some SR (1.5, 2 and 5)
    
    selectedSRs = [1.5 2 5];
    %selectedSRs = [1.75 4];
    xvalues = [4 5 6 7 8];
    
    for nSR = selectedSRs
        idSR = ismember(surfRatios,nSR); 
        for nVoronoi = 1:length(totalVoronoiNeighPerLayer)
            vorNneighPerLayer = totalVoronoiNeighPerLayer{nVoronoi};
            if contains(namePoorGetRicher,'BasalToApical')
                neighInit = vorNneighPerLayer(:,idSR);
            else
                neighInit = vorNneighPerLayer(:,1);
            end
            
            neighInitTotalRep = horzcat(neighInit{:,:})';
            
            group4 = ismember(neighInitTotalRep,4);
            group5 = ismember(neighInitTotalRep,5);
            group6 = ismember(neighInitTotalRep,6);
            group7 = ismember(neighInitTotalRep,7);
            group8 = ismember(neighInitTotalRep,8);
            
            vorNwonN = totalVoronoiWonNeigh{nVoronoi};
            
            if contains(namePoorGetRicher,'BasalToApical')
                vorNwonNSR = vorNwonN(:,idSR);
                vorNwonNSR1 = vorNwonN(:,1);
                vorNwonNSRTotalRep = cell2mat(horzcat(vorNwonNSR1{:,:})') - cell2mat(horzcat(vorNwonNSR{:,:})');
            else
                vorNwonNSR = vorNwonN(:,idSR);
                vorNwonNSRTotalRep = cell2mat(horzcat(vorNwonNSR{:,:})');
            end
            
            
            
            meanWonGroup4vN(nVoronoi) = mean(vorNwonNSRTotalRep(group4));
            stdWonGroup4vN(nVoronoi) = std(vorNwonNSRTotalRep(group4));
            meanWonGroup5vN(nVoronoi) = mean(vorNwonNSRTotalRep(group5));
            stdWonGroup5vN(nVoronoi) = std(vorNwonNSRTotalRep(group5));
            meanWonGroup6vN(nVoronoi) = mean(vorNwonNSRTotalRep(group6));
            stdWonGroup6vN(nVoronoi) = std(vorNwonNSRTotalRep(group6));
            meanWonGroup7vN(nVoronoi) = mean(vorNwonNSRTotalRep(group7));
            stdWonGroup7vN(nVoronoi) = std(vorNwonNSRTotalRep(group7));
            meanWonGroup8vN(nVoronoi) = mean(vorNwonNSRTotalRep(group8));
            stdWonGroup8vN(nVoronoi) = std(vorNwonNSRTotalRep(group8));

        end
        
        matrixMeanHM = [meanWonGroup4vN',meanWonGroup5vN',meanWonGroup6vN',meanWonGroup7vN',meanWonGroup8vN'];
%         if nSR==1.75 || nSR==4
%             if nSR==1.75
%                 matrixMeanHMAux1 = [meanWonGroup4vN(8)',meanWonGroup5vN(8)',meanWonGroup6vN(8)',meanWonGroup7vN(8)',meanWonGroup8vN(8)'];
%             else
%                 matrixMeanHMAux2 = [meanWonGroup4vN(8)',meanWonGroup5vN(8)',meanWonGroup6vN(8)',meanWonGroup7vN(8)',meanWonGroup8vN(8)'];
% 
%                 folderSalGland = ['..\..\..\LimeSeg_Pipeline\docs\figuresMathPaper\lewis2D_3D_averagePolygon_AreasDistribution_04-Nov-2019.mat'];
%                 load(folderSalGland,'totalSidesTotalApical')
%                 sidesTotalApical = arrayfun(@(x) mean(totalSidesTotalApical{x-3}-x),4:9,'UniformOutput',false);
%                 matrixMeanHMAux= [[sidesTotalApical{1},sidesTotalApical{2},sidesTotalApical{3},sidesTotalApical{4},sidesTotalApical{5}];...
%                     matrixMeanHMAux1;matrixMeanHMAux2];
%                 yvaluesAux={'Sal. Gland','V8_SR1.75', 'V8_SR4'};
%                 
%                 h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
%                 if labelHyde
%                     heatmap(xvalues,yvaluesAux,matrixMeanHMAux,'CellLabelColor','none');
%                 else
%                     heatmap(xvalues,yvaluesAux,matrixMeanHMAux,'CellLabelFormat','%.2f');
%                 end
%                 
%                 title(['Average 3D neighbours ' namePoorGetRicher]);
%                 xlabel('number of sides cell-group');
%                 ylabel('Voronoi type');
%                 colormap(cmap);
% 
%                 set(gca,'FontSize', 24,'FontName','Helvetica');
% 
%                 if labelHyde
%                     print(h,[folderName 'heatMaps\heatMapPoorGetRicher_' namePoorGetRicher '_Glands_noText_' date '.tif'],'-dtiff','-r300')
%                     savefig(h,[folderName 'heatMaps\heatMapPoorGetRicher_' namePoorGetRicher '_Glands_noText_' date '.fig'])
%                 else
%                     print(h,[folderName 'heatMaps\heatMapPoorGetRicher' namePoorGetRicher '_Glands_' date '.tif'],'-dtiff','-r300')
%                     savefig(h,[folderName 'heatMaps\heatMapPoorGetRicher' namePoorGetRicher '_Glands_' date '.fig'])
%                 end
%                 
%             end
%         end

        
        if labelHyde
            heatmap(xvalues,yvalues,matrixMeanHM,'CellLabelColor','none');
        else
            heatmap(xvalues,yvalues,matrixMeanHM,'CellLabelFormat','%.2f');
        end
        title(['Average 3D neighbours ' namePoorGetRicher ' - SR ' num2str(nSR)]);
        xlabel('number of sides cell-group');
        ylabel('Voronoi type');
        colormap(cmap);

        set(gca,'FontSize', 24,'FontName','Helvetica');
       
        if labelHyde
            print(h,[folderName 'heatMaps\heatMapPoorGetRicher_' namePoorGetRicher '_SR' num2str(nSR) '_noText_' date '.tif'],'-dtiff','-r300')
            savefig(h,[folderName 'heatMaps\heatMapPoorGetRicher_' namePoorGetRicher '_SR' num2str(nSR) '_noText_' date '.fig'])
        else
            print(h,[folderName 'heatMaps\heatMapPoorGetRicher' namePoorGetRicher '_SR' num2str(nSR) '_' date '.tif'],'-dtiff','-r300')
            savefig(h,[folderName 'heatMaps\heatMapPoorGetRicher' namePoorGetRicher '_SR' num2str(nSR) '_' date '.fig'])
        end
        
 
%         h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
%         matrixStdHM = [stdWonGroup4vN',stdWonGroup5vN',stdWonGroup6vN',stdWonGroup7vN',stdWonGroup8vN'];
%         if labelHyde
%             heatmap(xvalues,yvalues,matrixStdHM,'CellLabelColor','none');
%         else
%             heatmap(xvalues,yvalues,matrixStdHM,'CellLabelFormat','%.2f');
%         end
%         title(['Std 3D neighbours ' namePoorGetRicher ' - SR ' num2str(nSR)]);
%         xlabel('number of sides cell-group');
%         ylabel('Voronoi type');
%         colormap(ones(100,3));
%         set(gca,'FontSize', 24,'FontName','Helvetica');

%         if labelHyde
%             print(h,[folderName 'heatMaps\heatMapPoorGetRicherStd_' namePoorGetRicher '_SR' num2str(nSR) '_noText_' date '.tif'],'-dtiff','-r300')
%             savefig(h,[folderName 'heatMaps\heatMapPoorGetRicherStd_' namePoorGetRicher '_SR' num2str(nSR) '_noText_' date '.fig'])
%         else
%             print(h,[folderName 'heatMaps\heatMapPoorGetRicherStd_' namePoorGetRicher '_SR' num2str(nSR) '_' date '.tif'],'-dtiff','-r300')
%             savefig(h,[folderName 'heatMaps\heatMapPoorGetRicherStd_' namePoorGetRicher '_SR' num2str(nSR) '_' date '.fig'])
%         end
    end
    
%     % n total VS n apico_basal transitions
%     close all
%     h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on'); 
%     for voronoiNumber = size(voronoiNTransitions,1) : -1 : 1
%         switch voronoiNumber
%             case 1,                colorPlot = [240/255,240/255,240/255];
%             case 2,                colorPlot = [210/255,210/255,210/255];
%             case 3,                colorPlot = [190/255,190/255,190/255];
%             case 4,                colorPlot = [165/255,165/255,165/255];
%             case 5,                colorPlot = [135/255,135/255,135/255];
%             case 6,                colorPlot = [110/255,110/255,110/255];
%             case 7,                colorPlot = [85/255,85/255,85/255];
%             case 8,                colorPlot = [60/255,60/255,60/255];
%             case 9,                colorPlot = [35/255,35/255,35/255];
%             case 10,               colorPlot = [0/255,0/255,0/255];
%         end
%         hold on  
%         plot(voronoiNTransitions(voronoiNumber,:),voronoiN3DNeighs(voronoiNumber,:),'o','MarkerSize',5,'MarkerFaceColor',colorPlot,'MarkerEdgeColor',[0 0 0])
%         %legend(['Voronoi ' num2str(voronoiNumber)])
%         title('n total vs n api-basal transitions ')
%         ylabel('n total')
%         xlabel('n apico basal transitions')
%         set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','on','TickDir','out','Box','off'); 
%     end
%       legend(fliplr(yvalues))
%     xlim([-0.25, max(voronoiNTransitions(:))+0.5])
%     ylim([5.5 (max(voronoiN3DNeighs(:)) + 0.5)])
% 
% %     print(h,[folderName 'heatMaps\n3D_apicoBasal_SR' num2str(max(srOfInterest)) '_' date '.tif'],'-dtiff','-r300')
% %     savefig(h,[folderName 'heatMaps\n3D_apicoBasal_SR' num2str(max(srOfInterest)) '_' date '.fig'])
   
end