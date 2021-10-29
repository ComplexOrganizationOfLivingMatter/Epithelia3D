function sse=fittingLogFunc(x)

%'n(s)= Nmax*(b + exp(s/c))/(d + exp(s/c))';
%fixing n(s=1)=6   ---->   d=(Nmax*(exp(1/c)+b)/6) - exp(1/c);
%'n(s)= Nmax*(b + exp(x/c))/(((Nmax*(exp(1/c)+b)/6) - exp(1/c)) + exp(x/c));

%fixing n(s=1)=6   ---->   b = (6*d - exp(1/c)*(Nmax-6))/Nmax;
%'n(s)= Nmax*(((6*d - exp(1/c)*(Nmax-6))/Nmax) + exp(s/c))/(d + exp(s/c))';
  

    c = x(1);
    d = x(2);
    Nmax = x(3);


%     fitVal=zeros(size(xdata));
% 
%     for i=1:length(xdata)
%         fitVal(i) = Nmax*(((6*d - exp(1/c)*(Nmax-6))/Nmax) + exp(xdata(i)/c))/(d + exp(xdata(i)/c));
%     end
    global xdata;
    global ydata;
    global n3d_s1;
    %%if Nmax is fixed...else Nmax=x(3);
%     global Nmax;
    
    sseIt=zeros(size(xdata));
    f=zeros(size(xdata));
    b = (n3d_s1*d - exp(1/c)*(Nmax-n3d_s1))/Nmax;

    for i=1:length(xdata)
       sseIt(i)= (ydata(i) - Nmax*(((n3d_s1*d - exp(1/c)*(Nmax-n3d_s1))/Nmax) + exp(xdata(i)/c))/(d + exp(xdata(i)/c))).^2;
       f(i) = Nmax*(b + exp(xdata(i)/c))/(d + exp(xdata(i)/c));
    end
    
    %c > 0      x(1)
    %d < 0      x(2)
    %If d < -1 then c*ln(-d) < 1.
    %Nmax > 0   x(3) 
    %d > b
    sse = sum(sseIt);
    
    
    if (c<=0) | (d>=0) | (Nmax < n3d_s1) | (d <= b) | ((d < -1) & (c*log(-d)>=1)) | (((d/(b*Nmax)) < 0.01) | (b/(c*(b-d))) < 0.2)
        sse = 100;
    end
    
   
%     %%experimental limitation in beta magnitude scale
%     if ((d/(b*Nmax)) < 0.01) | (b/(c*(b-d))) < 0.2
%        sse = 100; 
%     else
%         sse =1.
%     end   
%     
    global rsquare_value;
    
    rsquare_value = rsquare(ydata, f);

       
end

%https://es.mathworks.com/help/matlab/math/example-curve-fitting-via-optimization.html

%sse = sseval(x,tdata,ydata) A = x(1); lambda = x(2); sse = sum((ydata - A*exp(-lambda*tdata)).^2);
%fun = @(x)sseval(x,tdata,ydata);
%x0 = rand(2,1); bestx = fminsearch(fun,x0);