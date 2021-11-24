function [logisticEulerTable] = fittingFlintstonesLaw_variableBeta(SR,n3d_mean,n3d_std,upperBoundNmax,n3d_0,colorPlot,path2save,name)

%%Default settings suggestions
%nTotalCells = number of total valid cells;
%upperBoundNmax= (nTotalCells+5)/2; %theoretically calculated. Other option use upperBoundNmax = inf;
% n3d_0 = arrayTableInd(2,1); %other option use n3d_0 = 6;

    
%% figure fitting Euler 3D - Logistic function
    %Global min
  
%     %variables to fit: alpha, beta0, d, s0, Nmax
%     betaVariable = beta0*(1+(d/2)*(s-s0)^2);
%     upFormula = exp(alpha + Nmax*s*alpha*betaVariable)*(-n3d_0 + Nmax)+ exp(alpha*(s + Nmax*betaVariable))*Nmax*(-1+n3d_0*betaVariable);
%     downFormula = exp(alpha + Nmax*s*alpha*betaVariable)*(-n3d_0 + Nmax)*betaVariable + exp(alpha*(s+Nmax*beta0))*(-1+n3d_0*betaVariable);
%     n(s)=upFormula/downFormula;
    
    addpath(genpath('lib'))

    rng default % For reproducibility
    vBound = 1e-20;
    gs = GlobalSearch('FunctionTolerance',1e-30,'XTolerance',1e-30,'NumTrialPoints', 1e+6);
     
    
    %p0 is just an arbitrary initial searching point to look for the global
    %minimum
    p0=[vBound+0.1,vBound+0.1,vBound+0.1,1+vBound,n3d_0+vBound];
    lb = [vBound,vBound,vBound,1,n3d_0];
    ub = [inf,inf,inf,max(SR),upperBoundNmax];
    
  
    global xdata;
    global ydata;
    global n3d_s1;
%     global Nmax;
    
    xdata=SR;
    ydata=n3d_mean;
    n3d_s1 = n3d_0;
%     Nmax=n_max;

%     opts = optimoptions(@fmincon,'UseParallel',true);
    problem = createOptimProblem('fmincon','x0',p0,...
        'objective',@fittingLogFunc_variableBeta,'lb',lb,'ub',ub);%,'options',opts);
    
   
    sol = run(gs,problem);
    alpha = sol(1);
    beta0 = sol(2);
    d = sol(3);
    s0 = sol(4);
    Nmax = sol(5);
    
    coeffvals = [sol];

    
    sse = fittingLogFunc_variableBeta(sol);
    global rsquare_value;
    
%     stringFunction = ['(exp(alpha + Nmax*s*alpha*(beta0*(1+(d/2)*(s-s0)^2)))*(-' num2str(n3d_0) ' + Nmax)+ exp(alpha*(s + Nmax*(beta0*(1+(d/2)*(s-s0)^2))))*Nmax*(-1+' num2str(n3d_0) '*(beta0*(1+(d/2)*(s-s0)^2))))/(exp(alpha + Nmax*s*alpha*(beta0*(1+(d/2)*(s-s0)^2)))*(-' num2str(n3d_0) ' + Nmax)*(beta0*(1+(d/2)*(s-s0)^2)) + exp(alpha*(s+Nmax*beta0))*(-1+' num2str(n3d_0) '*(beta0*(1+(d/2)*(s-s0)^2))))'];
    stringFunction = ['(exp(alpha + Nmax*s*alpha*(beta0*(1+(d/2)*(s-s0)^2)))*(-' num2str(n3d_0) ' + Nmax)+ exp(alpha*(s + Nmax*(beta0*(1+(d/2)*(s-s0)^2))))*Nmax*(-1+' num2str(n3d_0) '*(beta0*(1+(d/2)*(s-s0)^2))))/(exp(alpha + Nmax*s*alpha*(beta0*(1+(d/2)*(s-s0)^2)))*(-' num2str(n3d_0) ' + Nmax)*(beta0*(1+(d/2)*(s-s0)^2)) + exp(alpha*(s+Nmax*beta0*(1+(d/2)*(s-s0)^2)))*(-1+' num2str(n3d_0) '*(beta0*(1+(d/2)*(s-s0)^2))))'];

    f = fittype(stringFunction,'independent','s','coefficients',{'alpha','beta0','d','s0','Nmax'});
    myfitLog_betaVariable = cfit(f,alpha,beta0,d,s0,Nmax);
    



    logisticEulerTable = array2table([coeffvals sse rsquare_value],'VariableNames',{'alpha','beta0','d','s0','Nmax','sse','rsquared'}, 'RowNames',{name});

    h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
   

    %maxFuncLine = max(SR)+1;
    maxFuncLine = max(SR)+5;
    plot(myfitLog_betaVariable, [1 maxFuncLine], [6 myfitLog_betaVariable(maxFuncLine)])
    
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
    
    if ~isempty(path2save)
        print(h,fullfile(path2save, ['euler3D_' name '_Logistic_BetaVariable_noLegend_' date]),'-dtiff','-r300')
        legend({[name ' - R^2 ' num2str(rsquare_value)]})
        savefig(h,fullfile(path2save, ['euler3D_' name '_Logistic_BetaVariable_' date]))
        print(h,fullfile(path2save, ['euler3D_' name '_Logistic_BetaVariable_legend_' date]),'-dtiff','-r300')
    else
        close all
    end

    h1=figure;
    betaVariable = 'beta0*(1+(d/2)*(s-s0)^2)';
    f = fittype(betaVariable,'independent','s','coefficients',{'beta0','d','s0'});
    mybetaVariable = cfit(f,beta0,d,s0);
    plot(mybetaVariable, [1 maxFuncLine], [0 mybetaVariable(maxFuncLine)])
    delete(children(2));
    set(children(1),'LineWidth',2,'Color',colorPlot)  
    title(name)
    xlabel('s')
    ylabel('beta(s)')
    legend('off')
    print(h1,fullfile(path2save, ['betaVariable_' name '_' date]),'-dtiff','-r300')
    savefig(h1,fullfile(path2save, ['betaVariable_' name '_' date]))
    
    close all
end

