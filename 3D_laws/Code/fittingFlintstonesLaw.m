function [logisticEulerTable] = fittingFlintstonesLaw(SR,n3d_mean,n3d_std,av_totalCells,colorPlot,path2save,name)

    
%% figure fitting Euler 3D - Logistic function
    %Global min
    
    %fixing n(s=1)=6   ---->   b = (6*d - exp(1/c)*(Nmax-6))/Nmax;
    %'n(s)= Nmax*(((6*d - exp(1/c)*(Nmax-6))/Nmax) + exp(s/c))/(d + exp(s/c))';
  
    %restrictions c>0,
    
    %c > 0      x(1)
    %d < 0      x(2)
    %If d < -1 then c*ln(-d) < 1.
    %Nmax > 0   x(3) 
    %d > b
    %b is the dependent variable to force <m(s=1)> = 6. 
    
    addpath(genpath('lib'))
    
    n3d_0 = 6;
%     n3d_0=n3d_mean(1,1);
    
    rng default % For reproducibility
    gs = GlobalSearch;
     
    vBound = 0.1;
    
    %paper Nmax definition
    upperBoundNmax= (av_totalCells+5)/2;
    
    p0=[vBound,-vBound,n3d_0];
    lb = [vBound,-inf,n3d_0];
    ub = [inf,-vBound,upperBoundNmax];
    
%     p0=[vBound,-vBound];
%     lb = [vBound,-inf];
%     ub = [inf,-vBound];
    
    global xdata;
    global ydata;
    global n3d_s1;
%     global Nmax;
    
    xdata=SR;
    ydata=n3d_mean;
    n3d_s1 = n3d_0;
%     Nmax=n_max;

    problem = createOptimProblem('fmincon','x0',p0,...
        'objective',@fittingLogFunc,'lb',lb,'ub',ub);%),'options',options);
    
    sol = run(gs,problem);
    c = sol(1);
    d = sol(2);
    Nmax = sol(3);
    
    b = (n3d_0*d - exp(1/c)*(Nmax-n3d_0))/Nmax;
    coeffvals = [b sol];
%     coeffvals = [b sol Nmax];

    
    sse = fittingLogFunc(sol);
    global rsquare_value;
    
    f = fittype(['Nmax*(((' num2str(n3d_0) '*d - exp(1/c)*(Nmax-' num2str(n3d_0) '))/Nmax) + exp(s/c))/(d + exp(s/c))'],'independent','s','coefficients',{'c','d','Nmax'});
%     f = fittype([num2str(n_max) '*(((' num2str(n3d_0) '*d - exp(1/c)*(' num2str(n_max) '-' num2str(n3d_0) '))/' num2str(n_max) ') + exp(s/c))/(d + exp(s/c))'],'independent','s','coefficients',{'c','d'});
    myfitLogConstrained = cfit(f,c,d,Nmax);
%     myfitLogConstrained = cfit(f,c,d);
    

    alpha = b/(c*(b-d));
    beta = d/(b*Nmax);

    logisticEulerTable = array2table([coeffvals sse rsquare_value alpha beta],'VariableNames',{'b','c','d','Nmax','sse','rsquared','alpha', 'beta'}, 'RowNames',{name});

    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
   
    opts = fitoptions('Method','NonlinearLeastSquares','Lower',0,...
               'Upper',Inf,'StartPoint',0);
    opts.Display = 'Off';
    
    %maxFuncLine = max(SR)+1;
    maxFuncLine = max(SR)+5;
    plot(myfitLogConstrained, [1 maxFuncLine], [6 myfitLogConstrained(maxFuncLine)])
    
    children = get(gca, 'children');
    delete(children(2));
    set(children(1),'LineWidth',2,'Color',colorPlot)  
    
    hold on
    errorbar(SR,n3d_mean,n3d_std,'o','MarkerSize',5,...
            'Color',[0 0 0],'MarkerFaceColor',colorPlot,'LineWidth',0.2)
    title(name)
    xlabel('surface ratio')
    ylabel('neighbours total')
    
%     preD = predint(myfitLogConstrained,[SR max(SR)+1],0.95,'observation','off');
%     plot([SR max(SR)+1],preD,'--','Color',colorPlot)
    x = [0 maxFuncLine+1];
    y = [6 6];
    line(x,y,'Color','red','LineStyle','--')
    hold off
    ylim([5,12]);
    yticks(5:12)  
    xlim([0,maxFuncLine+1]);
    xticks(0:maxFuncLine+1)  
   
    legend('hide')
    
    print(h,fullfile(path2save, ['euler3D_' name '_LogisticConstrained_noLegend_' date]),'-dtiff','-r300')
    legend({[name ' - R^2 ' num2str(rsquare_value)]})
    savefig(h,fullfile(path2save, ['euler3D_' name '_LogisticConstrained_' date]))
    print(h,fullfile(path2save, ['euler3D_' name '_LogisticConstrained_legend_' date]),'-dtiff','-r300')
    


end

