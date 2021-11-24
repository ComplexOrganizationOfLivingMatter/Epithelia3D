function poorGetRicherWithBalls (path2save,gain4c,gain5c,gain6c,gain7c,gain8c)
    
    %%  figure Relation apical - basal nSides. 'Poor get richer'
    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
    hold on

    x = [gain4c(:);gain5c(:);gain6c(:);gain7c(:);gain8c(:)];

    g = [zeros(length(gain4c), 1); ones(length(gain5c), 1);2*ones(length(gain6c), 1);...
        3*ones(length(gain7c), 1);4*ones(length(gain8c), 1)];

    H = notBoxPlot(x,g,'markMedian',true,'jitter', 0.10);

    set([H.data],'MarkerSize',4,...
        'markerFaceColor','none',...
        'markerEdgeColor', 'none')
   
    %mean line color
    set([H.mu],'color','k')

    for ii=1:length(H)
        set(H(ii).perc1,'FaceColor','none',...
                       'EdgeColor','k','lineStyle','-')

        set(H(ii).sd,'FaceColor','none',...
                       'EdgeColor',[0.6 0.6 0.6],'lineStyle',':')        
        set(H(ii).sd1,'Color',[0.6 0.6 0.6])     
        set(H(ii).sd2,'Color',[0.6 0.6 0.6])            

    end

    x = {gain4c,gain5c,gain6c,gain7c,gain8c};
    c = [1 0 0];
%     c = [27/255,39/255,201/255];
    for nSideAp = 1:5
        freqSides = x{nSideAp};
        numbers=unique(freqSides);       %list of elements
        countN=hist(freqSides,numbers); 
        countP = countN./sum(countN);

        for nUniqSides = 1:length(numbers)
            hold on
            scatter(nSideAp-1, numbers(nUniqSides),2300*countP(nUniqSides), 'filled','MarkerFaceColor',c, 'MarkerEdgeColor', 'k','MarkerFaceAlpha',1)
            text(nSideAp-1,numbers(nUniqSides),num2str(countN(nUniqSides)),'HorizontalAlignment','center')
        end
    end

    ylim([-1 7])
    title('relation apical sides - added neigh')
    xlabel('number of sides - apical')
    ylabel('number gain total')
    set(gca,'FontSize', 24,'FontName','Helvetica','YGrid','off','TickDir','out','Box','off');

    xticklabels({'4','5','6','7','8'})

    savefig(h,fullfile(path2save,['fig_PoorGetRicher_nonboxplot_OnlyText_' date]));
    print(h,fullfile(path2save,['fig_PoorGetRicher_nonboxplot_OnlyText_' date]),'-dtiff','-r300');

end