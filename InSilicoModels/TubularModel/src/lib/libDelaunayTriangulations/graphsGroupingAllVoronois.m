function graphsGroupingAllVoronois(folderName,cellTotalVoronoiResults,totalVoronoiWonNeigh,totalVoronoiNeighPerLayer,namePoorGetRicher)

    
    voronoiNResults = cellTotalVoronoiResults{1};
    
    surfRatios = table2array(voronoiNResults(1,:));
    voronoiNScutoids = zeros(size(cellTotalVoronoiResults,1),length(surfRatios));
    voronoiNTransitions = zeros(size(cellTotalVoronoiResults,1),length(surfRatios));
    voronoiN3DNeighs = zeros(size(cellTotalVoronoiResults,1),length(surfRatios));

    voronoiNScutoids (1,:) =table2array(voronoiNResults(6,:));
    voronoiNTransitions (1,:) =table2array(voronoiNResults(4,:));
    voronoiN3DNeighs (1,:) =table2array(voronoiNResults(2,:));
    for n= 2 : length(cellTotalVoronoiResults)
        voronoiNResults = cellTotalVoronoiResults{n};
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
%    %% HeatMap Apico-Basal transitions VS Voronoi type VS Surface ratio
%    close all
%    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
%     
%    heatmap(xvalues,yvalues,voronoiNTransitions,'CellLabelFormat','%.2f');
%    
%    title('Average apico-basal transitions');
%    xlabel('surface ratio');
%    ylabel('Voronoi type');
%    colormap(cmap);
%    
%    set(gca,'FontSize', 24,'FontName','Helvetica');
%    
% %    print(h,[folderName 'heatMaps\heatMapApico-basalTransitions_' date],'-dtiff','-r300')
% %    savefig(h,[folderName 'heatMaps\heatMapApico-basalTransitions_' date])
%     
%    %% HeatMap %Scutoids VS Voronoi type VS Surface ratio
%    close all
%    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
%     
%    heatmap(xvalues,yvalues,voronoiNScutoids*100,'CellLabelFormat','%.1f %%');
%    title('Average percentage of scutoids');
%    xlabel('surface ratio');
%    ylabel('Voronoi type');
%    colormap(cmap);
% 
%    set(gca,'FontSize', 24,'FontName','Helvetica');
%    
% %    print(h,[folderName 'heatMaps\heatMapPercentageScutoids_' date],'-dtiff','-r300')
% %    savefig(h,[folderName 'heatMaps\heatMapPercentageScutoids_' date])
% 
%    %% HeatMap 3DNeighs VS Voronoi type VS Surface ratio
%    close all
%    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
%     
%    heatmap(xvalues,yvalues,voronoiN3DNeighs,'CellLabelFormat','%.2f');
%    title('Average 3D neighbours');
%    xlabel('surface ratio');
%    ylabel('Voronoi type');
%    colormap(cmap);
%    
%    set(gca,'FontSize', 24,'FontName','Helvetica');
%    
% %    print(h,[folderName 'heatMaps\heatMap3DNeighs_' date],'-dtiff','-r300')
% %    savefig(h,[folderName 'heatMaps\heatMap3DNeighs_' date])

    %% HeatMap poorGetRicher at some SR (1.5, 2 and 5)
    
    selectedSRs = [1.5 2 5];
    xvalues = [4 5 6 7 8];
    
    for nSR = selectedSRs
        idSR = ismember(surfRatios,nSR); 
        for nVoronoi = 1:length(totalVoronoiNeighPerLayer)
            vorNneighPerLayer = totalVoronoiNeighPerLayer{nVoronoi};
            neighInit = vorNneighPerLayer(:,1);
            
            neighInitTotalRep = horzcat(neighInit{:,:})';
            
            group4 = ismember(neighInitTotalRep,4);
            group5 = ismember(neighInitTotalRep,5);
            group6 = ismember(neighInitTotalRep,6);
            group7 = ismember(neighInitTotalRep,7);
            group8 = ismember(neighInitTotalRep,8);
            
            vorNwonN = totalVoronoiWonNeigh{nVoronoi};
            vorNwonNSR = vorNwonN(:,idSR);
            vorNwonNSRTotalRep = cell2mat(horzcat(vorNwonNSR{:,:})');
            
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
        
        
        h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
        
        matrixMeanHM = [meanWonGroup4vN',meanWonGroup5vN',meanWonGroup6vN',meanWonGroup7vN',meanWonGroup8vN'];

        heatmap(xvalues,yvalues,matrixMeanHM,'CellLabelFormat','%.2f');
        title(['Average 3D neighbours ' namePoorGetRicher ' - SR ' num2str(nSR)]);
        xlabel('number of sides cell-group');
        ylabel('Voronoi type');
        colormap(cmap);

        set(gca,'FontSize', 24,'FontName','Helvetica');
   
        print(h,[folderName 'heatMaps\heatMapPoorGetRicher' namePoorGetRicher '_SR' num2str(nSR) '_' date '.tif'],'-dtiff','-r300')
        savefig(h,[folderName 'heatMaps\heatMapPoorGetRicher' namePoorGetRicher '_SR' num2str(nSR) '_' date '.fig'])
 
        h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
        matrixStdHM = [stdWonGroup4vN',stdWonGroup5vN',stdWonGroup6vN',stdWonGroup7vN',stdWonGroup8vN'];

        heatmap(xvalues,yvalues,matrixStdHM,'CellLabelFormat','%.2f');
        title(['Std 3D neighbours ' namePoorGetRicher ' - SR ' num2str(nSR)]);
        xlabel('number of sides cell-group');
        ylabel('Voronoi type');
        colormap(ones(100,3));
        set(gca,'FontSize', 24,'FontName','Helvetica');

        print(h,[folderName 'heatMaps\heatMapPoorGetRicherStd_' namePoorGetRicher '_SR' num2str(nSR) '_' date '.tif'],'-dtiff','-r300')
        savefig(h,[folderName 'heatMaps\heatMapPoorGetRicherStd_' namePoorGetRicher '_SR' num2str(nSR) '_' date '.fig'])
    end
    
    
end