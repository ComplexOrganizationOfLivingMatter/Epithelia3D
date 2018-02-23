function createScatterPolar( angleTran,lengthTran,angleNoTran,lengthNoTran,titleFig )

    %polarscatter(deg2rad(angleWT_noTran),lengthEdge_noTran,50,'o','MarkerEdgeColor',[1 0 0],'LineWidth',2);
    polarscatter(deg2rad(angleNoTran),lengthNoTran,50,'o','MarkerFaceColor',[1 102/255 0],'MarkerEdgeColor',[0,0,0]);

    pause;
    ax=gca;
    ax.ThetaZeroLocation='right';
    % %ax.ThetaDir='clockwise';

    ax.ThetaLimMode='manual';
    ax.ThetaLim=[0,90];
    ax.RLimMode='manual';
    ax.GridAlpha=1;
    ax.LineWidth=1;

    ax.FontName='Helvetica-Narrow';

    ax.FontSize=30;


    hold on
    %polarscatter(deg2rad(angleWT_tran),lengthEdge_Tran,50,'o','MarkerEdgeColor',[20 156 0]/255,'LineWidth',2);
    polarscatter(deg2rad(angleTran),lengthTran,50,'o','MarkerFaceColor',[102 204 204]/255,'MarkerEdgeColor',[0,0,0]);
    
    pause;

    title(titleFig, 'FontSize', 16);

    print(['results\scatterPolar_' strrep(titleFig,' ','') '_' date],'-dtiff','-r300')

end

