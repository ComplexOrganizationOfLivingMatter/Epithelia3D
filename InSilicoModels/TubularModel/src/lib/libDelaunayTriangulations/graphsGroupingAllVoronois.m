function graphsGroupingAllVoronois(folderName,cellTotalVoronoiResults)

    
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
   %% HeatMap Apico-Basal transitions VS Voronoi type VS Surface ratio
   close all
   h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
    
   heatmap(xvalues,yvalues,voronoiNTransitions,'CellLabelFormat','%.2f');
   
   title('Average apico-basal transitions');
   xlabel('surface ratio');
   ylabel('Voronoi type');
   colormap(cmap);
   
   set(gca,'FontSize', 24,'FontName','Helvetica');
   
   print(h,[folderName 'heatMaps\heatMapApico-basalTransitions_' date],'-dtiff','-r300')
   savefig(h,[folderName 'heatMaps\heatMapApico-basalTransitions_' date])
    
   %% HeatMap %Scutoids VS Voronoi type VS Surface ratio
   close all
   h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
    
   heatmap(xvalues,yvalues,voronoiNScutoids*100,'CellLabelFormat','%.1f %%');
   title('Average percentage of scutoids');
   xlabel('surface ratio');
   ylabel('Voronoi type');
   colormap(cmap);

   set(gca,'FontSize', 24,'FontName','Helvetica');
   
   print(h,[folderName 'heatMaps\heatMapPercentageScutoids_' date],'-dtiff','-r300')
   savefig(h,[folderName 'heatMaps\heatMapPercentageScutoids_' date])

   %% HeatMap 3DNeighs VS Voronoi type VS Surface ratio
   close all
   h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
    
   heatmap(xvalues,yvalues,voronoiN3DNeighs,'CellLabelFormat','%.2f');
   title('Average 3D neighbours');
   xlabel('surface ratio');
   ylabel('Voronoi type');
   colormap(cmap);
   
   set(gca,'FontSize', 24,'FontName','Helvetica');
   
   print(h,[folderName 'heatMaps\heatMap3DNeighs_' date],'-dtiff','-r300')
   savefig(h,[folderName 'heatMaps\heatMap3DNeighs_' date])

end