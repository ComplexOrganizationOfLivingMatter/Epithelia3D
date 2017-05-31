function representAndSaveFigureWithColourfulCells( L_original,numCells,seeds,directory,name2save,extension)

    figure('Visible','off');
    imshow(L_original,colorcube(numCells))
    for k=1:numCells
        text(seeds(k,2),seeds(k,1),sprintf('%d',k),'Color','black','HorizontalAlignment','center','VerticalAlignment','middle','FontSize',4);
    end
    
    if ~exist([directory  name2save])  
        mkdir([directory  name2save])
    end
    
    print('-f1','-dtiff','-r300',[directory name2save '\' name2save extension '.tif'])
    close all
end

