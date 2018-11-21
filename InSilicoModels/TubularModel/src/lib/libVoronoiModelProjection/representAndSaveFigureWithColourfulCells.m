function representAndSaveFigureWithColourfulCells( L_original,numCells,seeds,directory,name2save,extension)
%REPRESENTANDSAVEFIGUREWITHCOLOURFULCELLS represent with different colours
%and labels the projected Voronoi cells

    figure('Visible','off');
    colormap(colorcube(numCells));
    image(L_original)
%     set(gca,'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
    set(gca,'Visible','off')
    axis equal

    for k=1:numCells
        text(seeds(k,2),seeds(k,1),sprintf('%d',k),'Color','black','HorizontalAlignment','center','VerticalAlignment','middle','FontSize',4);
    end
    
    spName = strsplit(name2save,'_');
    diagName = [lower(spName{end-1}), spName{end}];
    
    if ~exist([directory diagName '\' name2save ],'dir')  
        mkdir([directory diagName '\' name2save])
    end
    
    print('-f1','-dtiff','-r300',[directory diagName '\' name2save '\' name2save extension '.tiff'])
%     print('-f1','-dpdf','-r300',[directory name2save '\' name2save extension '.pdf'])
    close all
    
    
end

