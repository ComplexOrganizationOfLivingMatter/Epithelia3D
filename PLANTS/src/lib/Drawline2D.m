function [xn, yn] = Drawline2D(X0, Y0, X1, Y1)
    xn=[];
    yn=[];
    for n = 0:(1/round(sqrt((X1-X0)^2 + (Y1-Y0)^2))):1 
        xn(end+1) = round(X0 +(X1 - X0)*n); 
        yn(end+1) = round(Y0 +(Y1 - Y0)*n); 
    end
end