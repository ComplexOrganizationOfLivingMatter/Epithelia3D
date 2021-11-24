function sse=fittingLogFunc_variableBeta(x)


%     %variables to fit: alpha, beta0, d, s0, Nmax
%     betaVariable = beta0*(1+(d/2)*(s-s0)^2);
%     upFormula = exp(alpha + Nmax*s*alpha*betaVariable)*(-n3d_0 + Nmax)+ exp(alpha*(s + Nmax*betaVariable))*Nmax*(-1+n3d_0*betaVariable);
%     downFormula = exp(alpha + Nmax*s*alpha*betaVariable)*(-n3d_0 + Nmax)*betaVariable + exp(alpha*(s+Nmax*beta0))*(-1+n3d_0*betaVariable);
%     n(s)=upFormula/downFormula;
  

    alpha = x(1);
    beta0 = x(2);
    d = x(3);
    s0 = x(4);
    Nmax = x(5);


    global xdata;
    global ydata;
    global n3d_s1;

    
    sseIt=zeros(size(xdata));
    f=zeros(size(xdata));

    for i=1:length(xdata)
       sseIt(i)= (ydata(i) - (exp(alpha + Nmax*xdata(i)*alpha*beta0*(1+(d/2)*(xdata(i)-s0)^2))*(-n3d_s1 + Nmax)+ exp(alpha*(xdata(i) + Nmax*beta0*(1+(d/2)*(xdata(i)-s0)^2)))*Nmax*(-1+n3d_s1*beta0*(1+(d/2)*(xdata(i)-s0)^2)))/...
           (exp(alpha + Nmax*xdata(i)*alpha*(beta0*(1+(d/2)*(xdata(i)-s0)^2)))*(-n3d_s1 + Nmax)*(beta0*(1+(d/2)*(xdata(i)-s0)^2)) + exp(alpha*(xdata(i)+Nmax*beta0*(1+(d/2)*(xdata(i)-s0)^2)))*(-1+n3d_s1*(beta0*(1+(d/2)*(xdata(i)-s0)^2))))).^2;
       
       f(i) = (exp(alpha + Nmax*xdata(i)*alpha*(beta0*(1+(d/2)*(xdata(i)-s0)^2)))*(-n3d_s1 + Nmax)+ exp(alpha*(xdata(i) + Nmax*(beta0*(1+(d/2)*(xdata(i)-s0)^2))))*Nmax*(-1+n3d_s1*(beta0*(1+(d/2)*(xdata(i)-s0)^2))))/...
           (exp(alpha + Nmax*xdata(i)*alpha*beta0*(1+(d/2)*(xdata(i)-s0)^2))*(-n3d_s1 + Nmax)*beta0*(1+(d/2)*(xdata(i)-s0)^2) + exp(alpha*(xdata(i)+Nmax*beta0*(1+(d/2)*(xdata(i)-s0)^2)))*(-1+n3d_s1*beta0*(1+(d/2)*(xdata(i)-s0)^2)));
    end
    
    sse = sum(sseIt)*10;
    
    global rsquare_value;
    
    rsquare_value = rsquare(ydata, f);
    
%     disp(['toMinimize: ' num2str(sse) ' alpha:' num2str(alpha) ' beta0:' num2str(beta0) ' d:' num2str(d) ' s0:' num2str(s0) ' Nmax:' num2str(Nmax) ])

end

%https://es.mathworks.com/help/matlab/math/example-curve-fitting-via-optimization.html

%sse = sseval(x,tdata,ydata) A = x(1); lambda = x(2); sse = sum((ydata - A*exp(-lambda*tdata)).^2);
%fun = @(x)sseval(x,tdata,ydata);
%x0 = rand(2,1); bestx = fminsearch(fun,x0);