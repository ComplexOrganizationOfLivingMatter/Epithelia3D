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
    
    sseIt=zeros(size(xdata));
    f=zeros(size(xdata));
    b = (6*d - exp(1/c)*(Nmax-6))/Nmax;

    for i=1:length(xdata)
       sseIt(i)= (ydata(i) - Nmax*(((6*d - exp(1/c)*(Nmax-6))/Nmax) + exp(xdata(i)/c))/(d + exp(xdata(i)/c))).^2;
       f(i) = Nmax*(b + exp(xdata(i)/c))/(d + exp(xdata(i)/c));
    end
    
    %c > 0      x(1)
    %d < 0      x(2)
    %If d < -1 then c*ln(-d) < 1.
    %Nmax > 0   x(3) 
    %d > b
    sse = sum(sseIt);
    
    
    if c<=0 || d>=0 || Nmax < 6 || d <= b
        sse = 100;
    end
    
    if d < -1 && c*log(-d)>=1
       sse =100; 
    end
    
    global rsquare;
    
    rsquare = 1 - sum((f(:)-mean(ydata(:))).^2)/sum((ydata(:)-mean(ydata(:))).^2);

       
end

%https://es.mathworks.com/help/matlab/math/example-curve-fitting-via-optimization.html

%sse = sseval(x,tdata,ydata) A = x(1); lambda = x(2); sse = sum((ydata - A*exp(-lambda*tdata)).^2);
%fun = @(x)sseval(x,tdata,ydata);
%x0 = rand(2,1); bestx = fminsearch(fun,x0);