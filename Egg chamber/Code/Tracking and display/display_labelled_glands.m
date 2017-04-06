function [fig]=display_labelled_glands(L_img_previous,mask,n,n_max,H,W)
%Method to plot in screen labelled cells

    s1=regionprops(L_img_previous,'Centroid');
    s2=regionprops(mask,'Centroid');

    fig=figure;

    if n<n_max
        imshow([L_img_previous,mask]);%,L_img_next]);
    else
        imshow([L_img_previous,mask]);
    end

    hold on

    for k=1:numel(s1)
        c1=s1(k).Centroid;
        text(c1(1),c1(2),sprintf('%d',k),'HorizontalAlignment','center','VerticalAlignment','middle','Color','Blue','FontSize',6);
    end

    for k=1:numel(s2)
        c2=s2(k).Centroid;
        if k>2000
            text(c2(1)+W,c2(2),sprintf('%d',k),'HorizontalAlignment','center','VerticalAlignment','middle','Color',[1 0 0],'FontSize',6);
        end
        if k<2000 && k>1000
            text(c2(1)+W,c2(2),sprintf('%d',k),'HorizontalAlignment','center','VerticalAlignment','middle','Color',[0 1 0],'FontSize',6);
        end
        if k<1000
            text(c2(1)+W,c2(2),sprintf('%d',k),'HorizontalAlignment','center','VerticalAlignment','middle','Color','Blue','FontSize',6);
        end    

    end

    if n~=n_max
        title(['frame ' num2str(n-1) ' - frame ' num2str(n) ' - frame ' num2str(n+1)])
    else
        title(['frame ' num2str(n-1) ' - frame ' num2str(n)])
    end

    hold off

end

